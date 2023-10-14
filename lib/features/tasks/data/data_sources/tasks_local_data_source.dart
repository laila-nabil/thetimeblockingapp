import 'package:thetimeblockingapp/common/models/clickup_workspace_model.dart';
import 'package:thetimeblockingapp/core/local_data_sources/local_data_source.dart';
import 'dart:convert';

abstract class TasksLocalDataSource {

  Future<List<ClickupWorkspaceModel>> getClickupWorkspaces();

  Future<void> saveClickupWorkspaces(
      List<ClickupWorkspaceModel> clickupWorkspacesModel);
}

class TasksLocalDataSourceImpl implements TasksLocalDataSource {
  final LocalDataSource localDataSource;

  TasksLocalDataSourceImpl(this.localDataSource);


  @override
  Future<List<ClickupWorkspaceModel>> getClickupWorkspaces() async {
    List<ClickupWorkspaceModel> result = [];
    final response = await localDataSource.getData(
        key: LocalDataSourceKeys.clickupWorkspaces.name);
    final responseList = json.decode(response ?? "");
    if (responseList is List) {
      for (var element in responseList) {
        result.add(ClickupWorkspaceModel.fromJson(element));
      }
    }
    return result;
  }


  @override
  Future<void> saveClickupWorkspaces(
      List<ClickupWorkspaceModel> clickupWorkspacesModel) {
    List<Map<String, dynamic>> result = [];
    for (var element in clickupWorkspacesModel) {
      result.add(element.toJson());
    }
    return localDataSource.setData(
        key: LocalDataSourceKeys.clickupWorkspaces.name,
        value: result);
  }
}
