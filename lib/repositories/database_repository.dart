import 'package:l10n_manipulator/database/database.dart';
import 'package:l10n_manipulator/objectbox.g.dart';
import 'package:truesight_flutter/truesight_flutter.dart';

class DatabaseRepository extends ObjectBoxRepository {
  DatabaseRepository.create(super.store) : super.create();

  Box<ProjectConfig> get figmaBox => box<ProjectConfig>();

  ProjectConfig? get() {
    var figma = figmaBox.get(ProjectConfig.defaultId);
    if (figma == null) {
      figma = ProjectConfig();
      figma.id = ProjectConfig.defaultId;
      figmaBox.put(figma);
    }
    return figma;
  }

  void save(ProjectConfig figma) {
    figmaBox.put(figma);
  }

  void remove(ProjectConfig figma) {
    figmaBox.remove(ProjectConfig.defaultId);
  }
}
