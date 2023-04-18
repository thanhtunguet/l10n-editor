part of 'database.dart';

@Entity()
class Figma {
  static const DEFAULT_ID = 1;

  @Id(assignable: true)
  int id = 0;

  String apiKey = '';
}
