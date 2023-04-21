part of 'azure.dart';

@reflector
class AzureRepo extends DataModel {
  String id = '';

  String name = '';

  String url = '';

  AzureProject project = AzureProject();

  String defaultBranch = '';

  int size = 0;

  String remoteUrl = '';

  String sshUrl = '';

  String webUrl = '';
}
