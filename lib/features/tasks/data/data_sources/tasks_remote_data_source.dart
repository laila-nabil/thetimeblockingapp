import 'dart:convert';
import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/common/models/supabase_tag_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_task_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_workspace_model.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';

import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folder_in_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folderless_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_folder_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_task_use_case.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/get_all_in_workspace_use_case.dart';

import '../../../../core/network/network.dart';
import '../../../../core/network/supabase_header.dart';
import '../../../../core/response_interceptor.dart';
import '../../../auth/data/data_sources/auth_local_data_source.dart';
import '../../../auth/data/data_sources/auth_remote_data_source.dart';
import '../../domain/entities/task_parameters.dart';
import '../../domain/use_cases/create_list_in_folder_use_case.dart';
import '../../domain/use_cases/add_tag_to_task_use_case.dart';
import '../../domain/use_cases/create_tag_in_workspace_use_case.dart';
import '../../domain/use_cases/delete_tag_use_case.dart';
import '../../domain/use_cases/get_tags_in_workspace_use_case.dart';
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

  Future<List<TagModel>> getTags({required GetTagsInWorkspaceParams params});

  Future<dartz.Unit> removeTagFromTask(
      {required RemoveTagFromTaskParams params});

  Future<dartz.Unit> addTagToTask({required AddTagToTaskParams params});

  Future<dartz.Unit> createFolderlessList(
      {required CreateFolderlessListParams params});

  Future<dartz.Unit> createFolderInWorkspace(
      {required CreateFolderInSpaceParams params});

  Future<dartz.Unit> deleteList({required DeleteListParams params});

  Future<dartz.Unit> deleteFolder({required DeleteFolderParams params});

  Future<dartz.Unit> createTagInWorkspace(
      {required CreateTagInWorkspaceParams params});

  Future<dartz.Unit> updateTag({required UpdateTagParams params});

  Future<dartz.Unit> deleteTag({required DeleteTagParams params});

  Future<WorkspaceModel> getAllInWorkspace(
      {required GetAllInWorkspaceParams params});
}

class SupabaseTasksRemoteDataSourceImpl implements TasksRemoteDataSource {
  final String url;
  final String key;
  final Network network;

