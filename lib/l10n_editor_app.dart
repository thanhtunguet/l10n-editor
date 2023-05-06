import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n_editor/blocs/editor/editor_bloc.dart';
import 'package:l10n_editor/blocs/project/project_bloc.dart';
import 'package:l10n_editor/config/app_locale.dart';
import 'package:l10n_editor/config/consts.dart';
import 'package:l10n_editor/main.dart';
import 'package:l10n_editor/pages/azure_project_page.dart';
import 'package:l10n_editor/pages/editor_form_page.dart';
import 'package:l10n_editor/pages/project_config_page.dart';
import 'package:l10n_editor/pages/sync_figma_page.dart';
import 'package:truesight_flutter/truesight_flutter.dart';

import 'l10n_editor_app.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

class L10nEditorApp extends StatelessWidget {
  L10nEditorApp({super.key});

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
      GoRoute(
        path: getRoutingKey(SyncFigmaPage),
        builder: (context, state) => const SyncFigmaPage(),
      ),
    ],
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EditorBloc>(
          create: (context) => getIt.get<EditorBloc>(),
        ),
        BlocProvider<ProjectBloc>(
          create: (context) => getIt.get<ProjectBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: APP_NAME,
        locale: AppLocale.vietnamese,
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
