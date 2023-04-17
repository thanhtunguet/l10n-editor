part of 'project_bloc.dart';

class ProjectState {
  final String path;

  final ProjectType projectType;

  final LocalizationData? localizationData;

  LocalizationData get data {
    return localizationData!;
  }

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

  ProjectState forEach(void Function(String, String) eachFunction) {
    if (localizationData == null) {
      return this;
    }
    if (localizationData!.localizedData.isEmpty) {
      return this;
    }
    var firstKey = localizationData!.localizedData.keys.first;
    var first = localizationData!.localizedData[firstKey];
    first?.forEach((key, value) {
      eachFunction(key, value);
    });
    return this;
  }

  String locale(String filename) {
    RegExp regExp = RegExp(r'_([a-z]{2})\.arb$');
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

  ProjectState(
    this.path, {
    this.projectType = ProjectType.flutter,
    this.localizationData,
  });

  ProjectState addKey(String key) {
    if (localizationData != null) {
      if (!localizationData!.localizedData.containsKey(key)) {
        localizationData!.localizedData[key] = {};
        for (var locale in localizationData!.supportedLocales) {
          localizationData!.localizedData[key]![locale.locale] = '';
        }
      }
    }
    return ProjectState(
      path,
      projectType: projectType,
      localizationData: localizationData,
    );
  }

  ProjectState deleteKey(String key) {
    if (localizationData != null) {
      if (localizationData!.localizedData.containsKey(key)) {
        localizationData!.localizedData.removeWhere((k, _) => k == key);
      }
    }
    return ProjectState(
      path,
      projectType: projectType,
      localizationData: localizationData,
    );
  }

  ProjectState withPath(String path) {
    return ProjectState(path);
  }

  ProjectState withData(LocalizationData data) {
    return ProjectState(
      path,
      projectType: projectType,
      localizationData: data,
    );
  }

  ProjectState flutter() {
    return ProjectState(path, projectType: ProjectType.flutter);
  }

  ProjectState react() {
    return ProjectState(path, projectType: ProjectType.react);
  }
}
