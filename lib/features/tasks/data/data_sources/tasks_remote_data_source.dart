import 'dart:convert';
import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/common/models/priority_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_folder_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_list_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_space_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_status_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_tag_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_task_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_workspace_model.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/get_priorities_use_case.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/get_statuses_use_case.dart';


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
import '../../../global/domain/use_cases/get_workspaces_use_case.dart';
import '../../domain/use_cases/remove_tag_from_task_use_case.dart';
import '../../domain/use_cases/update_tag_use_case.dart';

abstract class TasksRemoteDataSource {
  Future<List<TaskModel>> getTasksInWorkspace(
      {required GetTasksInWorkspaceParams params});

  Future<dartz.Unit> createTaskInList({required CreateTaskParams params});

  Future<TaskModel> updateTask({required CreateTaskParams params});

  Future<dartz.Unit> deleteTask({required DeleteTaskParams params});

  Future<ListModel> createListInFolder(
      {required CreateListInFolderParams params});

  Future<List<TagModel>> getTags({required GetTagsInSpaceParams params});

  Future<dartz.Unit> removeTagFromTask(
      {required RemoveTagFromTaskParams params});

  Future<dartz.Unit> addTagToTask({required AddTagToTaskParams params});

  Future<ListModel> createFolderlessList(
      {required CreateFolderlessListParams params});

  Future<FolderModel> createFolderInSpace(
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
  Future<dartz.Unit> addTagToTask({required AddTagToTaskParams params}) {
    // TODO A implement addTagToTask
    throw UnimplementedError();
  }

  @override
  Future<FolderModel> createFolderInSpace(
      {required CreateFolderInSpaceParams params}) {
    // TODO A implement createFolderInSpace
    throw UnimplementedError();
  }

  @override
  Future<ListModel> createFolderlessList(
      {required CreateFolderlessListParams params}) {
    // TODO A implement createFolderlessList
    throw UnimplementedError();
  }

  @override
  Future<ListModel> createListInFolder(
      {required CreateListInFolderParams params}) {
    // TODO A implement createListInFolder
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> createTagInSpace(
      {required CreateTagInSpaceParams params}) {
    // TODO A implement createTagInSpace
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> createTaskInList({required CreateTaskParams params}) async {
    final response = await network.post(
        uri: Uri.parse(
            "$url/rest/v1/task"),
        body: params.toJson(),
        headers: supabaseHeader(accessToken: params.accessToken, apiKey: key));
    return dartz.unit;
  }

  @override
  Future<dartz.Unit> deleteFolder({required DeleteFolderParams params}) {
    // TODO A implement deleteFolder
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> deleteList({required DeleteListParams params}) {
    // TODO A implement deleteList
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> deleteTag({required DeleteTagParams params}) {
    // TODO A implement deleteTag
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> deleteTask({required DeleteTaskParams params}) {
    // TODO A implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<List<TagModel>> getTags({required GetTagsInSpaceParams params}) {
    // TODO A implement getTags
    throw UnimplementedError();
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
      {required RemoveTagFromTaskParams params}) {
    // TODO A implement removeTagFromTask
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> updateTag({required UpdateTagParams params}) {
    // TODO A implement updateTag
    throw UnimplementedError();
  }

  @override
  Future<TaskModel> updateTask({required CreateTaskParams params}) {
    // TODO A implement updateTask
    throw UnimplementedError();
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
