import 'package:truesight_flutter/truesight_flutter.dart';

@reflector
class GitObject extends DataModel {
  String objectId = "";

  String gitObjectType = "blob"; // "blob", "tree"

  String commitId = "";

  String path = "";

  bool isFolder = false;

  String url = "";
}
