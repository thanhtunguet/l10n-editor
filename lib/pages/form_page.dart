import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l10n_manipulator/blocs/project/project_bloc.dart';
import 'package:truesight_flutter/truesight_flutter.dart';

@reflector
@UsePageRoute('/form')
class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<StatefulWidget> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _newKeyController =
      TextEditingController(text: '');

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
                    return "Key cannot be null";
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
              title: const Text('Localization Editor'),
            ),
            body: ListView.builder(
              itemCount: localeEntries.length,
              itemBuilder: (context, recordIndex) {
                var recordKey = localeEntries[recordIndex].key;
                var recordValues =
                    localeEntries[recordIndex].value.entries.toList();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(recordKey),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 1080,
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: recordValues.length,
                        itemBuilder: (context, rIndex) => Padding(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            width: 300,
                            height: 50,
                            child: TextFormField(
                              enabled: recordKey != '@@locale',
                              initialValue: recordValues[rIndex].value,
                              decoration: const InputDecoration(
                                hintText: "Enter text",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
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
                      width: 50,
                      height: 50,
                      child: CupertinoButton(
                        onPressed: () {
                          context.read<ProjectBloc>().add(
                                UserDeletedKeyEvent(recordKey),
                              );
                        },
                        child: const Icon(
                          Icons.delete,
                          color: Colors.red,
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
              tooltip: 'Add Localization String',
              child: const Icon(Icons.add),
            ),
          );
        }
        return const Center(
          child: Text('No data here'),
        );
      },
    );
  }
}
