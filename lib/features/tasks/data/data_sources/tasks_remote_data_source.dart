import 'dart:convert';

import 'package:dartz/dartz.dart' as dartz; 
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/tasks/data/models/clickup_space_model.dart';
import 'package:thetimeblockingapp/features/tasks/data/models/clickup_task_model.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folder_in_space_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folderless_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_folder_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_task_use_case.dart';

import '../../../../common/models/clickup_workspace_model.dart';
import '../../../../core/extensions.dart';
import '../../../../core/network/clickup_header.dart';
import '../../../../core/network/network.dart';
import '../../domain/entities/task_parameters.dart';
import '../../domain/use_cases/create_list_in_folder_use_case.dart';
import '../../domain/use_cases/add_task_to_list_use_case.dart';
import '../../domain/use_cases/add_tag_to_task_use_case.dart';
import '../../domain/use_cases/create_tag_in_space_use_case.dart';
import '../../domain/use_cases/delete_tag_use_case.dart';
import '../../domain/use_cases/get_folderless_lists_in_space_use_case.dart';
import '../../domain/use_cases/get_folders_in_space_use_case.dart';
import '../../domain/use_cases/get_list_use_case.dart';
import '../../domain/use_cases/get_lists_in_folder_use_case.dart';
import '../../domain/use_cases/get_spaces_in_workspace_use_case.dart';
import '../../domain/use_cases/get_tags_in_space_use_case.dart';
import '../../domain/use_cases/get_tasks_in_single_workspace_use_case.dart';
import '../../domain/use_cases/get_workspaces_use_case.dart';
import '../../domain/use_cases/remove_tag_from_task_use_case.dart';
import '../../domain/use_cases/update_tag_use_case.dart';
import '../models/clickup_folder_model.dart';
import '../models/clickup_list_model.dart';

abstract class TasksRemoteDataSource {
  Future<List<ClickupTaskModel>> getTasksInWorkspace(
      {required GetTasksInWorkspaceParams params});

  Future<ClickupTaskModel> createTaskInList(
      {required CreateTaskParams params});

  Future<ClickupTaskModel> updateTask({required CreateTaskParams params});

  Future<dartz.Unit> deleteTask({required DeleteTaskParams params});

  Future<List<ClickupWorkspaceModel>> getClickupWorkspaces(
      {required GetWorkspacesParams params});

  Future<List<ClickupFolderModel>> getClickupFolders(
      {required GetFoldersInSpaceParams params});

  Future<List<ClickupListModel>> getClickupListsInFolder(
      {required GetListsInFolderParams params});

  Future<ClickupListModel> createClickupListInFolder(
      {required CreateListInFolderParams params});

  Future<List<ClickupListModel>> getClickupFolderlessLists(
      {required GetFolderlessListsInSpaceParams params});

  Future<List<ClickupSpaceModel>> getClickupSpacesInWorkspaces(
      {required GetSpacesInWorkspacesParams params});

  Future<List<ClickupTagModel>> getClickupTags(
      {required GetTagsInSpaceParams params});

  Future<dartz.Unit> removeTagFromTask({required RemoveTagFromTaskParams params});

  Future<dartz.Unit> addTagToTask({required AddTagToTaskParams params});


  Future<ClickupListModel> getClickupList(
      {required GetListParams params});

  Future<ClickupListModel> createFolderlessClickupList(
      {required CreateFolderlessListParams params});

  Future<ClickupFolderModel> createClickupFolderInSpace(
      {required CreateFolderInSpaceParams params});

  Future<dartz.Unit> deleteList({required DeleteListParams params});

  Future<dartz.Unit> deleteFolder({required DeleteFolderParams params});

  Future<dartz.Unit> createClickupTagInSpace(
      {required CreateTagInSpaceParams params});

  Future<dartz.Unit> updateClickupTag(
      {required UpdateTagParams params});

  Future<dartz.Unit> deleteClickupTag({required DeleteTagParams params});
}

class ClickupTasksRemoteDataSourceImpl implements TasksRemoteDataSource {
  final Network network;
  final String clickupClientId;
  final String clickupClientSecret;
  final String clickupUrl;

  ClickupTasksRemoteDataSourceImpl({
    required this.network,
    required this.clickupClientId,
    required this.clickupClientSecret,
    required this.clickupUrl,
  });

