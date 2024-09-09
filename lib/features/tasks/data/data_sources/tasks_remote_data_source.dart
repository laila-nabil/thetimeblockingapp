import 'dart:convert';
import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/common/models/supabase_folder_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_list_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_tag_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_task_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_workspace_model.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';


import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folder_in_space_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folderless_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_folder_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_task_use_case.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/get_all_in_workspace_use_case.dart';

import '../../../../core/network/network.dart';
import '../../../../core/network/supabase_header.dart';
import '../../domain/entities/task_parameters.dart';
import '../../domain/use_cases/create_list_in_folder_use_case.dart';
import '../../domain/use_cases/add_tag_to_task_use_case.dart';
import '../../domain/use_cases/create_tag_in_space_use_case.dart';
import '../../domain/use_cases/delete_tag_use_case.dart';
import '../../domain/use_cases/get_tags_in_space_use_case.dart';
import '../../domain/use_cases/get_tasks_in_single_workspace_use_case.dart';
import '../../domain/use_cases/remove_tag_from_task_use_case.dart';
import '../../domain/use_cases/update_tag_use_case.dart';

abstract class TasksRemoteDataSource {
  Future<List<TaskModel>> getTasksInWorkspace(
      {required GetTasksInWorkspaceParams params});

  Future<dartz.Unit> createTaskInList({required CreateTaskParams params});

  Future<dartz.Unit> updateTask({required CreateTaskParams params});

  Future<dartz.Unit> deleteTask({required DeleteTaskParams params});

  Future<dartz.Unit> createListInFolder(
      {required CreateListInFolderParams params});

  Future<List<TagModel>> getTags({required GetTagsInSpaceParams params});

  Future<dartz.Unit> removeTagFromTask(
      {required RemoveTagFromTaskParams params});

  Future<dartz.Unit> addTagToTask({required AddTagToTaskParams params});

  Future<dartz.Unit> createFolderlessList(
      {required CreateFolderlessListParams params});

  Future<dartz.Unit> createFolderInSpace(
      {required CreateFolderInSpaceParams params});

  Future<dartz.Unit> deleteList({required DeleteListParams params});

  Future<dartz.Unit> deleteFolder({required DeleteFolderParams params});

  Future<dartz.Unit> createTagInSpace({required CreateTagInSpaceParams params});

  Future<dartz.Unit> updateTag({required UpdateTagParams params});

  Future<dartz.Unit> deleteTag({required DeleteTagParams params});

  Future<WorkspaceModel> getAllInWorkspace({required GetAllInWorkspaceParams params});

}

class SupabaseTasksRemoteDataSourceImpl implements TasksRemoteDataSource {
  final String url;
  final String key;
  final Network network;

  SupabaseTasksRemoteDataSourceImpl(
      {required this.url, required this.key, required this.network});


  @override
  Future<dartz.Unit> addTagToTask({required AddTagToTaskParams params}) async {
    final result = await network.post(
        uri: Uri.parse(
            "$url/rest/v1/tagged_task"),
        body: params.toJson(),
        headers: supabaseHeader(accessToken: params.accessToken, apiKey: key));
    printDebug("Result $result");
    return dartz.unit;
  }

  @override
  Future<dartz.Unit> createFolderInSpace(
      {required CreateFolderInSpaceParams params}) async {
    final result = await network.post(
        uri: Uri.parse(
            "$url/rest/v1/folder"),
        body: params.toJson(),
        headers: supabaseHeader(accessToken: params.accessToken, apiKey: key));
    printDebug("Result $result");
    return dartz.unit;
  }

  @override
  Future<dartz.Unit> createFolderlessList(
      {required CreateFolderlessListParams params}) async {
    final result = await network.post(
        uri: Uri.parse(
            "$url/rest/v1/list"),
        body: params.toJson(),
        headers: supabaseHeader(accessToken: params.accessToken, apiKey: key));
    printDebug("Result $result");
    return dartz.unit;
  }

