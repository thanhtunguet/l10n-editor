import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:l10n_manipulator/blocs/project/editor_bloc.dart';
import 'package:l10n_manipulator/config/consts.dart';
import 'package:l10n_manipulator/main.dart';
import 'package:l10n_manipulator/manipulator_app.dart';
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

  final _pagingController =
      PagingController<int, MapEntry<String, Map<String, dynamic>>>(
    firstPageKey: 0,
  );

  @override
  initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  _fetchPage(int pageIndex) {
    const pageSize = 50;
    final state = getIt.get<EditorBloc>().state;
    final localizedData = state.localizationData!.localizedData;

    try {
      final isLastPage = localizedData.length - pageIndex < pageSize;
      if (isLastPage) {
        final newItems = localizedData.entries
            .toList()
            .sublist(pageIndex, localizedData.length);
        _pagingController.appendLastPage(newItems);
      } else {
        final newItems = localizedData.entries
            .toList()
            .sublist(pageIndex, pageIndex + pageSize);
        final int nextPageKey = pageIndex + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  _addNewKey() {
    var newKey = _newKeyController.text;
    _newKeyController.text = '';
    context.read<EditorBloc>().add(UserAddedNewKeyEvent(newKey));
    Navigator.pop(context);
  }

  _goHome() {
    context.read<EditorBloc>().add(UserResetEvent());
  }

  _save() {
    context.read<EditorBloc>().add(UserTriggerSaveEvent());
  }

  void _showModal() {
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

          final width = MediaQuery.of(context).size.width;

          return Scaffold(
            appBar: AppBar(
              title: const Text(APP_NAME),
            ),
            body: PagedListView<int, MapEntry<String, Map<String, dynamic>>>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<
                  MapEntry<String, Map<String, dynamic>>>(
                itemBuilder: (
                  BuildContext context,
                  MapEntry<String, Map<String, dynamic>> item,
                  int recordIndex,
                ) {
                  var recordKey = item.key;
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
                          itemBuilder:
                              (BuildContext context, int languageIndex) {
                            final locale = supportedLocales[languageIndex];
                            return Padding(
                              padding: const EdgeInsets.all(16),
                              child: SizedBox(
                                width: sizedFieldWidth,
                                height: height,
                                child: TextFormField(
                                  enabled: recordKey != LOCALE_KEY,
                                  initialValue: localizedData[recordKey]
                                      ?[locale.locale],
                                  decoration: const InputDecoration(
                                    hintText: "Enter text",
                                  ),
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        if (!localizedData
                                            .containsKey(recordKey)) {
                                          localizedData[recordKey] = {};
                                        }
                                        localizedData[recordKey]![
                                            locale.locale] = value;
                                      },
                                    );
                                  },
                                  onEditingComplete: _save,
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
                            onPressed: _deleteKey(recordKey),
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
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _showModal();
              },
              tooltip: AppLocalizations.of(context)!.add_key,
              child: const Icon(Icons.add),
            ),
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
    _pagingController.dispose();
    _newKeyController.dispose();
    super.dispose();
  }
}
