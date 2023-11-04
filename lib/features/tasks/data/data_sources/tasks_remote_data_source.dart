import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/tasks/data/models/clickup_space_model.dart';
import 'package:thetimeblockingapp/features/tasks/data/models/clickup_task_model.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_clickup_folder_in_spacce_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folderless_list_clickup_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_folder_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_task_use_case.dart';

import '../../../../common/models/clickup_workspace_model.dart';
import '../../../../core/extensions.dart';
import '../../../../core/network/clickup_header.dart';
import '../../../../core/network/network.dart';
import '../../domain/entities/task_parameters.dart';
import '../../domain/use_cases/create_clickup_list_in_folder_use_case.dart';
import '../../domain/use_cases/add_task_to_list_use_case.dart';
import '../../domain/use_cases/add_tag_to_task_use_case.dart';
import '../../domain/use_cases/get_clickup_folderless_lists_in_space_use_case.dart';
import '../../domain/use_cases/get_clickup_folders_in_space_use_case.dart';
import '../../domain/use_cases/get_clickup_list_use_case.dart';
import '../../domain/use_cases/get_clickup_lists_in_folder_use_case.dart';
import '../../domain/use_cases/get_clickup_spaces_in_workspace_use_case.dart';
import '../../domain/use_cases/get_clickup_tags_in_space_use_case.dart';
import '../../domain/use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';
import '../../domain/use_cases/get_clickup_workspaces_use_case.dart';
import '../../domain/use_cases/remove_task_from_list_task_use_case.dart';
import '../../domain/use_cases/remove_tag_from_task_use_case.dart';
import '../models/clickup_folder_model.dart';
import '../models/clickup_list_model.dart';

abstract class TasksRemoteDataSource {
  Future<List<ClickupTaskModel>> getTasksInWorkspace(
      {required GetClickupTasksInWorkspaceParams params});

  Future<ClickupTaskModel> createTaskInList(
      {required ClickupTaskParams params});

  Future<ClickupTaskModel> updateTask({required ClickupTaskParams params});

  Future<Unit> deleteTask({required DeleteClickupTaskParams params});

  Future<List<ClickupWorkspaceModel>> getClickupWorkspaces(
      {required GetClickupWorkspacesParams params});

  Future<List<ClickupFolderModel>> getClickupFolders(
      {required GetClickupFoldersInSpaceParams params});

  Future<List<ClickupListModel>> getClickupListsInFolder(
      {required GetClickupListsInFolderParams params});

  Future<ClickupListModel> createClickupListInFolder(
      {required CreateClickupListInFolderParams params});

  Future<List<ClickupListModel>> getClickupFolderlessLists(
      {required GetClickupFolderlessListsInSpaceParams params});

  Future<List<ClickupSpaceModel>> getClickupSpacesInWorkspaces(
      {required GetClickupSpacesInWorkspacesParams params});

  Future<List<ClickupTagModel>> getClickupTags(
      {required GetClickupTagsInSpaceParams params});

  Future<Unit> removeTagFromTask({required RemoveTagFromTaskParams params});

  Future<Unit> addTagToTask({required AddTagToTaskParams params});

  Future<Unit> removeTaskFromAdditionalList({required RemoveTaskFromListParams params});

  Future<Unit> addTaskToList({required AddTaskToListParams params});

  Future<ClickupListModel> getClickupList(
      {required GetClickupListParams params});

  Future<ClickupListModel> createFolderlessClickupList(
      {required CreateFolderlessListClickupParams params});

  Future<ClickupFolderModel> createClickupFolderInSpace(
      {required CreateClickupFolderInSpaceParams params});

  Future<Unit> deleteList({required DeleteClickupListParams params});

