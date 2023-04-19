part of 'project_bloc.dart';

class ProjectState extends Equatable {
  Figma? figma;

  ProjectState({this.figma});

  ProjectState.fromKeys({
    required apiKey,
    required String projectType,
    required fileKey,
  }) {
    figma = Figma();
    figma!.id = Figma.DEFAULT_ID;
    figma!.apiKey = apiKey;
    figma!.projectType = projectType;
    figma!.fileKey = fileKey;
  }

  bool get hasApiKey {
    return figma?.apiKey != null && figma?.apiKey != '';
  }

  @override
  List<Object?> get props => [
        figma?.apiKey,
        figma?.fileKey,
        figma?.projectType,
      ];
}
