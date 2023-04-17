import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:l10n_manipulator/config/project_type.dart';
import 'package:l10n_manipulator/models/app_locale.dart';
import 'package:l10n_manipulator/models/localization_data.dart';

part 'project_event.dart';

part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  ProjectBloc() : super(ProjectState('')) {
    on<UserSelectedProjectEvent>(_onUserSelectedProject);
    on<UserAddedNewKeyEvent>(_onUserAddedNewKey);
    on<UserDeletedKeyEvent>(_onUserDeletedKey);
    on<UserTriggerSaveEvent>(_onUserTriggerSave);
  }

  _onUserTriggerSave(
    UserTriggerSaveEvent event,
    Emitter<ProjectState> emit,
  ) async {
    var supportedLocales = state.localizationData!.supportedLocales;
    var localizationData = state.localizationData!.localizedData;
    for (var locale in supportedLocales) {
      var result = {};
      var localeFile = state.localeFile(locale);
      localizationData.forEach((key, value) {
        result[key] = value[locale.locale];
      });
      var text = jsonEncode(result);
      localeFile.writeAsStringSync(text, mode: FileMode.write);

      Process.run(
        '/opt/flutter/bin/flutter',
        ['gen-l10n'],
        workingDirectory: state.path,
        runInShell: true,
      );
    }
  }

  Future<void> runBashCommandInDirectory(
      String command, String directory) async {
    final processResult = await Process.run(
      command,
      [],
      workingDirectory: directory,
      runInShell: true,
    );
    if (kDebugMode) {
      print(processResult.stdout);
      print(processResult.stderr);
    }
  }

  _onUserAddedNewKey(
    UserAddedNewKeyEvent event,
    Emitter<ProjectState> emit,
  ) {
    var key = event.key;
    emit(state.addKey(key));
    add(UserTriggerSaveEvent());
  }

  _onUserDeletedKey(
      UserDeletedKeyEvent event,
      Emitter<ProjectState> emit,
      ) {
    var key = event.key;
    emit(state.deleteKey(key));
    add(UserTriggerSaveEvent());
  }


  _onUserSelectedProject(
    UserSelectedProjectEvent event,
    Emitter<ProjectState> emit,
  ) {
    var projectState = state.withPath(event.projectPath);
    var localizationData = loadProjectData(projectState);
    var newState = projectState.withData(localizationData);
    emit(newState);
  }

  static LocalizationData loadProjectData(ProjectState projectState) {
    var supportedLocales = <AppLocale>[];
    Map<String, Map<String, dynamic>> localizationData = {};

    var directory = Directory(projectState.l10nPath);
    if (directory.existsSync()) {
      directory.listSync().forEach((element) {
        if (element is File) {
          var localeCode = projectState.locale(element.path);
          if (localeCode != '') {
            var appLocale = AppLocale(localeCode);
            supportedLocales.add(appLocale);
            if (kDebugMode) {
              print("Locale: $localeCode");
            }
            var contents = element.readAsStringSync();
            Map<String, dynamic> l10nContents = jsonDecode(contents);
            l10nContents.forEach((key, value) {
              if (!localizationData.containsKey(key)) {
                localizationData[key] = {};
              }
              localizationData[key]![localeCode] = value;
            });
          }
          return;
        }
        // is directory
      });
    }
    return LocalizationData(supportedLocales, localizationData);
  }
}
