import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
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
  initializeReflectable();

  await configureDependencies();

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://d6369034215f4b0f8937fe96b48fb459@o404808.ingest.sentry.io/4505032453914624';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(
      ManipulatorApp(),
    ),
  );
}
