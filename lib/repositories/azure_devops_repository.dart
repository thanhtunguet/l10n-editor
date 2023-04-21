import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:l10n_manipulator/config/consts.dart';
import 'package:l10n_manipulator/models/azure.dart';
import 'package:l10n_manipulator/models/dto/azure_git_object_list_dto.dart';
import 'package:l10n_manipulator/models/dto/azure_project_list_dto.dart';
import 'package:l10n_manipulator/models/dto/azure_repository_list_dto.dart';
import 'package:l10n_manipulator/models/git_object.dart';
import 'package:truesight_flutter/truesight_flutter.dart';

class AzureDevopsRepository extends HttpRepository {
  AzureDevopsRepository() : super() {
    baseUrl = DEVOPS_URL;
    dio.options.queryParameters = {
      'api-version': '6.0-preview',
    };
  }

  Options headers(String pat) {
    return Options(
      headers: {
        'Authorization': "Basic ${base64Encode(utf8.encode(":$pat"))}",
      },
    );
  }

  Future<List<AzureProject>> projects(String personalAccessToken) async {
    Response response = await get(
      '/_apis/projects',
      options: headers(personalAccessToken),
    );
    return response.body<AzureProjectListDto>().value.toList();
  }

  Future<List<AzureRepo>> repos(
      String personalAccessToken, String projectId) async {
    Response response = await get(
      "/$projectId/_apis/git/repositories",
      options: headers(personalAccessToken),
    );
    return response.body<AzureRepositoryListDto>().value.toList();
  }

  Future<List<GitObject>> files(
      String personalAccessToken, String projectId, String repositoryId) async {
    Response response = await get(
      "/$projectId/_apis/git/repositories/$repositoryId/items",
      options: headers(personalAccessToken),
      queryParameters: {
        'recursionLevel': 'Full',
      },
    );
    return response.body<AzureGitObjectListDto>().value.toList();
  }

  Future<String> getFileContents(
    String personalAccessToken,
    String projectId,
    String repositoryId,
    String path,
  ) async {
    Response response = await get(
      "/$projectId/_apis/git/repositories/$repositoryId/items",
      options: headers(personalAccessToken),
      queryParameters: {
        'path': path,
      },
    );
    return response.data.toString();
  }

  Future<String> getLatestCommitId(
    String personalAccessToken,
    String repositoryId,
  ) async {
    Response response = await get(
      "/_apis/git/repositories/$repositoryId/items",
      options: headers(personalAccessToken),
    );
    return response.data['value'][0]['commitId'];
  }

  Future<void> updateFiles(
    String personalAccessToken,
    String repositoryId,
    String latestCommitId,
    Map<String, String> filesContents,
  ) async {
    final changes = filesContents.entries.map((MapEntry<String, String> entry) {
      return {
        'changeType': 2,
        'item': {
          'path': entry.key,
        },
        'newContent': {
          'contentType': 0,
          'content': entry.value,
        },
      };
    }).toList();
    Response response = await post(
      "/_apis/git/repositories/$repositoryId/pushes",
      options: headers(personalAccessToken),
      data: {
        "commits": [
          {
            "changes": changes,
            "comment": "Update locales for project using tool"
          }
        ],
        "refUpdates": [
          {
            "name": "refs/heads/main",
            "oldObjectId": latestCommitId,
          }
        ]
      },
    );
    return response.data;
  }
}
