import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l10n_editor/blocs/editor/editor_bloc.dart';
import 'package:l10n_editor/blocs/project/project_bloc.dart';
import 'package:l10n_editor/config/consts.dart';
import 'package:l10n_editor/l10n_editor_app.dart';
import 'package:l10n_editor/models/azure.dart';
import 'package:l10n_editor/models/git_object.dart';
import 'package:l10n_editor/repositories/azure_devops_repository.dart';
import 'package:l10n_editor/widgets/editor.dart';
import 'package:truesight_flutter/truesight_flutter.dart';

@reflector
@UsePageRoute('/azure-project')
class AzureProjectPage extends StatefulWidget {
  const AzureProjectPage({Key? key}) : super(key: key);

  @override
  State<AzureProjectPage> createState() => _AzureProjectPageState();
}

class _AzureProjectPageState extends State<AzureProjectPage> {
  final _newKeyController = TextEditingController(
    text: '',
  );

  _onGoBack() {
    context.read<EditorBloc>().add(UserResetEvent());
  }

  _save() {
    context
        .read<EditorBloc>()
        .add(UserTriggerOnlineSaveEvent(_selectedRepository!));
  }

  void _showNewKeyModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _newKeyController,
                decoration: const InputDecoration(
                  hintText: 'enter_new_localization_key',
                ),
                validator: (String? newKeyValue) {
                  if (newKeyValue == null) {
                    return AppLocalizations.of(context)!.key_not_null;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _addNewKey,
                child: const Text('Add'),
              ),
            ],
          ),
        );
      },
    );
  }

  _addNewKey() {
    var newKey = _newKeyController.text;
    _newKeyController.text = '';
    context.read<EditorBloc>().add(UserAddedNewKeyEvent(newKey));
    Navigator.pop(context);
  }

  _deleteKey(String recordKey) {
    return () {
      if (recordKey != LOCALE_KEY) {
        context.read<EditorBloc>().add(
              UserDeletedKeyEvent(recordKey),
            );
        return;
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.figma_api_key),
            content:
                Text(AppLocalizations.of(context)!.keyword_not_deleted_desc),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    };
  }

  List<AzureProject> _projects = [];
  List<AzureRepo> _repositories = [];
  List<GitObject> _gitObjects = [];

  String? _selectedProject;
  String? _selectedRepository;

  late AzureDevopsRepository _devopsRepository;

  @override
  void initState() {
    super.initState();
    _devopsRepository = AzureDevopsRepository();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    var projects = await _devopsRepository.projects(personalAccessToken!);
    setState(() {
      _projects = projects;
    });
  }

  String? get personalAccessToken {
    return context.read<ProjectBloc>().state.projectConfig!.azureDevopsToken;
  }

  Future<void> _loadRepositories(String projectId) async {
    setState(() {
      _repositories = [];
      _gitObjects = [];
      _selectedRepository = null;
      _selectedProject = projectId;
    });
    var repositories =
        await _devopsRepository.repos(personalAccessToken!, projectId);
    setState(() {
      _repositories = repositories;
    });
  }

  Future<void> _loadFiles(String repositoryId) async {
    setState(() {
      _gitObjects = [];
      _selectedRepository = repositoryId;
    });
    await _devopsRepository
        .files(personalAccessToken!, _selectedProject!, repositoryId)
        .then((objects) {
      setState(() {
        _gitObjects = objects;
      });
    });
  }

  void _onSubmit() async {
    Map<String, String> fileContents = {};
    for (var file in _gitObjects) {
      if (file.path.startsWith('/lib/l10n') && file.path.endsWith('.arb')) {
        var content = await _devopsRepository.getFileContents(
          personalAccessToken!,
          _selectedProject!,
          _selectedRepository!,
          file.path,
        );
        fileContents[file.path] = content;
      }
    }
    _selectOnlineProject(fileContents);
  }

  _selectOnlineProject(Map<String, String> fileContents) {
    context.read<EditorBloc>().add(UserSelectOnlineProjectEvent(fileContents));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditorBloc, EditorState>(
      builder: (context, state) {
        if (state.hasData &&
            _selectedRepository.runtimeType == String &&
            _selectedRepository != '') {
          var localizedData = state.localizationData!.localizedData;
          var supportedLocales = state.localizationData!.supportedLocales;

          return Editor(
            supportedLocales: supportedLocales,
            localizedData: localizedData,
            onBack: _onGoBack,
            onDeleteKey: _deleteKey,
            onNewKeyModal: _showNewKeyModal,
            onSave: _save,
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text('Azure Devops'),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (_projects.isEmpty)
                const CircularProgressIndicator()
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: DropdownButton<String>(
                        hint: const Text('Select project'),
                        value: _selectedProject,
                        items: _projects
                            .map(
                              (project) => DropdownMenuItem<String>(
                                value: project.id,
                                child: Text(project.name),
                              ),
                            )
                            .toList(),
                        onChanged: (project) {
                          setState(() {
                            _selectedProject = project;
                            _repositories.clear();
                          });
                          if (project != null) {
                            _loadRepositories(project);
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: DropdownButton<String>(
                        hint: const Text('Select repository'),
                        value: _selectedRepository,
                        items: _repositories
                            .map(
                              (repository) => DropdownMenuItem<String>(
                                value: repository.id,
                                child: Text(repository.name),
                              ),
                            )
                            .toList(),
                        onChanged: (repository) async {
                          if (repository != null) {
                            await _loadFiles(repository);
                          }
                          _onSubmit();
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
