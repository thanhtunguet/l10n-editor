part of 'project_bloc.dart';

@immutable
class ProjectEvent {}

class UserSetupEvent extends ProjectEvent {
  final String apiKey;

  final String fileKey;

  final ProjectType projectType;

  UserSetupEvent({
    required this.apiKey,
    required this.fileKey,
    required this.projectType,
  }) : super();
}

class FirstLoadEvent extends ProjectEvent {}