  final ResponseInterceptorFunc responseInterceptor;
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;
  SupabaseTasksRemoteDataSourceImpl({
    required this.url,
    required this.key,
    required this.network,

    required this.responseInterceptor,
    required this.authRemoteDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<dartz.Unit> addTagToTask({required AddTagToTaskParams params}) async {
    NetworkResponse result = await responseInterceptor(
        authRemoteDataSource: authRemoteDataSource,
        authLocalDataSource: authLocalDataSource,
        request: (accessToken) => network.post(
            uri: Uri.parse("$url/rest/v1/tagged_task"),
            body: params.toJson(),
            headers: supabaseHeader(accessToken: accessToken, apiKey: key)));
    printDebug("Result $result");
    return dartz.unit;
  }

  @override
  Future<dartz.Unit> createFolderInWorkspace(
      {required CreateFolderInSpaceParams params}) async {
    NetworkResponse result = await responseInterceptor(
        authRemoteDataSource: authRemoteDataSource,
        authLocalDataSource: authLocalDataSource,
        request: (accessToken) => network.post(
            uri: Uri.parse("$url/rest/v1/folder"),
            body: params.toJson(),
            headers: supabaseHeader(accessToken: accessToken, apiKey: key)));
    printDebug("Result $result");
    return dartz.unit;
  }

  @override
  Future<dartz.Unit> createFolderlessList(
      {required CreateFolderlessListParams params}) async {
    NetworkResponse result = await responseInterceptor(
        authRemoteDataSource: authRemoteDataSource,
        authLocalDataSource: authLocalDataSource,
        request: (accessToken) => network.post(
            uri: Uri.parse("$url/rest/v1/list"),
            body: params.toJson(),
            headers: supabaseHeader(accessToken: accessToken, apiKey: key)));
    printDebug("Result $result");
    return dartz.unit;
  }

  @override
  Future<dartz.Unit> createListInFolder(
      {required CreateListInFolderParams params}) async {
    NetworkResponse result = await responseInterceptor(
        authRemoteDataSource: authRemoteDataSource,
        authLocalDataSource: authLocalDataSource,
        request: (accessToken) => network.post(
            uri: Uri.parse("$url/rest/v1/list"),
            body: params.toJson(),
            headers: supabaseHeader(accessToken: accessToken, apiKey: key)));
    printDebug("Result $result");
    return dartz.unit;
  }

  @override
  Future<dartz.Unit> createTagInWorkspace(
      {required CreateTagInWorkspaceParams params}) async {
    NetworkResponse result = await responseInterceptor(
        authRemoteDataSource: authRemoteDataSource,
        authLocalDataSource: authLocalDataSource,
        request: (accessToken) => network.post(
            uri: Uri.parse("$url/rest/v1/tag"),
            body: params.toJson(),
            headers: supabaseHeader(accessToken: accessToken, apiKey: key)));
    printDebug("Result $result");
    return dartz.unit;
  }

  @override
  Future<dartz.Unit> createTaskInList(
      {required CreateTaskParams params}) async {
    NetworkResponse result = await responseInterceptor(
        authRemoteDataSource: authRemoteDataSource,
        authLocalDataSource: authLocalDataSource,
        request: (accessToken) => network.post(
            uri: Uri.parse("$url/rest/v1/task"),
            body: params.toJson(),
            headers: supabaseHeader(accessToken: accessToken, apiKey: key)));
    printDebug("Result $result");
    return dartz.unit;
  }

  @override
  Future<dartz.Unit> deleteFolder({required DeleteFolderParams params}) async {
   await responseInterceptor(
        authRemoteDataSource: authRemoteDataSource,
        authLocalDataSource: authLocalDataSource,
        request: (accessToken) => network.delete(
            uri: Uri.parse("$url/rest/v1/folder?id=eq.${params.folderId}"),
            headers: supabaseHeader(accessToken: accessToken, apiKey: key)));
    return dartz.unit;
  }

  @override
  Future<dartz.Unit> deleteList({required DeleteListParams params}) async {
   await responseInterceptor(
        authRemoteDataSource: authRemoteDataSource,
        authLocalDataSource: authLocalDataSource,
        request: (accessToken) => network.delete(
            uri: Uri.parse("$url/rest/v1/list?id=eq.${params.listId}"),
            headers: supabaseHeader(accessToken: accessToken, apiKey: key)));
    return dartz.unit;
  }

  @override
  Future<dartz.Unit> deleteTag({required DeleteTagParams params}) async {
     await responseInterceptor(
        authRemoteDataSource: authRemoteDataSource,
        authLocalDataSource: authLocalDataSource,
        request: (accessToken) => network.delete(
            uri: Uri.parse("$url/rest/v1/tag?id=eq.${params.tag.id}"),
            headers: supabaseHeader(accessToken: accessToken, apiKey: key)));
    return dartz.unit;
  }

  @override
  Future<dartz.Unit> deleteTask({required DeleteTaskParams params}) async {
    await responseInterceptor(
        authRemoteDataSource: authRemoteDataSource,
        authLocalDataSource: authLocalDataSource,
        request: (accessToken) => network.delete(
            uri: Uri.parse("$url/rest/v1/task?id=eq.${params.task.id}"),
            headers: supabaseHeader(accessToken: accessToken, apiKey: key)));
    return dartz.unit;
  }

  @override
  Future<List<TagModel>> getTags(
      {required GetTagsInWorkspaceParams params}) async {
    NetworkResponse response = await responseInterceptor(
        authRemoteDataSource: authRemoteDataSource,
        authLocalDataSource: authLocalDataSource,
        request: (accessToken) => network.get(
            uri: Uri.parse(
                "$url/rest/v1/tag?workspace_id=eq.${params.workspace.id}"),
            headers: supabaseHeader(accessToken: accessToken, apiKey: key)));
    return tagsFromJson(json.decode(response.body)) ?? [];
  }

  @override
  Future<List<TaskModel>> getTasksInWorkspace(
      {required GetTasksInWorkspaceParams params}) async {
    NetworkResponse response = await responseInterceptor(
        authRemoteDataSource: authRemoteDataSource,
        authLocalDataSource: authLocalDataSource,
        request: (accessToken) => network.get(
            uri: Uri.parse(
                "$url/rest/v1/tasks_json?workspace_id=eq.${params.workspaceId}${params.filtersParams.toString()}"),
            headers: supabaseHeader(accessToken: accessToken, apiKey: key)));
    return tasksFromJson(json.decode(response.body)) ?? [];
  }

  @override
  Future<dartz.Unit> removeTagFromTask(
      {required RemoveTagFromTaskParams params}) async {
    NetworkResponse result = await responseInterceptor(
        authRemoteDataSource: authRemoteDataSource,
        authLocalDataSource: authLocalDataSource,
        request: (accessToken) => network.delete(
            uri: Uri.parse(
                "$url/rest/v1/tagged_task?tag_id=eq.${params.tag.id}&task_id=eq.${params.task.id}"),
            headers: supabaseHeader(accessToken: accessToken, apiKey: key)));
    printDebug("Result $result");
    return dartz.unit;
  }

  @override
  Future<dartz.Unit> updateTag({required UpdateTagParams params}) async {
    NetworkResponse result = await responseInterceptor(
        authRemoteDataSource: authRemoteDataSource,
        authLocalDataSource: authLocalDataSource,
        request: (accessToken) => network.patch(
            uri: Uri.parse("$url/rest/v1/tag?id=eq.${params.newTag.id}"),
            body: params.toJson(),
            headers: supabaseHeader(accessToken: accessToken, apiKey: key)));
    printDebug("Result $result");
    return dartz.unit;
  }

  @override
  Future<dartz.Unit> updateTask({required CreateTaskParams params}) async {
    NetworkResponse result = await responseInterceptor(
        authRemoteDataSource: authRemoteDataSource,
        authLocalDataSource: authLocalDataSource,
        request: (accessToken) => network.patch(
            uri: Uri.parse("$url/rest/v1/task?id=eq.${params.task?.id}"),
            body: params.toJson(),
            headers: supabaseHeader(accessToken: accessToken, apiKey: key)));
    printDebug("Result $result");
    return dartz.unit;
  }

  @override
  Future<WorkspaceModel> getAllInWorkspace(
      {required GetAllInWorkspaceParams params}) async {
    NetworkResponse response = await responseInterceptor(
        authRemoteDataSource: authRemoteDataSource,
        authLocalDataSource: authLocalDataSource,
        request: (accessToken) => network.get(
            uri: Uri.parse(
                "$url/rest/v1/all_data?workspace_id=eq.${params.workspace.id}"),
            headers: supabaseHeader(accessToken: accessToken, apiKey: key)));
    return WorkspaceModel.fromJson(json.decode(response.body)[0]);
  }
}
