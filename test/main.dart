// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart' hide test;
import 'package:l10n_editor/repositories/database_repository.dart';
import 'package:mockito/mockito.dart';

import 'main.config.dart';
import 'main.reflectable.dart';

@singleton
class TestDatabase extends Mock implements DatabaseRepository {}

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  getIt.registerSingleton<DatabaseRepository>(TestDatabase());
  getIt.init();
  await getIt.allReady();
}

void main() async {
  await dotenv.load();
  initializeReflectable();
  await configureDependencies();
}