  @override
  Future<List<ClickupTaskModel>> getTasksInWorkspace(
      {required GetTasksInWorkspaceParams params}) async {
    List<ClickupTaskModel> result = [];
    String url = "$clickupUrl/team/${params.workspaceId}/task";
    final uri = UriExtension.uriHttpsClickupAPI(
        url: url, queryParameters: params.filtersParams.query);
    printDebug("uri $uri");
    final response = await network.get(
        uri: uri,
        headers: clickupHeader(
            clickupAccessToken: params.filtersParams.accessToken));
    for (var element in (json.decode(response.body)["tasks"] as List)) {
      result.add(ClickupTaskModel.fromJson(element));
    }
    return result;
  }

  @override
  Future<ClickupTaskModel> createTaskInList(
      {required CreateTaskParams params}) async {
    Uri uri = Uri.parse("$clickupUrl/list/${params.getListId}/task");
    final response = await network.post(
        uri: uri,
        headers: clickupHeader(clickupAccessToken: params.accessToken),
        body: params.toJson());
    return ClickupTaskModel.fromJson(json.decode(response.body));
  }

  @override
  Future<ClickupTaskModel> updateTask(
      {required CreateTaskParams params}) async {
    Uri uri = Uri.parse("$clickupUrl/task/${params.taskId}");
    final response = await network.put(
        uri: uri,
        headers: clickupHeader(clickupAccessToken: params.accessToken),
        body: params.toJson());
    return ClickupTaskModel.fromJson(json.decode(response.body));
  }

  @override
  Future<dartz.Unit> deleteTask({required DeleteTaskParams params}) async {
    Uri uri = Uri.parse("$clickupUrl/task/${params.taskId}");
    await network.delete(
      uri: uri,
      headers: clickupHeader(clickupAccessToken: params.accessToken),
    );
    return dartz.unit;
  }

  @override
  Future<List<ClickupWorkspaceModel>> getClickupWorkspaces(
      {required GetWorkspacesParams params}) async {
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
      {required GetFoldersInSpaceParams params}) async {
    List<ClickupFolderModel> result = [];
    final url = "$clickupUrl/space/${params.clickupSpace.id}/folder";
    Map<String, dartz.Either<List, String>>? queryParameters = params.archived == null
        ? null
        : {"archived": dartz.Right("${params.archived}")};
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
      {required GetListsInFolderParams params}) async {
    List<ClickupListModel> result = [];
    final url = "$clickupUrl/folder/${params.clickupFolder.id}/list";
    Map<String, dartz.Either<List, String>>? queryParameters = params.archived == null
        ? null
        : {"archived": dartz.Right("${params.archived}")};
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
      {required GetFolderlessListsInSpaceParams params}) async {
    List<ClickupListModel> result = [];
    final url = "$clickupUrl/space/${params.clickupSpace.id}/list";
    Map<String, dartz.Either<List, String>>? queryParameters = params.archived == null
        ? null
        : {"archived": dartz.Right("${params.archived}")};
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
      {required GetSpacesInWorkspacesParams params}) async {
    List<ClickupSpaceModel> result = [];
    final url = "$clickupUrl/team/${params.clickupWorkspace.id}/space";
    Map<String, dartz.Either<List, String>>? queryParameters = params.archived == null
        ? null
        : {"archived": dartz.Right("${params.archived}")};
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
      {required GetTagsInSpaceParams params}) async {
    List<ClickupTagModel> result = [];
    final url = "$clickupUrl/space/${params.space.id}/tag";
    Map<String, dartz.Either<List, String>>? queryParameters = params.archived == null
        ? null
        : {"archived": dartz.Right("${params.archived}")};
    final Uri uri = UriExtension.uriHttpsClickupAPI(
        url: url, queryParameters: queryParameters);
    final response = await network.get(
        uri: uri,
        headers: clickupHeader(clickupAccessToken: params.accessToken));
    for (var element in (json.decode(response.body)["tags"] as List)) {
      result.add(ClickupTagModel.fromJson(element));
    }
    return result;
  }

  @override
  Future<dartz.Unit> removeTagFromTask(
      {required RemoveTagFromTaskParams params}) async {
    Uri uri =
        Uri.parse("$clickupUrl/task/${params.taskId}/tag/${params.tagName}");
    await network.delete(
      uri: uri,
      headers: clickupHeader(clickupAccessToken: params.clickupAccessToken),
    );
    return dartz.unit;
  }

