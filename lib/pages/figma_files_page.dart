import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l10n_manipulator/blocs/figma/project_bloc.dart';
import 'package:l10n_manipulator/main.dart';
import 'package:l10n_manipulator/models/figma_file.dart';
import 'package:l10n_manipulator/repositories/figma_repository.dart';
import 'package:truesight_flutter/truesight_flutter.dart';

@reflector
@UsePageRoute('/files')
class FigmaFilesPage extends StatefulWidget {
  const FigmaFilesPage({super.key});

  @override
  State<FigmaFilesPage> createState() => _FigmaFilesPageState();
}

class _FigmaFilesPageState extends State<FigmaFilesPage> {
  List<FigmaFile> figmaFiles = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectBloc, ProjectState>(
      listener: (context, state) {
        if (state.hasApiKey) {
          var figmaRepository = getIt.get<FigmaRepository>();
          figmaRepository.apiKey = state.figma!.apiKey;
          figmaRepository.files().then((files) {
            setState(() {
              figmaFiles = files;
            });
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Figma Files'),
          ),
          body: figmaFiles.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: figmaFiles.length,
                  itemBuilder: (BuildContext context, int index) {
                    final file = figmaFiles[index];
                    return ListTile(
                      title: Text(file.name),
                      subtitle: Text(file.key),
                      onTap: () {
                        // Do something when the user taps a Figma file
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
