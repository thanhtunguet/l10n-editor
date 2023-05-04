import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l10n_editor/blocs/editor/editor_bloc.dart';
import 'package:l10n_editor/config/consts.dart';
import 'package:l10n_editor/l10n_editor_app.dart';
import 'package:l10n_editor/repositories/editor.dart';
import 'package:truesight_flutter/truesight_flutter.dart';

@reflector
@UsePageRoute('/form')
class EditorFormPage extends StatefulWidget {
  const EditorFormPage({super.key});

  @override
  State<StatefulWidget> createState() => _EditorFormPageState();
}

class _EditorFormPageState extends State<EditorFormPage> {
  final _newKeyController = TextEditingController(
    text: '',
  );

  @override
  initState() {
    super.initState();
  }

  _onGoBack() {
    context.read<EditorBloc>().add(UserResetEvent());
  }

  _save() {
    context.read<EditorBloc>().add(UserTriggerSaveEvent());
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditorBloc, EditorState>(
      builder: (BuildContext context, EditorState state) {
        if (state.hasData) {
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
        return Center(
          child: Text(AppLocalizations.of(context)!.no_data_here),
        );
      },
    );
  }

  @override
  void dispose() {
    _newKeyController.dispose();
    super.dispose();
  }
}
