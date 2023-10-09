import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/tasks/data/models/clickup_task_model.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_task_use_case.dart';

import '../../../../common/models/clickup_workspace_model.dart';
import '../../../../core/extensions.dart';
import '../../../../core/network/clickup_header.dart';
import '../../../../core/network/network.dart';
import '../../domain/entities/task_parameters.dart';
import '../../domain/use_cases/get_clickup_folderless_lists_use_case.dart';
import '../../domain/use_cases/get_clickup_folders_use_case.dart';
import '../../domain/use_cases/get_clickup_lists_in_folder_use_case.dart';
import '../../domain/use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';
import '../../domain/use_cases/get_clickup_workspaces_use_case.dart';
import '../models/clickup_folder_model.dart';
import '../models/clickup_list_model.dart';

abstract class TasksRemoteDataSource {
  Future<List<ClickupTaskModel>> getTasksInWorkspace(
      {required GetClickupTasksInWorkspaceParams params});

  Future<ClickupTaskModel> createTaskInList(
      {required ClickupTaskParams params});

  Future<ClickupTaskModel> updateTask(
      {required ClickupTaskParams params});

  Future<Unit> deleteTask(
      {required DeleteClickupTaskParams params});

  Future<List<ClickupWorkspaceModel>> getClickupWorkspaces(
      {required GetClickupWorkspacesParams params});

  Future<List<ClickupFolderModel>> getClickupFolders(
      {required GetClickupFoldersParams params});

  Future<List<ClickupListModel>> getClickupListsInFolder(
      {required GetClickupListsInFolderParams params});

  Future<List<ClickupListModel>> getClickupFolderlessLists(
      {required GetClickupFolderlessListsParams params});
}

class TasksRemoteDataSourceImpl implements TasksRemoteDataSource {
  final Network network;
  final String clickupClientId;
  final String clickupClientSecret;
  final String clickupUrl;

  TasksRemoteDataSourceImpl({
    required this.network,
    required this.clickupClientId,
    required this.clickupClientSecret,
    required this.clickupUrl,
  });

  @override
  Future<List<ClickupTaskModel>> getTasksInWorkspace(
      {required GetClickupTasksInWorkspaceParams params}) async {
    List<ClickupTaskModel> result = [];
    String url = "$clickupUrl/team/${params.workspaceId}/task";
    final uri = UriExtension.uriHttpsClickupAPI(
        url: url,
        queryParameters: params.filtersParams.query);
    printDebug("uri $uri");
    final response = await network.get(
        uri: uri,
        headers: clickupHeader(
            clickupAccessToken: params.filtersParams.clickupAccessToken));
    for (var element in (json.decode(response.body)["tasks"] as List)) {
      result.add(ClickupTaskModel.fromJson(element));
    }
    return result;
  }

  @override
  Future<ClickupTaskModel> createTaskInList(
      {required ClickupTaskParams params}) async {
    Uri uri = Uri.parse("$clickupUrl/list/${params.listId}/task");
    final response = await network.post(
        uri: uri,
        headers: clickupHeader(clickupAccessToken: params.clickupAccessToken),
        body: params.toJson());
    return ClickupTaskModel.fromJson(json.decode(response.body));
  }

  @override
  Future<ClickupTaskModel> updateTask(
      {required ClickupTaskParams params}) async {
    Uri uri = Uri.parse("$clickupUrl/task/${params.taskId}");
    final response = await network.put(
        uri: uri,
        headers: clickupHeader(clickupAccessToken: params.clickupAccessToken),
        body: params.toJson());
    return ClickupTaskModel.fromJson(json.decode(response.body));
  }

  @override
  Future<Unit> deleteTask({required DeleteClickupTaskParams params}) async{
    Uri uri = Uri.parse("$clickupUrl/task/${params.taskId}");
    await network.delete(
        uri: uri,
        headers: clickupHeader(clickupAccessToken: params.clickupAccessToken),);
    return unit;
  }


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

  @override
  Future<List<ClickupListModel>> getClickupFolderlessLists(
      {required GetClickupFolderlessListsParams params})  async {
    List<ClickupListModel> result = [];
    final url = "$clickupUrl/space/${params.clickupWorkspace.id}/list";
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
