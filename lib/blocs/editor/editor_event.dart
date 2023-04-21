part of 'editor_bloc.dart';

@immutable
abstract class EditorEvent {}

class UserSelectedProjectEvent extends EditorEvent {
  final String projectPath;

  final ProjectType projectType;

  UserSelectedProjectEvent({
    required this.projectPath,
    required this.projectType,
  }) : super();
}

class UserSelectOnlineProjectEvent extends EditorEvent {
  final Map<String, String> fileContents;

  UserSelectOnlineProjectEvent(this.fileContents) : super();
}

class UserAddedNewKeyEvent extends EditorEvent {
  final String key;

  UserAddedNewKeyEvent(this.key) : super();
}

class UserDeletedKeyEvent extends EditorEvent {
  final String key;

  UserDeletedKeyEvent(this.key) : super();
}

class UserTriggerSaveEvent extends EditorEvent {}

class UserTriggerOnlineSaveEvent extends UserTriggerSaveEvent {
  final String repositoryId;

  UserTriggerOnlineSaveEvent(this.repositoryId) : super();
}

class UserResetEvent extends EditorEvent {}
