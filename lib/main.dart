import 'package:flutter/material.dart';
import 'package:l10n_manipulator/manipulator_app.dart';

import 'main.reflectable.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeReflectable();
  runApp(ManipulatorApp());
}
