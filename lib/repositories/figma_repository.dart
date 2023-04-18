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

  FigmaRepository() : super() {
    baseUrl = 'https://api.figma.com/v1';
  }

  // Future<List<FigmaFile>> files() {
  //   Options options = Options();
  //   options.headers = {
  //     'X-Figma-Token': _apiKey,
  //   };
  //   // Response<List<FigmaFile>> response=await get('/files', options: options);
  //   // return response.body<List<FigmaFile>();
  //
  // }
}
