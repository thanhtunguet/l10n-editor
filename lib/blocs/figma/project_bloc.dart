import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:l10n_manipulator/config/project_type.dart';
import 'package:l10n_manipulator/database/database.dart';
import 'package:l10n_manipulator/main.dart';
import 'package:l10n_manipulator/repositories/database_repository.dart';
import 'package:meta/meta.dart';

part 'project_event.dart';

part 'project_state.dart';

@singleton
class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  DatabaseRepository get databaseRepository {
    return getIt.get<DatabaseRepository>();
  }

  ProjectBloc() : super(ProjectState()) {
    on<FirstLoadEvent>(_onFirstLoad);
    on<UserSetupEvent>(_onUserSetup);
    //
    add(FirstLoadEvent());
  }

  _onUserSetup(
    UserSetupEvent event,
    Emitter<ProjectState> emit,
  ) {
    final apiKey = event.apiKey;
    final fileKey = event.fileKey;
    final projectType = event.projectType;

    var newState = ProjectState.fromKeys(
      apiKey: apiKey,
      fileKey: fileKey,
      projectType: ProjectTypeExtension.projectKey(projectType),
    );

    databaseRepository.save(newState.figma!);
    emit(newState);
  }

  _onFirstLoad(
    FirstLoadEvent event,
    Emitter<ProjectState> emit,
  ) {
    var figma = databaseRepository.get();
    if (kDebugMode) {
      print(figma.toString());
    }
    emit(ProjectState(figma: figma));
  }
}
