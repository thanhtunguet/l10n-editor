import 'package:truesight_flutter/truesight_flutter.dart';

import '../git_object.dart';

@reflector
class AzureGitObjectListDto extends DataModel {
  int count = 0;

  DataList<GitObject> value = DataList<GitObject>();
}
