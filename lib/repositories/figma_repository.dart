import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:l10n_manipulator/models/figma_file.dart';
import 'package:truesight_flutter/truesight_flutter.dart';

@singleton
class FigmaRepository extends HttpRepository {
  String _apiKey = '';

  set apiKey(String apiKey) {
    _apiKey = apiKey;
  }

  get headers {
    return {
      'X-FIGMA-TOKEN': _apiKey,
    };
  }

  FigmaRepository() : super() {
    baseUrl = 'https://api.figma.com/v1';
  }

  Future<List<FigmaFile>> files() async {
    Options options = Options();
    options.headers = headers;
    Response<dynamic> response = await get(
      '/files',
      options: options,
      queryParameters: {
        'archived': false,
        'drafts': true,
      },
    );
    final files = response.data['files'];
    return files.map((e) => FigmaFile.fromJson(e)).toList();
  }
}
