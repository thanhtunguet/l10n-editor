import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n_manipulator/blocs/figma/figma_bloc.dart';
import 'package:l10n_manipulator/blocs/project/project_bloc.dart';
import 'package:l10n_manipulator/config/consts.dart';
import 'package:l10n_manipulator/pages/figma_config_page.dart';
import 'package:l10n_manipulator/pages/form_page.dart';
import 'package:l10n_manipulator/pages/manipulator_home_page.dart';
import 'package:truesight_flutter/truesight_flutter.dart';

import 'manipulator_app.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ManipulatorApp extends StatelessWidget {
  ManipulatorApp({super.key});

  final routerConfig = GoRouter(
    routes: [
      GoRoute(
        path: getRoutingKey(FormPage),
        builder: (context, state) => const FormPage(),
      ),
      GoRoute(
        path: getRoutingKey(FigmaConfigPage),
        builder: (context, state) => const FigmaConfigPage(),
      ),
      GoRoute(
        path: getRoutingKey(ManipulatorHomePage),
        builder: (context, state) => const ManipulatorHomePage(),
      ),
    ],
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProjectBloc>(create: (context) => ProjectBloc()),
        BlocProvider<FigmaBloc>(create: (context) => FigmaBloc()),
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
