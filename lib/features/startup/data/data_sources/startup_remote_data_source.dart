import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/common/models/clickup_workspace_model.dart';
import 'package:thetimeblockingapp/core/extensions.dart';
import 'package:thetimeblockingapp/core/network/network.dart';
import '../../../../core/network/clickup_header.dart';
import '../../../tasks/data/models/clickup_list_model.dart';
import '../../domain/use_cases/get_clickup_folders_use_case.dart';
import '../../domain/use_cases/get_clickup_lists_in_folder_use_case.dart';
import '../../domain/use_cases/get_clickup_workspaces_use_case.dart';
import '../../../tasks/data/models/clickup_folder_model.dart';

abstract class StartUpRemoteDataSource {
  Future<List<ClickupWorkspaceModel>> getClickupWorkspaces(
      {required GetClickupWorkspacesParams params});

  Future<List<ClickupFolderModel>> getClickupFolders(
      {required GetClickupFoldersParams params});

  Future<List<ClickupListModel>> getClickupListsInFolder(
      {required GetClickupListsInFolderParams params});
}

class StartUpRemoteDataSourceImpl implements StartUpRemoteDataSource {
  final Network network;
  final String clickupClientId;
  final String clickupClientSecret;
  final String clickupUrl;

  StartUpRemoteDataSourceImpl({
    required this.network,
    required this.clickupClientId,
    required this.clickupClientSecret,
    required this.clickupUrl,
  });

  @override
  Future<List<ClickupWorkspaceModel>> getClickupWorkspaces(
      {required GetClickupWorkspacesParams params}) async {
    List<ClickupWorkspaceModel> result = [];
    final response = await network.get(
        uri: Uri.parse("$clickupUrl/team"),
        headers: clickupHeader(clickupAccessToken: params.clickupAccessToken));
    for (var element in (json.decode(response.body)["teams"] as List)) {
      result.add(ClickupWorkspaceModel.fromJson(element));
    }
    return result;
  }

  @override
  Future<List<ClickupFolderModel>> getClickupFolders(
      {required GetClickupFoldersParams params}) async {
    List<ClickupFolderModel> result = [];
    final url = "$clickupUrl/space/${params.clickupWorkspace.id}/folder";
    Map<String, Either<List, String>>? queryParameters = params.archived == null
        ? null
        : {"archived": Right("${params.archived}")};
    final Uri uri = UriExtension.uriHttpsClickupAPI(
        url: url, queryParameters: queryParameters);
    final response = await network.get(
        uri: uri,
        headers: clickupHeader(clickupAccessToken: params.clickupAccessToken));
    for (var element in (json.decode(response.body)["folders"] as List)) {
      result.add(ClickupFolderModel.fromJson(element));
    }
    return result;
  }

  @override
  Future<List<ClickupListModel>> getClickupListsInFolder(
      {required GetClickupListsInFolderParams params}) async {
    List<ClickupListModel> result = [];
    final url = "$clickupUrl/folder/${params.clickupFolder.id}/list";
    Map<String, Either<List, String>>? queryParameters = params.archived == null
        ? null
        : {"archived": Right("${params.archived}")};
    final Uri uri = UriExtension.uriHttpsClickupAPI(
        url: url, queryParameters: queryParameters);
    final response = await network.get(
        uri: uri,
        headers: clickupHeader(clickupAccessToken: params.clickupAccessToken));
    for (var element in (json.decode(response.body)["folders"] as List)) {
      result.add(ClickupListModel.fromJson(element));
    }
    return result;
  }
}
