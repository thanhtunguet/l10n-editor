import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n_manipulator/blocs/project/project_bloc.dart';
import 'package:l10n_manipulator/pages/form_page.dart';
import 'package:truesight_flutter/truesight_flutter.dart';

@reflector
@UsePageRoute('/')
class ManipulatorHomePage extends StatefulWidget {
  const ManipulatorHomePage({super.key, required this.title});

  final String title;

  @override
  State<ManipulatorHomePage> createState() => _ManipulatorHomePageState();
}

class _ManipulatorHomePageState extends State<ManipulatorHomePage> {
  _openDirectory(String path) {
    context.read<ProjectBloc>().add(UserSelectedProjectEvent(path));
    GoRouter.of(context).go(getRoutingKey(FormPage));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Open a project to manipulate the translation files',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? selectedDirectory =
              await FilePicker.platform.getDirectoryPath();
          if (selectedDirectory == null) {
            // User canceled the picker
            return;
          }
          _openDirectory(selectedDirectory);
        },
        tooltip: 'Open',
        child: const Icon(Icons.folder_open),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