  @override
  Future<dartz.Unit> addTagToTask({required AddTagToTaskParams params}) async {
    Uri uri =
        Uri.parse("$clickupUrl/task/${params.taskId}/tag/${params.tagName}");
    await network.post(
      body: {},
      //fails without it :{"err":"Unexpected token n in JSON at position 0","ECODE":"JSON_001"}
      uri: uri,
      headers: clickupHeader(clickupAccessToken: params.accessToken),
    );
    return dartz.unit;
  }


  @override
  Future<ClickupListModel> getClickupList(
      {required GetListParams params}) async {
    final response = await network.get(
        uri: Uri.parse("$clickupUrl/list/${params.listId}"),
        headers: clickupHeader(clickupAccessToken: params.clickupAccessToken));
    return ClickupListModel.fromJson(json.decode(response.body));
  }

  @override
  Future<ClickupListModel> createClickupListInFolder(
      {required CreateListInFolderParams params}) async {
    final response = await network.post(
        uri: Uri.parse("$clickupUrl/folder/${params.folder.id}/list"),
        headers: clickupHeader(clickupAccessToken: params.accessToken),
        body: {"name": params.listName, "assignee": params.assignee?.id});
    return ClickupListModel.fromJson(json.decode(response.body));
  }

  @override
  Future<ClickupListModel> createFolderlessClickupList(
      {required CreateFolderlessListParams params}) async {
    final response = await network.post(
        uri: Uri.parse("$clickupUrl/space/${params.space.id}/list"),
        headers: clickupHeader(clickupAccessToken: params.accessToken),
        body: {"name": params.listName, "assignee": params.assignee?.id});
    return ClickupListModel.fromJson(json.decode(response.body));
  }

  @override
  Future<ClickupFolderModel> createClickupFolderInSpace(
      {required CreateFolderInSpaceParams params}) async {
    final response = await network.post(
        uri: Uri.parse("$clickupUrl/space/${params.space.id}/folder"),
        headers: clickupHeader(clickupAccessToken: params.accessToken),
        body: {"name": params.folderName});
    return ClickupFolderModel.fromJson(json.decode(response.body));
  }

  @override
  Future<dartz.Unit> deleteList({required DeleteListParams params}) async {
    Uri uri = Uri.parse("$clickupUrl/list/${params.listId}");
    await network.delete(
      uri: uri,
      headers: clickupHeader(clickupAccessToken: params.accessToken),
    );
    return dartz.unit;
  }

  @override
  Future<dartz.Unit> deleteFolder({required DeleteFolderParams params}) async {
    Uri uri = Uri.parse("$clickupUrl/folder/${params.folderId}");
    await network.delete(
      uri: uri,
      headers: clickupHeader(clickupAccessToken: params.accessToken),
    );
    return dartz.unit;
  }

  @override
  Future<dartz.Unit> createClickupTagInSpace(
      {required CreateTagInSpaceParams params}) async {
    Uri uri = Uri.parse("$clickupUrl/space/${params.space.id}/tag");
    await network.post(
      uri: uri,
      headers: clickupHeader(clickupAccessToken: params.accessToken),
      body: {"tag" : (params.newTag).toJson()}
    );
    return dartz.unit;
  }

  @override
  Future<dartz.Unit> deleteClickupTag({required DeleteTagParams params}) async{
    Uri uri = Uri.parse(
        "$clickupUrl/space/${params.space.id}/tag/${params.tag.name}");
    await network.delete(
      uri: uri,
      headers: clickupHeader(clickupAccessToken: params.clickupAccessToken,),
      body: json.encode((params.tag as ClickupTagModel).toJson())
    );
    return dartz.unit;
  }

  @override
  Future<dartz.Unit> updateClickupTag(
      {required UpdateTagParams params}) async {
    Uri uri = Uri.parse(
        "$clickupUrl/space/${params.space.id}/tag/${params.originalTagName}");
    await network.put(
        uri: uri,
        headers: clickupHeader(clickupAccessToken: params.clickupAccessToken,),
        body: {"tag" : (params.newTag).toJsonUpdate()}
    );
    return dartz.unit;
  }
}
