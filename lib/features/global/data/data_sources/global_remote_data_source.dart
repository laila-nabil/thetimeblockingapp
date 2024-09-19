import 'dart:convert';

import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/common/entities/access_token.dart';
import 'package:thetimeblockingapp/common/models/access_token_model.dart';
import 'package:thetimeblockingapp/common/models/priority_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_status_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_task_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_workspace_model.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/create_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/get_priorities_use_case.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/get_statuses_use_case.dart';

import 'package:thetimeblockingapp/features/global/domain/use_cases/get_all_in_workspace_use_case.dart';

import '../../../../core/network/network.dart';
import '../../../../core/network/supabase_header.dart';
import '../../../../core/print_debug.dart';
import '../../../tasks/domain/use_cases/get_tasks_in_single_workspace_use_case.dart';
import '../../domain/use_cases/get_workspaces_use_case.dart';

abstract class GlobalRemoteDataSource {
  Future<List<TaskModel>> getTasksInWorkspace(
      {required GetTasksInWorkspaceParams params});


  Future<List<WorkspaceModel>> getWorkspaces(
      {required GetWorkspacesParams params});

  Future<WorkspaceModel> getAllInWorkspace({required GetAllInWorkspaceParams params});

  Future<List<TaskStatusModel>> getStatuses(GetStatusesParams params);

  Future<List<TaskPriorityModel>> getPriorities(GetPrioritiesParams params);

  Future<dartz.Unit> createWorkspace({required CreateWorkspaceParams params});
}

class SupabaseGlobalRemoteDataSourceImpl implements GlobalRemoteDataSource {
  final String url;
  final String key;
  final Network network;

  final AccessTokenModel accessTokenModel;
  SupabaseGlobalRemoteDataSourceImpl({
    required this.url,
    required this.key,
    required this.network,required this.accessTokenModel, });



  @override
  Future<List<WorkspaceModel>> getWorkspaces(
      {required GetWorkspacesParams params}) async {
    List<WorkspaceModel> result = [];
    final response = await network.get(
        uri: Uri.parse(
            "$url/rest/v1/workspace?user_id=eq.${params.userId}&order=id"),
        headers: supabaseHeader(accessToken: accessTokenModel, apiKey: key));
    for (var element in (json.decode(response.body) as List)) {
      result.add(WorkspaceModel.fromJson(element));
    }
    return result;
  }

  @override
  Future<List<TaskModel>> getTasksInWorkspace(
      {required GetTasksInWorkspaceParams params})  async {
    final response = await network.get(
        uri: Uri.parse(
            "$url/rest/v1/tasks_json?workspace_id=eq.${params.workspaceId}"),
        headers: supabaseHeader(accessToken: accessTokenModel, apiKey: key));
    return tasksFromJson(json.decode(response.body)) ?? [];
  }



  @override
  Future<WorkspaceModel> getAllInWorkspace(
      {required GetAllInWorkspaceParams params}) async {
    final response = await network.get(
        uri: Uri.parse(
            "$url/rest/v1/all_data?workspace_id=eq.${params.workspace.id}"),
        headers: supabaseHeader(accessToken: accessTokenModel, apiKey: key));
    return WorkspaceModel.fromJson(json.decode(response.body)[0]);
  }


  @override
  Future<List<TaskStatusModel>> getStatuses(GetStatusesParams params) async {
    final response = await network.get(
        uri: Uri.parse(
            "$url/rest/v1/status?order=id"),
        headers: supabaseHeader(accessToken: accessTokenModel, apiKey: key));
    return taskStatusModelFromJson(json.decode(response.body)) ?? [];
  }

  @override
  Future<List<TaskPriorityModel>> getPriorities(GetPrioritiesParams params) async {
    final response = await network.get(
        uri: Uri.parse(
            "$url/rest/v1/priority?order=id"),
        headers: supabaseHeader(accessToken: accessTokenModel, apiKey: key));
    return taskPriorityModelFromJson(json.decode(response.body)) ?? [];
  }

  @override
  Future<dartz.Unit> createWorkspace(
      {required CreateWorkspaceParams params}) async {
    final result = await network.post(
        uri: Uri.parse("$url/rest/v1/workspace"),
        body: params.toJson(),
        headers: supabaseHeader(accessToken: accessTokenModel, apiKey: key));
    printDebug("Result $result");
    return dartz.unit;
  }
}
