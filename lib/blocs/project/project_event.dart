part of 'project_bloc.dart';

@immutable
abstract class ProjectEvent {}

class UserSelectedProjectEvent extends ProjectEvent {
  final String projectPath;

  UserSelectedProjectEvent(this.projectPath) : super();
}

class UserAddedNewKeyEvent extends ProjectEvent {
  final String key;

  UserAddedNewKeyEvent(this.key) : super();
}

class UserDeletedKeyEvent extends ProjectEvent {
  final String key;

  UserDeletedKeyEvent(this.key) : super();
}

class UserTriggerSaveEvent extends ProjectEvent {}
