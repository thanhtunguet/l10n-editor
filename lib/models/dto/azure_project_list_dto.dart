import 'package:truesight_flutter/truesight_flutter.dart';

import '../azure.dart';

@reflector
class AzureProjectListDto extends DataModel {
  int count = 0;

  DataList<AzureProject> value = DataList<AzureProject>();
}
