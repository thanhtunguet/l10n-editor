
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:l10n_editor/config/consts.dart';
import 'package:l10n_editor/l10n_editor_app.dart';

class Editor extends StatefulWidget {
  List<Locale> supportedLocales;

  Map<String, Map<String, dynamic>> localizedData;

  Function onNewKeyModal;

  Function onBack;

  Function onDeleteKey;

  void Function()? onSave;

  Editor({
    super.key,
    required this.supportedLocales,
    required this.localizedData,
    required this.onNewKeyModal,
    required this.onSave,
    required this.onDeleteKey,
    required this.onBack,
  });

  @override
  State<StatefulWidget> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  @override
  Widget build(BuildContext context) {
    var supportedLocales = widget.supportedLocales;
    var localizedData = widget.localizedData;
    var localizedDataEntries = localizedData.entries.toList();
    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(APP_NAME),
        ),
        body: ListView.builder(
          itemCount: localizedData.length,
          itemBuilder: (context, recordIndex) {
            var recordKey = localizedDataEntries[recordIndex].key;
            const labelWidth = 300.0;
            const height = 50.0;
            const trashIconWidth = 50.0;

            final numOfLocales = supportedLocales.length;
            final inputRowWidth =
                width - labelWidth - numOfLocales * 32 - trashIconWidth;
            final sizedFieldWidth = inputRowWidth / numOfLocales;

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: labelWidth,
                  height: height,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                        ),
                        child: Text(recordKey),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: inputRowWidth,
                  height: height,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: supportedLocales.length,
                    itemBuilder: (BuildContext context, int languageIndex) {
                      final locale = supportedLocales[languageIndex];
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: sizedFieldWidth,
                          height: height,
                          child: TextFormField(
                            enabled: recordKey != LOCALE_KEY,
                            initialValue: localizedData[recordKey]
                                ?[locale.languageCode],
                            decoration: const InputDecoration(
                              hintText: "Enter text",
                            ),
                            onChanged: (value) {
                              setState(
                                () {
                                  if (!localizedData.containsKey(recordKey)) {
                                    localizedData[recordKey] = {};
                                  }
                                  localizedData[recordKey]![
                                      locale.languageCode] = value;
                                },
                              );
                            },
                            onEditingComplete: widget.onSave,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: trashIconWidth,
                  height: height,
                  child: Center(
                    child: CupertinoButton(
                      onPressed: widget.onDeleteKey(recordKey),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            widget.onNewKeyModal();
          },
          tooltip: AppLocalizations.of(context)!.add_key,
          child: const Icon(Icons.add),
        ),
      ),
      onWillPop: () async {
        widget.onBack();
        return true;
      },
    );
  }
}
