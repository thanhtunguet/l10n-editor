enum ProjectType {
  flutter,
  react,
}

extension ProjectTypeExtension on ProjectType {
  static String projectKey(ProjectType type) {
    if (type == ProjectType.flutter) {
      return "flutter";
    }
    return "react";
  }

  static ProjectType fromKey(String key) {
    if (key == "flutter") {
      return ProjectType.flutter;
    }
    return ProjectType.react;
  }
}
