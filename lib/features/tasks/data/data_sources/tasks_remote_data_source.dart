import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/features/tasks/data/models/clickup_task_model.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_task_use_case.dart';

import '../../../../core/network/clickup_header.dart';
import '../../../../core/network/network.dart';
import '../../domain/entities/task_parameters.dart';
import '../../domain/use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';

abstract class TasksRemoteDataSource {
  Future<List<ClickupTaskModel>> getTasksInWorkspace(
      {required GetClickUpTasksInWorkspaceParams params});

  Future<ClickupTaskModel> createTaskInList(
      {required ClickUpTaskParams params});

  Future<ClickupTaskModel> updateTask(
      {required ClickUpTaskParams params});

  Future<Unit> deleteTask(
      {required DeleteClickUpTaskParams params});
}

class TasksRemoteDataSourceImpl implements TasksRemoteDataSource {
  final Network network;
  final String clickUpClientId;
  final String clickUpClientSecret;
  final String clickUpUrl;

  TasksRemoteDataSourceImpl({
    required this.network,
    required this.clickUpClientId,
    required this.clickUpClientSecret,
    required this.clickUpUrl,
  });

  @override
  Future<List<ClickupTaskModel>> getTasksInWorkspace(
      {required GetClickUpTasksInWorkspaceParams params}) async {
    List<ClickupTaskModel> result = [];
    String url = "$clickUpUrl/team/${params.workspaceId}/task";
    final response = await network.get(
        uri: Uri(path:url,queryParameters: params.filtersParams.query),
        headers: clickUpHeader(
            clickUpAccessToken: params.filtersParams.clickUpAccessToken));
    for (var element in (json.decode(response.body)["tasks"] as List)) {
      result.add(ClickupTaskModel.fromJson(element));
    }
    return result;
  }

  @override
  Future<ClickupTaskModel> createTaskInList(
      {required ClickUpTaskParams params}) async {
    Uri uri = Uri.parse("$clickUpUrl/list/${params.listId}/task");
    final response = await network.post(
        uri: uri,
        headers: clickUpHeader(clickUpAccessToken: params.clickUpAccessToken),
        body: params.toJson());
    return ClickupTaskModel.fromJson(json.decode(response.body));
  }

  @override
  Future<ClickupTaskModel> updateTask(
      {required ClickUpTaskParams params}) async {
    Uri uri = Uri.parse("$clickUpUrl/task/${params.taskId}");
    final response = await network.put(
        uri: uri,
        headers: clickUpHeader(clickUpAccessToken: params.clickUpAccessToken),
        body: params.toJson());
    return ClickupTaskModel.fromJson(json.decode(response.body));
  }

  @override
  Future<Unit> deleteTask({required DeleteClickUpTaskParams params}) async{
    Uri uri = Uri.parse("$clickUpUrl/task/${params.taskId}");
    await network.delete(
        uri: uri,
        headers: clickUpHeader(clickUpAccessToken: params.clickUpAccessToken),);
    return unit;
  }
}
