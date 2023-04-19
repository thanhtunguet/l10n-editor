import 'package:l10n_manipulator/database/database.dart';
import 'package:l10n_manipulator/objectbox.g.dart';
import 'package:truesight_flutter/truesight_flutter.dart';

class DatabaseRepository extends ObjectBoxRepository {
  DatabaseRepository.create(super.store) : super.create();

  Box<Figma> get figmaBox => box<Figma>();

  Figma get() {
    var figma = figmaBox.get(Figma.DEFAULT_ID);
    if (figma == null) {
      figma = Figma();
      figma.id = Figma.DEFAULT_ID;
      figmaBox.put(figma);
    }
    return figma;
  }

  void save(Figma figma) {
    figmaBox.put(figma);
  }

  void remove(Figma figma) {
    figmaBox.remove(Figma.DEFAULT_ID);
  }
}
