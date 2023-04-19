part of 'editor_bloc.dart';

class EditorState {
  final String path;

  final ProjectType projectType;

  final LocalizationData? localizationData;

  bool get hasData {
    return localizationData != null;
  }

  int get length {
    if (localizationData == null) {
      return 0;
    }
    if (localizationData!.localizedData.isEmpty) {
      return 0;
    }
    var firstKey = localizationData!.localizedData.keys.first;
    var first = localizationData!.localizedData[firstKey];
    return first!.length; // Except '@@locale'
  }

  String locale(String filename) {
    if (projectType == ProjectType.flutter) {
      RegExp regExp = RegExp(r'_([a-z]{2})\.arb$');
      return regExp.firstMatch(filename)?.group(1) ?? '';
    }
    RegExp regExp = RegExp(r'([a-z]{2})\.json$');
    return regExp.firstMatch(filename)?.group(1) ?? '';
  }

  File localeFile(AppLocale locale) {
    if (projectType == ProjectType.flutter) {
      return File("$path/lib/l10n/intl_${locale.locale}.arb");
    }
    return File("$path/src/i18n/${locale.locale}.json");
  }

  String get l10nPath {
    if (projectType == ProjectType.flutter) {
      return "$path/lib/l10n";
    }
    return "$path/src/i18n";
  }

  EditorState({
    required this.path,
    required this.projectType,
    this.localizationData,
  });

  EditorState addKey(String key) {
    if (localizationData != null) {
      if (!localizationData!.localizedData.containsKey(key)) {
        localizationData!.localizedData[key] = {};
        for (var locale in localizationData!.supportedLocales) {
          localizationData!.localizedData[key]![locale.locale] = '';
        }
      }
    }
    return EditorState(
      path: path,
      projectType: projectType,
      localizationData: localizationData,
    );
  }

  EditorState deleteKey(String key) {
    if (localizationData != null) {
      if (localizationData!.localizedData.containsKey(key)) {
        localizationData!.localizedData.removeWhere((k, _) => k == key);
      }
    }
    return EditorState(
      path: path,
      projectType: projectType,
      localizationData: localizationData,
    );
  }

  EditorState withPath(String path, ProjectType projectType) {
    return EditorState(
      path: path,
      projectType: projectType,
      localizationData: localizationData,
    );
  }

  EditorState withData(LocalizationData localizationData) {
    return EditorState(
      path: path,
      projectType: projectType,
      localizationData: localizationData,
    );
  }

  EditorState flutter() {
    return EditorState(
      path: path,
      projectType: ProjectType.flutter,
      localizationData: localizationData,
    );
  }

  EditorState react() {
    return EditorState(
      path: path,
      projectType: ProjectType.react,
      localizationData: localizationData,
    );
  }
}
