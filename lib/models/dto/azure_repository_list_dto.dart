import 'package:l10n_manipulator/models/azure.dart';
import 'package:truesight_flutter/truesight_flutter.dart';

@reflector
class AzureRepositoryListDto extends DataModel {
  int count = 0;

  DataList<AzureRepo> value = DataList<AzureRepo>();
}
