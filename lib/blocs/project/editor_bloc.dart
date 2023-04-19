import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:l10n_manipulator/config/project_type.dart';
import 'package:l10n_manipulator/models/app_locale.dart';
import 'package:l10n_manipulator/models/localization_data.dart';

part 'editor_event.dart';

part 'editor_state.dart';

@singleton
class EditorBloc extends Bloc<EditorEvent, EditorState> {
  EditorBloc()
      : super(
          EditorState(
            path: '',
            projectType: ProjectType.flutter,
            localizationData: null,
          ),
        ) {
    on<UserSelectedProjectEvent>(_onUserSelectedProject);
    on<UserAddedNewKeyEvent>(_onUserAddedNewKey);
    on<UserDeletedKeyEvent>(_onUserDeletedKey);
    on<UserTriggerSaveEvent>(_onUserTriggerSave);
    on<UserResetEvent>(_onUserReset);
  }

  _onUserReset(
    UserResetEvent event,
    Emitter<EditorState> emit,
  ) {
    emit(
      EditorState(
        path: '',
        projectType: ProjectType.flutter,
        localizationData: null,
      ),
    );
  }

  _onUserTriggerSave(
    UserTriggerSaveEvent event,
    Emitter<EditorState> emit,
  ) async {
    var supportedLocales = state.localizationData!.supportedLocales;
    var localizationData = state.localizationData!.localizedData;

    for (var locale in supportedLocales) {
      var result = {};
      var localeFile = state.localeFile(locale);
      localizationData.forEach((key, value) {
        result[key] = value[locale.locale];
      });
      var encoder = const JsonEncoder.withIndent('  ');
      var text = encoder.convert(result);
      localeFile.writeAsStringSync(text, mode: FileMode.write);
      await _runFlutterGenL10n();
    }
  }

  Future<void> _runFlutterGenL10n() async {
    await Process.run(
      '/opt/flutter/bin/flutter',
      ['gen-l10n'],
      workingDirectory: state.path,
      runInShell: true,
    );
  }

  _onUserAddedNewKey(
    UserAddedNewKeyEvent event,
    Emitter<EditorState> emit,
  ) {
    emit(state.addKey(event.key));
    add(UserTriggerSaveEvent());
  }

  _onUserDeletedKey(
    UserDeletedKeyEvent event,
    Emitter<EditorState> emit,
  ) {
    emit(state.deleteKey(event.key));
    add(UserTriggerSaveEvent());
  }

  _onUserSelectedProject(
    UserSelectedProjectEvent event,
    Emitter<EditorState> emit,
  ) {
    var projectState = state.withPath(
      event.projectPath,
      event.projectType,
    );
    var localizationData = _loadProjectData(projectState);
    var newState = projectState.withData(localizationData);
    emit(newState);
  }

  static LocalizationData _loadProjectData(EditorState projectState) {
    var supportedLocales = <AppLocale>[];
    Map<String, Map<String, dynamic>> localizationData = {};

    var directory = Directory(projectState.l10nPath);
    if (directory.existsSync()) {
      directory.listSync().forEach(
        (element) {
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
        },
      );
    }
    return LocalizationData(supportedLocales, localizationData);
  }
}
