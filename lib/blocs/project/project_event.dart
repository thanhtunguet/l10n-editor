part of 'project_bloc.dart';

@immutable
class ProjectEvent {}

class UserSetupEvent extends ProjectEvent {
  final String apiKey;

  final String fileKey;

  final String? azureDevopsToken;

  final ProjectType projectType;

  UserSetupEvent({
    required this.apiKey,
    required this.fileKey,
    required this.projectType,
    this.azureDevopsToken,
  }) : super();
}

class FirstLoadEvent extends ProjectEvent {}
