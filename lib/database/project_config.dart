part of 'database.dart';

@Entity()
class ProjectConfig {
  static const defaultId = 1;

  @Id(assignable: true)
  int id = 0;

  String figmaApiKey = '';

  String fileKey = '';

  String? azureDevopsToken = '';

  String projectType = '';

  @override
  String toString() {
    return "Figma#$hashCode: projectType=$projectType, apiKey=$figmaApiKey, fileKey=$fileKey, devopsApiKey=$azureDevopsToken";
  }
}