  Future<Unit> deleteFolder({required DeleteClickupFolderParams params});
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
        url: url, queryParameters: params.filtersParams.query);
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
  Future<Unit> deleteTask({required DeleteClickupTaskParams params}) async {
    Uri uri = Uri.parse("$clickupUrl/task/${params.taskId}");
    await network.delete(
      uri: uri,
      headers: clickupHeader(clickupAccessToken: params.clickupAccessToken),
    );
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
      {required GetClickupFoldersInSpaceParams params}) async {
    List<ClickupFolderModel> result = [];
    final url = "$clickupUrl/space/${params.clickupSpace.id}/folder";
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
      {required GetClickupFolderlessListsInSpaceParams params}) async {
    List<ClickupListModel> result = [];
    final url = "$clickupUrl/space/${params.clickupSpace.id}/list";
    Map<String, Either<List, String>>? queryParameters = params.archived == null
        ? null
        : {"archived": Right("${params.archived}")};
    final Uri uri = UriExtension.uriHttpsClickupAPI(
        url: url, queryParameters: queryParameters);
    final response = await network.get(
        uri: uri,
        headers: clickupHeader(clickupAccessToken: params.clickupAccessToken));
    for (var element in (json.decode(response.body)["lists"] as List)) {
      result.add(ClickupListModel.fromJson(element));
    }
    return result;
  }

  @override
  Future<List<ClickupSpaceModel>> getClickupSpacesInWorkspaces(
      {required GetClickupSpacesInWorkspacesParams params}) async {
    List<ClickupSpaceModel> result = [];
    final url = "$clickupUrl/team/${params.clickupWorkspace.id}/space";
    Map<String, Either<List, String>>? queryParameters = params.archived == null
        ? null
        : {"archived": Right("${params.archived}")};
    final Uri uri = UriExtension.uriHttpsClickupAPI(
        url: url, queryParameters: queryParameters);
    final response = await network.get(
        uri: uri,
        headers: clickupHeader(clickupAccessToken: params.clickupAccessToken));
    for (var element in (json.decode(response.body)["spaces"] as List)) {
      result.add(ClickupSpaceModel.fromJson(element));
    }
    return result;
  }

  @override
  Future<List<ClickupTagModel>> getClickupTags(
      {required GetClickupTagsInSpaceParams params}) async {
    List<ClickupTagModel> result = [];
    final url = "$clickupUrl/space/${params.clickupSpace.id}/tag";
    Map<String, Either<List, String>>? queryParameters = params.archived == null
        ? null
        : {"archived": Right("${params.archived}")};
    final Uri uri = UriExtension.uriHttpsClickupAPI(
        url: url, queryParameters: queryParameters);
    final response = await network.get(
        uri: uri,
        headers: clickupHeader(clickupAccessToken: params.clickupAccessToken));
    for (var element in (json.decode(response.body)["tags"] as List)) {
      result.add(ClickupTagModel.fromJson(element));
    }
    return result;
  }

  @override
  Future<Unit> removeTagFromTask({required RemoveTagFromTaskParams params}) async {
    Uri uri = Uri.parse("$clickupUrl/task/${params.taskId}/tag/${params.tagName}");
    await network.delete(
      uri: uri,
      headers: clickupHeader(clickupAccessToken: params.clickupAccessToken),
    );
    return unit;
  }

  @override
  Future<Unit> addTagToTask({required AddTagToTaskParams params})  async {
    Uri uri = Uri.parse("$clickupUrl/task/${params.taskId}/tag/${params.tagName}");
    await network.post(
      body: {},//fails without it :{"err":"Unexpected token n in JSON at position 0","ECODE":"JSON_001"}
      uri: uri,
      headers: clickupHeader(clickupAccessToken: params.clickupAccessToken),
    );
    return unit;
  }

  @override
  Future<Unit> addTaskToList({required AddTaskToListParams params})async {
    Uri uri = Uri.parse("$clickupUrl/list/${params.taskId}/task/${params.listId}");
    await network.post(
      body: {},//fails without it :{"err":"Unexpected token n in JSON at position 0","ECODE":"JSON_001"}
      uri: uri,
      headers: clickupHeader(clickupAccessToken: params.clickupAccessToken),
    );
    return unit;
  }
  @override
  Future<Unit> removeTaskFromAdditionalList({required RemoveTaskFromListParams params})  async {
    Uri uri = Uri.parse("$clickupUrl/list/${params.taskId}/task/${params.listId}");
    await network.delete(
      uri: uri,
      headers: clickupHeader(clickupAccessToken: params.clickupAccessToken),
    );
    return unit;
  }

  @override
  Future<ClickupListModel> getClickupList({required GetClickupListParams params}) async {
    final response = await network.get(
        uri: Uri.parse("$clickupUrl/list/${params.listId}"),
        headers: clickupHeader(clickupAccessToken: params.clickupAccessToken));
    return ClickupListModel.fromJson(json.decode(response.body));
  }

  @override
  Future<ClickupListModel> createClickupListInFolder(
      {required CreateClickupListInFolderParams params}) async {
    final response = await network.post(
        uri: Uri.parse("$clickupUrl/folder/${params.clickupFolder.id}/list"),
        headers: clickupHeader(clickupAccessToken: params.clickupAccessToken),
        body: {"name": params.listName, "assignee": params.assignee?.id});
    return ClickupListModel.fromJson(json.decode(response.body));
  }

  @override
  Future<ClickupListModel> createFolderlessClickupList(
      {required CreateFolderlessListClickupParams params}) async {
    final response = await network.post(
        uri: Uri.parse("$clickupUrl/space/${params.clickupSpace.id}/list"),
        headers: clickupHeader(clickupAccessToken: params.clickupAccessToken),
        body: {"name": params.listName, "assignee": params.assignee?.id});
    return ClickupListModel.fromJson(json.decode(response.body));
  }

  @override
  Future<ClickupFolderModel> createClickupFolderInSpace(
      {required CreateClickupFolderInSpaceParams params}) async {
    final response = await network.post(
        uri: Uri.parse("$clickupUrl/space/${params.clickupSpace.id}/list"),
        headers: clickupHeader(clickupAccessToken: params.clickupAccessToken),
        body: {"name": params.folderName});
    return ClickupFolderModel.fromJson(json.decode(response.body));
  }

  @override
  Future<Unit> deleteList({required DeleteClickupListParams params}) async{
    Uri uri = Uri.parse("$clickupUrl/list/${params.listId}");
    await network.delete(
      uri: uri,
      headers: clickupHeader(clickupAccessToken: params.clickupAccessToken),
    );
    return unit;
  }

  @override
  Future<Unit> deleteFolder({required DeleteClickupFolderParams params})  async{
    Uri uri = Uri.parse("$clickupUrl/folder/${params.folderId}");
    await network.delete(
      uri: uri,
      headers: clickupHeader(clickupAccessToken: params.clickupAccessToken),
    );
    return unit;
  }
}
