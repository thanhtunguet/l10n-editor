import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:l10n_editor/blocs/project/project_bloc.dart';
import 'package:l10n_editor/config/project_location.dart';
import 'package:l10n_editor/config/project_type.dart';
import 'package:l10n_editor/main.dart';
import 'package:l10n_editor/models/localization_data.dart';
import 'package:l10n_editor/repositories/azure_devops_repository.dart';

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
    on<UserSelectOnlineProjectEvent>(_onUserSelectOnlineProject);
  }

  _onUserSelectOnlineProject(
    UserSelectOnlineProjectEvent event,
    Emitter<EditorState> emit,
  ) {
    var localizationData = _loadOnlineProject(event.fileContents);
    emit(state.toAzureDevops(localizationData));
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
    if (state.projectLocation == ProjectLocation.azureDevops ||
        event is UserTriggerOnlineSaveEvent) {
      var projectState = getIt.get<ProjectBloc>().state;
      var devopsRepository = AzureDevopsRepository();
      var repoId = (event as UserTriggerOnlineSaveEvent).repositoryId;
      var token = projectState.projectConfig!.azureDevopsToken!;
      var latestCommitId = await devopsRepository.getLatestCommitId(
        token,
        repoId,
      );
      var supportedLocales = state.localizationData!.supportedLocales;
      var encoder = const JsonEncoder.withIndent('  ');
      Map<String, String> fileContents = {};
      for (var supportedLocale in supportedLocales) {
        var localeString = {};
        for (var entry in state.localizationData!.localizedData.entries) {
          localeString[entry.key] = entry.value[supportedLocale.languageCode];
        }
        fileContents["/lib/l10n/intl_${supportedLocale.languageCode}.arb"] =
            encoder.convert(localeString);
      }
      try {
        var result = await devopsRepository.updateFiles(
            token, repoId, latestCommitId, fileContents);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
      return;
    }
    if (state.projectLocation == ProjectLocation.local) {
      var supportedLocales = state.localizationData!.supportedLocales;
      var localizationData = state.localizationData!.localizedData;

      for (var locale in supportedLocales) {
        var result = {};
        var localeFile = state.localeFile(locale);
        localizationData.forEach((key, value) {
          result[key] = value[locale.languageCode];
        });
        var encoder = const JsonEncoder.withIndent('  ');
        var text = encoder.convert(result);
        localeFile.writeAsStringSync(text, mode: FileMode.write);
        await _runFlutterGenL10n();
      }
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
    var supportedLocales = <Locale>[];
    Map<String, Map<String, dynamic>> localizationData = {};

    var directory = Directory(projectState.l10nPath);
    if (directory.existsSync()) {
      directory.listSync().forEach(
        (element) {
          if (element is File) {
            var localeCode = projectState.locale(element.path);
            if (localeCode != '') {
              var appLocale = Locale(localeCode);
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

  static LocalizationData _loadOnlineProject(Map<String, String> fileContents) {
    var supportedLocales = <Locale>[];
    Map<String, Map<String, dynamic>> localizationData = {};
    var projectState =
        const EditorState(path: '', projectType: ProjectType.flutter);
    for (var entry in fileContents.entries) {
      var locale = Locale(projectState.locale(entry.key));
      supportedLocales.add(locale);
      var localeContents = jsonDecode(entry.value);
      localeContents.forEach((key, value) {
        if (!localizationData.containsKey(key)) {
          localizationData[key] = {};
        }
        localizationData[key]![locale.languageCode] = value;
      });
    }
    return LocalizationData(supportedLocales, localizationData);
  }
}
