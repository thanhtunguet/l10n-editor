import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:l10n_manipulator/config/consts.dart';
import 'package:l10n_manipulator/manipulator_app.dart';
import 'package:l10n_manipulator/repositories/database_repository.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'main.config.dart';
import 'main.reflectable.dart';
import 'objectbox.g.dart';

var getIt = GetIt.instance;

@InjectableInit()
configureDependencies() async {
  var store = await openStore(
    directory: Directory.current.path,
    macosApplicationGroup: 'X7M392FCT9.l10n',
  );
  getIt.registerSingleton<DatabaseRepository>(DatabaseRepository.create(store));
  getIt.init();
  await getIt.allReady();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  initializeReflectable();

  await configureDependencies();

  await SentryFlutter.init(
    (options) {
      options.dsn = SENTRY_DSN;
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(
      ManipulatorApp(),
    ),
  );
}
