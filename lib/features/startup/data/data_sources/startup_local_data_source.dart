import 'package:thetimeblockingapp/common/models/clickup_workspace_model.dart';
import 'package:thetimeblockingapp/core/local_data_sources/local_data_source.dart';
import 'dart:convert';

abstract class StartUpLocalDataSource {

  Future<List<ClickupWorkspaceModel>> getClickUpWorkspaces();

  Future<void> saveClickUpWorkspaces(
      List<ClickupWorkspaceModel> clickupWorkspacesModel);
}

class StartUpLocalDataSourceImpl implements StartUpLocalDataSource {
  final LocalDataSource localDataSource;

  StartUpLocalDataSourceImpl(this.localDataSource);


  @override
  Future<List<ClickupWorkspaceModel>> getClickUpWorkspaces() async {
    List<ClickupWorkspaceModel> result = [];
    final response = await localDataSource.getData(
        key: LocalDataSourceKeys.clickUpWorkspaces.name);
    final responseList = json.decode(response ?? "");
    if (responseList is List) {
      for (var element in responseList) {
        result.add(ClickupWorkspaceModel.fromJson(element));
      }
    }
    return result;
  }


  @override
  Future<void> saveClickUpWorkspaces(
      List<ClickupWorkspaceModel> clickupWorkspacesModel) {
    List<Map<String, dynamic>> result = [];
    for (var element in clickupWorkspacesModel) {
      result.add(element.toJson());
    }
    return localDataSource.setData(
        key: LocalDataSourceKeys.clickUpWorkspaces.name,
        value: result);
  }
}
