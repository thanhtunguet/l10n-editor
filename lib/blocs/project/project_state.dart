part of 'project_bloc.dart';

class ProjectState extends Equatable {
  ProjectConfig? projectConfig;

  ProjectState({this.projectConfig});

  ProjectState.fromKeys({
    required apiKey,
    required String projectType,
    required fileKey,
    String? azureDevopsToken,
  }) {
    projectConfig = ProjectConfig();
    projectConfig!.id = ProjectConfig.defaultId;
    projectConfig!.figmaApiKey = apiKey;
    projectConfig!.projectType = projectType;
    projectConfig!.fileKey = fileKey;
    projectConfig!.azureDevopsToken = azureDevopsToken;
  }

  bool get hasApiKey {
    return projectConfig?.figmaApiKey != null &&
        projectConfig?.figmaApiKey != '';
  }

  @override
  List<Object?> get props => [
        projectConfig?.figmaApiKey,
        projectConfig?.fileKey,
        projectConfig?.projectType,
      ];
}
