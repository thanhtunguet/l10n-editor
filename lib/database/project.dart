part of 'database.dart';

@Entity()
class Project {
  @Id(assignable: true)
  int id = 0;

  String path = '';

  String name = '';

  ProjectType projectType = ProjectType.flutter;
}