  @override
  Future<dartz.Unit> createListInFolder(
      {required CreateListInFolderParams params}) async {
    final result = await network.post(
        uri: Uri.parse(
            "$url/rest/v1/list"),
        body: params.toJson(),
        headers: supabaseHeader(accessToken: params.accessToken, apiKey: key));
    printDebug("Result $result");
    return dartz.unit;
  }

  @override
  Future<dartz.Unit> createTagInSpace(
      {required CreateTagInSpaceParams params}) {
    // TODO A implement createTagInSpace
    throw UnimplementedError("createTagInSpace");
  }

  @override
  Future<dartz.Unit> createTaskInList({required CreateTaskParams params}) async {
    final result = await network.post(
        uri: Uri.parse(
            "$url/rest/v1/task"),
        body: params.toJson(),
        headers: supabaseHeader(accessToken: params.accessToken, apiKey: key));
    printDebug("Result $result");
    return dartz.unit;
  }

  @override
  Future<dartz.Unit> deleteFolder({required DeleteFolderParams params}) async {
    await network.delete(
        uri: Uri.parse(
            "$url/rest/v1/folder?id=eq.${params.folderId}"),
        headers: supabaseHeader(accessToken: params.accessToken, apiKey: key));
    return dartz.unit;
  }

  @override
  Future<dartz.Unit> deleteList({required DeleteListParams params}) async {
    await network.delete(
        uri: Uri.parse(
            "$url/rest/v1/list?id=eq.${params.listId}"),
        headers: supabaseHeader(accessToken: params.accessToken, apiKey: key));
    return dartz.unit;
  }

  @override
  Future<dartz.Unit> deleteTag({required DeleteTagParams params}) {
    // TODO A implement deleteTag
    throw UnimplementedError("deleteTag");
  }

  @override
  Future<dartz.Unit> deleteTask({required DeleteTaskParams params}) async {
    await network.delete(
        uri: Uri.parse(
            "$url/rest/v1/task?id=eq.${params.task.id}"),
        headers: supabaseHeader(accessToken: params.accessToken, apiKey: key));
    return dartz.unit;
  }

  @override
  Future<List<TagModel>> getTags({required GetTagsInSpaceParams params}) {
    // TODO A implement getTags
    throw UnimplementedError("getTags");
  }

  @override
  Future<List<TaskModel>> getTasksInWorkspace(
      {required GetTasksInWorkspaceParams params})  async {
    final response = await network.get(
        uri: Uri.parse(
            "$url/rest/v1/tasks_json?workspace_id=eq.${params.workspaceId}"),
        headers: supabaseHeader(accessToken: params.filtersParams.accessToken, apiKey: key));
    return tasksFromJson(json.decode(response.body)) ?? [];
  }

  @override
  Future<dartz.Unit> removeTagFromTask(
      {required RemoveTagFromTaskParams params}) async{
    final result = await network.delete(
        uri: Uri.parse(
            "$url/rest/v1/tagged_task?tag_id=eq.${params.tag.id}&task_id=eq.${params.task.id}"),
        headers: supabaseHeader(accessToken: params.accessToken, apiKey: key));
    printDebug("Result $result");
    return dartz.unit;
  }

  @override
  Future<dartz.Unit> updateTag({required UpdateTagParams params}) {
    // TODO A implement updateTag
    throw UnimplementedError("updateTag");
  }

  @override
  Future<dartz.Unit> updateTask({required CreateTaskParams params}) async {
    final result = await network.patch(
        uri: Uri.parse(
            "$url/rest/v1/task?id=eq.${params.task?.id}"),
        body: params.toJson(),
        headers: supabaseHeader(accessToken: params.accessToken, apiKey: key));
    printDebug("Result $result");
    return dartz.unit;
  }

  @override
  Future<WorkspaceModel> getAllInWorkspace(
      {required GetAllInWorkspaceParams params}) async {
    final response = await network.get(
        uri: Uri.parse(
            "$url/rest/v1/all_data?workspace_id=eq.${params.workspace.id}"),
        headers: supabaseHeader(accessToken: params.accessToken, apiKey: key));
    return WorkspaceModel.fromJson(json.decode(response.body)[0]);
  }

}
