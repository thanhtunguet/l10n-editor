part of 'database.dart';

@Entity()
class Figma {
  static const DEFAULT_ID = 1;

  @Id(assignable: true)
  int id = 0;

  String apiKey = '';

  String fileKey = '';

  String projectType = '';

  @override
  String toString() {
    return "Figma#$hashCode: projectType=$projectType, apiKey=$apiKey, fileKey=$fileKey";
  }
}
