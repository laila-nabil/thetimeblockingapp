import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/tasks/data/models/clickup_task_model.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_task_use_case.dart';

import '../../../../core/extensions.dart';
import '../../../../core/network/clickup_header.dart';
import '../../../../core/network/network.dart';
import '../../domain/entities/task_parameters.dart';
import '../../domain/use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';

abstract class TasksRemoteDataSource {
  Future<List<ClickupTaskModel>> getTasksInWorkspace(
      {required GetClickupTasksInWorkspaceParams params});

  Future<ClickupTaskModel> createTaskInList(
      {required ClickupTaskParams params});

  Future<ClickupTaskModel> updateTask(
      {required ClickupTaskParams params});

  Future<Unit> deleteTask(
      {required DeleteClickupTaskParams params});
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
}
