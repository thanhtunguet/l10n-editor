import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l10n_editor/blocs/project/project_bloc.dart';
import 'package:l10n_editor/config/consts.dart';
import 'package:l10n_editor/l10n_editor_app.dart';
import 'package:l10n_editor/main.dart';
import 'package:l10n_editor/repositories/figma_repository.dart';
import 'package:truesight_flutter/truesight_flutter.dart';

@reflector
@UsePageRoute('/sync-figma')
class SyncFigmaPage extends StatefulWidget {
  const SyncFigmaPage({Key? key}) : super(key: key);

  @override
  State<SyncFigmaPage> createState() => _SyncFigmaPageState();
}

class _SyncFigmaPageState extends State<SyncFigmaPage> {
  final _formKey = GlobalKey<FormState>();

  final _figmaLinkController = TextEditingController();

  _syncFigma() async {
    if (_formKey.currentState!.validate()) {
      var state = getIt.get<ProjectBloc>().state;
      var figmaRepository = FigmaRepository();
      var response = await figmaRepository.file(
          state.projectConfig!.figmaApiKey, state.projectConfig!.fileKey);
      var textNodes = figmaRepository.findTextNodes(response);
      var directory = await FilePicker.platform.getDirectoryPath();
      if (directory == null) {
        return;
      }
      var supportedLocales = const [
        Locale('vi', 'vn'),
        Locale('en', 'us'),
      ];
      var jsonObject = {};
      for (var node in textNodes) {
        jsonObject[node.name!.replaceAll('label_', '')] = node.characters;
      }
      for (var locale in supportedLocales) {
        jsonObject[LOCALE_KEY] = locale.languageCode;
        var arbFile = File("$directory/lib/l10n/intl_${locale.languageCode}.arb");
        var encoder = const JsonEncoder.withIndent('  ');
        arbFile.writeAsStringSync(encoder.convert(jsonObject));
      }
      _showSuccess();
    }
  }

  _showSuccess() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Export success'),
          content: const Text('All locales exported'),
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
            title: const Text('Sync Figma Page'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _figmaLinkController,
                    decoration: const InputDecoration(
                      labelText: 'Figma Link:',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter figma link to continue';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: _syncFigma,
                      child: Text(AppLocalizations.of(context)!.action_save),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
