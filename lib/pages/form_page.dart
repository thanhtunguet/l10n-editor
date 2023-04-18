import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n_manipulator/blocs/project/project_bloc.dart';
import 'package:l10n_manipulator/config/consts.dart';
import 'package:l10n_manipulator/manipulator_app.dart';
import 'package:l10n_manipulator/pages/manipulator_home_page.dart';
import 'package:truesight_flutter/truesight_flutter.dart';

@reflector
@UsePageRoute('/form')
class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<StatefulWidget> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _newKeyController = TextEditingController(
    text: '',
  );

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
                onPressed: () {
                  var newKey = _newKeyController.text;
                  _newKeyController.text = '';
                  context.read<ProjectBloc>().add(UserAddedNewKeyEvent(newKey));
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, ProjectState state) {
        if (state.hasData) {
          var localizedData = state.data.localizedData;
          var localeEntries = localizedData.entries.toList();
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  context.read<ProjectBloc>().add(UserResetEvent());
                  GoRouter.of(context).go(getRoutingKey(ManipulatorHomePage));
                },
              ),
              title: const Text(APP_NAME),
            ),
            body: ListView.builder(
              itemCount: localeEntries.length,
              itemBuilder: (context, recordIndex) {
                var recordKey = localeEntries[recordIndex].key;
                var recordValues =
                    localeEntries[recordIndex].value.entries.toList();

                const labelWidth = 200.0;
                const height = 50.0;
                const trashIconWidth = 50.0;

                var width = MediaQuery.of(context).size.width;
                var numOfLocales = state.data.supportedLocales.length;
                var inputRowWidth =
                    width - labelWidth - numOfLocales * 32 - trashIconWidth;
                var sizedFieldWidth = inputRowWidth / numOfLocales;

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
                        itemCount: recordValues.length,
                        itemBuilder: (context, rIndex) => Padding(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            width: sizedFieldWidth,
                            height: height,
                            child: TextFormField(
                              enabled: recordKey != LOCALE_KEY,
                              initialValue: recordValues[rIndex].value,
                              decoration: const InputDecoration(
                                hintText: "Enter text",
                              ),
                              onChanged: (value) {
                                setState(
                                  () {
                                    state.localizationData!
                                            .localizedData[recordKey]![
                                        recordValues[rIndex].key] = value;
                                  },
                                );
                              },
                              onEditingComplete: () {
                                context
                                    .read<ProjectBloc>()
                                    .add(UserTriggerSaveEvent());
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: trashIconWidth,
                      height: height,
                      child: Center(
                        child: CupertinoButton(
                          onPressed: () {
                            if (recordKey != LOCALE_KEY) {
                              context.read<ProjectBloc>().add(
                                    UserDeletedKeyEvent(recordKey),
                                  );
                              return;
                            }
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(AppLocalizations.of(context)!
                                      .figma_api_key),
                                  content: Text(AppLocalizations.of(context)!
                                      .keyword_not_deleted_desc),
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
                          },
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
}
