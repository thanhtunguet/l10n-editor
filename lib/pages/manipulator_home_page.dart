import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n_manipulator/blocs/project/project_bloc.dart';
import 'package:l10n_manipulator/config/consts.dart';
import 'package:l10n_manipulator/manipulator_app.dart';
import 'package:l10n_manipulator/pages/figma_config_page.dart';
import 'package:l10n_manipulator/pages/form_page.dart';
import 'package:truesight_flutter/truesight_flutter.dart';

@reflector
@UsePageRoute('/')
class ManipulatorHomePage extends StatefulWidget {
  const ManipulatorHomePage({super.key});

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
        title: const Text(APP_NAME),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                AppLocalizations.of(context)!.home_guide_text,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              iconSize: 60,
              color: Theme.of(context).primaryColor,
              onPressed: () {
                GoRouter.of(context).push(getRoutingKey(FigmaConfigPage));
              },
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
        tooltip: AppLocalizations.of(context)!.action_open,
        child: const Icon(Icons.folder_open),
      ),
    );
  }
}
