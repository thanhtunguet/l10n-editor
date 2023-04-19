import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n_manipulator/blocs/figma/project_bloc.dart';
import 'package:l10n_manipulator/config/consts.dart';
import 'package:l10n_manipulator/config/project_type.dart';
import 'package:l10n_manipulator/manipulator_app.dart';
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

  ProjectType _projectType = ProjectType.flutter;

  @override
  void initState() {
    super.initState();
    var bloc = context.read<ProjectBloc>();
    var state = bloc.state;
    _apiKeyController.text = state.figma!.apiKey;
    _fileKeyController.text = state.figma!.fileKey;
    _projectType = ProjectTypeExtension.fromKey(state.figma!.projectType);
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _fileKeyController.dispose();
    super.dispose();
  }

  _onSubmit() {
    if (_formKey.currentState!.validate()) {
      // _formKey.currentState!.save();
      context.read<ProjectBloc>().add(UserSetupEvent(
            apiKey: _apiKeyController.text,
            projectType: _projectType,
            fileKey: _fileKeyController.text,
          ));
      GoRouter.of(context).pop();
    }
  }

  String? _validateFileKey(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Figma File Key';
    }
    return null;
  }

  String? _validateApiKey(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Figma API Key';
    }
    return null;
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
                    controller: _apiKeyController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.figma_api_key,
                    ),
                    validator: _validateApiKey,
                  ),
                  TextFormField(
                    controller: _fileKeyController,
                    decoration: const InputDecoration(
                      labelText: 'Figma File Key',
                    ),
                    validator: _validateFileKey,
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
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _onSubmit,
                    child: Text(AppLocalizations.of(context)!.action_save),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.folder_open),
            onPressed: () {},
          ),
        );
      },
    );
  }
}
