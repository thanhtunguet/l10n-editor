import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n_editor/blocs/editor/editor_bloc.dart';
import 'package:l10n_editor/blocs/project/project_bloc.dart';
import 'package:l10n_editor/config/consts.dart';
import 'package:l10n_editor/config/project_type.dart';
import 'package:l10n_editor/l10n_editor_app.dart';
import 'package:l10n_editor/pages/azure_project_page.dart';
import 'package:l10n_editor/pages/editor_form_page.dart';
import 'package:l10n_editor/pages/sync_figma_page.dart';
import 'package:l10n_editor/widgets/home_icon.dart';
import 'package:truesight_flutter/truesight_flutter.dart';

@reflector
@UsePageRoute('/')
class FigmaConfigPage extends StatefulWidget {
  const FigmaConfigPage({Key? key}) : super(key: key);

  @override
  State<FigmaConfigPage> createState() => _FigmaConfigPageState();
}

class _FigmaConfigPageState extends State<FigmaConfigPage> {
  final _formKey = GlobalKey<FormState>();

  final _apiKeyController = TextEditingController();
  final _fileKeyController = TextEditingController();
  final _azureTokenController = TextEditingController();

  ProjectType _projectType = ProjectType.flutter;

  @override
  void initState() {
    super.initState();
    var bloc = context.read<ProjectBloc>();
    var state = bloc.state;
    _apiKeyController.text = state.projectConfig!.figmaApiKey;
    _fileKeyController.text = state.projectConfig!.fileKey;
    _azureTokenController.text = state.projectConfig!.azureDevopsToken ?? '';
    _projectType =
        ProjectTypeExtension.fromKey(state.projectConfig!.projectType);
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _fileKeyController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  _onConfigProject() {
    if (_formKey.currentState!.validate()) {
      // _formKey.currentState!.save();
      context.read<ProjectBloc>().add(
            UserSetupEvent(
              apiKey: _apiKeyController.text,
              projectType: _projectType,
              fileKey: _fileKeyController.text,
              azureDevopsToken: _azureTokenController.text,
            ),
          );
    }
  }

  String? _validateApiKey(value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.enter_figma_api_key;
    }
    return null;
  }

  void _openProject() async {
    //
    String? directory = await FilePicker.platform.getDirectoryPath(
      dialogTitle: "Select a Flutter or React project",
    );
    if (directory == null) {
      _showDirectoryError();
      return;
    }
    _openProjectDirectory(directory);
  }

  _openProjectDirectory(String path) {
    context.read<EditorBloc>().add(
          UserSelectedProjectEvent(
            projectPath: path,
            projectType: ProjectType.flutter,
          ),
        );
    GoRouter.of(context).push(getRoutingKey(EditorFormPage));
  }

  _showDirectoryError() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.project_not_selected),
          content:
              Text(AppLocalizations.of(context)!.project_not_selected_desc),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.action_ok),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (BuildContext context, ProjectState state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(APP_NAME),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _azureTokenController,
                    decoration: const InputDecoration(
                      labelText: 'Devops Token',
                    ),
                  ),
                  TextFormField(
                    controller: _apiKeyController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.figma_api_key,
                    ),
                    validator: _validateApiKey,
                  ),
                  const SizedBox(height: 16.0),
                  const Text('Project Type'),
                  Row(
                    children: <Widget>[
                      Radio<String>(
                        value: 'flutter',
                        groupValue:
                        ProjectTypeExtension.projectKey(_projectType),
                        onChanged: (value) {
                          setState(() {
                            _projectType = ProjectTypeExtension.fromKey(value!);
                          });
                        },
                      ),
                      Text(AppLocalizations.of(context)!.project_flutter),
                      const SizedBox(width: 16.0),
                      Radio<String>(
                        value: 'react',
                        groupValue:
                            ProjectTypeExtension.projectKey(_projectType),
                        onChanged: (value) {
                          setState(() {
                            _projectType = ProjectTypeExtension.fromKey(value!);
                          });
                        },
                      ),
                      Text(AppLocalizations.of(context)!.project_react),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: _onConfigProject,
                      child: Text(AppLocalizations.of(context)!.action_save),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HomeIcon(
                        label: 'Sync Figma',
                        icon: Icons.cloud_sync,
                        onPressed: () {
                          GoRouter.of(context).push(
                            getRoutingKey(SyncFigmaPage),
                          );
                        },
                      ),
                      HomeIcon(
                        label: AppLocalizations.of(context)!.action_open,
                        icon: Icons.folder_open,
                        onPressed: _openProject,
                      ),
                      HomeIcon(
                        label: AppLocalizations.of(context)!.action_open_online,
                        icon: Icons.cloud,
                        onPressed: () {
                          GoRouter.of(context).push(
                            getRoutingKey(AzureProjectPage),
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
