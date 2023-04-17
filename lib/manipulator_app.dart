import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n_manipulator/blocs/project/project_bloc.dart';
import 'package:l10n_manipulator/pages/form_page.dart';
import 'package:l10n_manipulator/pages/manipulator_home_page.dart';
import 'package:truesight_flutter/truesight_flutter.dart';

class ManipulatorApp extends StatelessWidget {
  ManipulatorApp({super.key});

  final routerConfig = GoRouter(
    routes: [
      GoRoute(
        path: getRoutingKey(FormPage),
        builder: (context, state) => const FormPage(),
      ),
      GoRoute(
        path: getRoutingKey(ManipulatorHomePage),
        builder: (context, state) => const ManipulatorHomePage(
          title: 'Localization Editor',
        ),
      ),
    ],
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProjectBloc()),
      ],
      child: MaterialApp.router(
        title: 'Localization Editor',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routerConfig: routerConfig,
      ),
    );
  }
}
