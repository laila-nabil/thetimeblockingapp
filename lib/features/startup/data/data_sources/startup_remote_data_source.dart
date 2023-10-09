import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/common/models/clickup_workspace_model.dart';
import 'package:thetimeblockingapp/core/extensions.dart';
import 'package:thetimeblockingapp/core/network/network.dart';
import '../../../../core/network/clickup_header.dart';
import '../../domain/use_cases/get_clickup_folders_use_case.dart';
import '../../domain/use_cases/get_clickup_workspaces_use_case.dart';
import '../../../tasks/data/models/clickup_folder_model.dart';

abstract class StartUpRemoteDataSource {
  Future<List<ClickupWorkspaceModel>> getClickUpWorkspaces(
      {required GetClickUpWorkspacesParams params});

  Future<List<ClickupFolderModel>> getClickUpFolders(
      {required GetClickUpFoldersParams params});
}

class StartUpRemoteDataSourceImpl implements StartUpRemoteDataSource {
  final Network network;
  final String clickUpClientId;
  final String clickUpClientSecret;
  final String clickUpUrl;

  StartUpRemoteDataSourceImpl({
    required this.network,
    required this.clickUpClientId,
    required this.clickUpClientSecret,
    required this.clickUpUrl,
  });

  @override
  Future<List<ClickupWorkspaceModel>> getClickUpWorkspaces(
      {required GetClickUpWorkspacesParams params}) async {
    List<ClickupWorkspaceModel> result = [];
    final response = await network.get(
        uri: Uri.parse("$clickUpUrl/team"),
        headers: clickUpHeader(clickUpAccessToken: params.clickUpAccessToken));
    for (var element in (json.decode(response.body)["teams"] as List)) {
      result.add(ClickupWorkspaceModel.fromJson(element));
    }
    return result;
  }

  @override
  Future<List<ClickupFolderModel>> getClickUpFolders(
      {required GetClickUpFoldersParams params}) async {
    List<ClickupFolderModel> result = [];
    final url = "$clickUpUrl/space/${params.clickupWorkspace.id}/folder";
    final Uri uri = UriExtension.uriHttpsClickupAPI(url: url,
        queryParameters: {"archived": Right("${params.archived}")});
    final response = await network.get(
        uri: uri,
        headers: clickUpHeader(clickUpAccessToken: params.clickUpAccessToken));
    for (var element in (json.decode(response.body)["folders"] as List)) {
      result.add(ClickupFolderModel.fromJson(element));
    }
    return result;
  }
}
