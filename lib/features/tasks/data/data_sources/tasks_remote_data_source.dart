import 'package:thetimeblockingapp/features/tasks/data/models/clickup_task_model.dart';

import '../../../../core/network/clickup_header.dart';
import '../../../../core/network/network.dart';
import '../../domain/use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';

abstract class TasksRemoteDataSource {
  Future<List<ClickupTaskModel>> getTasksInWorkspace(
      {required GetClickUpTasksInWorkspaceParams params});
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
    url += params.filtersParams.toUrlString;
    final response = await network.get(
        url: url,
        headers: clickUpHeader(
            clickUpAccessToken: params.filtersParams.clickUpAccessToken));
    if (response.body is List) {
      for (var element in (response.body as List)) {
        result.add(ClickupTaskModel.fromJson(element));
      }
    }
    return result;
  }
}
