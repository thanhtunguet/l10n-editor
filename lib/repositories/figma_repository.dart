import 'package:dio/dio.dart';
import 'package:figma/figma.dart';
import 'package:injectable/injectable.dart';
import 'package:truesight_flutter/truesight_flutter.dart';

@singleton
class FigmaRepository extends HttpRepository {
  FigmaRepository() : super() {
    baseUrl = 'https://api.figma.com/v1';
  }

  Options headers(String apiToken) {
    return Options(headers: {
      'X-FIGMA-TOKEN': apiToken,
    });
  }

  Future<FileResponse> file(String apiKey, String fileKey) async {
    RegExp figmaRegex = RegExp(r'\/file\/([a-zA-Z0-9]+)\/');
    String? figmaFileKey = figmaRegex.stringMatch(fileKey)?.split('/')?[2];
    var response = await get("/files/$figmaFileKey", options: headers(apiKey));
    return FileResponse.fromJson(response.data);
  }

  List<Text> findTextNodes(FileResponse response) {
    var textNodes = <Text>[];
    var node = response.document!.children![0];
    if (node is Canvas) {
      var frame = node.children![0];
      if (frame is Frame) {
        for (var element in frame.children!) {
          if (element is Text) {
            if (element.name!.startsWith("label_")) {
              textNodes.add(element);
            }
          }
        }
      }
    }
    return textNodes;
  }
}
