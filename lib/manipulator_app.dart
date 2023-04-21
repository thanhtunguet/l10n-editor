import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n_manipulator/blocs/editor/editor_bloc.dart';
import 'package:l10n_manipulator/blocs/project/project_bloc.dart';
import 'package:l10n_manipulator/config/consts.dart';
import 'package:l10n_manipulator/main.dart';
import 'package:l10n_manipulator/pages/azure_project_page.dart';
import 'package:l10n_manipulator/pages/editor_form_page.dart';
import 'package:l10n_manipulator/pages/project_config_page.dart';
import 'package:truesight_flutter/truesight_flutter.dart';

import 'manipulator_app.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ManipulatorApp extends StatelessWidget {
  ManipulatorApp({super.key});

  final routerConfig = GoRouter(
    initialLocation: getRoutingKey(FigmaConfigPage),
    routes: [
      GoRoute(
        path: getRoutingKey(AzureProjectPage),
        builder: (context, state) => const AzureProjectPage(),
      ),
      GoRoute(
        path: getRoutingKey(EditorFormPage),
        builder: (context, state) => const EditorFormPage(),
      ),
      GoRoute(
        path: getRoutingKey(FigmaConfigPage),
        builder: (context, state) => const FigmaConfigPage(),
      ),
    ],
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EditorBloc>(create: (context) => getIt.get<EditorBloc>()),
        BlocProvider<ProjectBloc>(
            create: (context) => getIt.get<ProjectBloc>()),
      ],
      child: MaterialApp.router(
        title: APP_NAME,
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routerConfig: routerConfig,
      ),
    );
  }
}
