import 'package:thetimeblockingapp/common/models/clickup_workspace_model.dart';
import 'package:thetimeblockingapp/core/local_data_sources/local_data_source.dart';
import 'dart:convert';

import '../models/clickup_space_model.dart';

abstract class TasksLocalDataSource {

  Future<List<ClickupWorkspaceModel>> getClickupWorkspaces();

  Future<void> saveClickupWorkspaces(
      List<ClickupWorkspaceModel> clickupWorkspacesModel);


  Future<void> saveSelectedWorkspace(
      ClickupWorkspaceModel clickupWorkspacesModel);

  Future<ClickupWorkspaceModel> getSelectedWorkspace();

  Future<void> saveSelectedSpace(
      ClickupSpaceModel clickupSpaceModel);

  Future<ClickupSpaceModel> getSelectedSpace();

  Future<void> saveSpaces(
      List<ClickupSpaceModel> spaces);

  Future<List<ClickupSpaceModel>> getSpaces();
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


  @override
  Future<void> saveSelectedWorkspace(
      ClickupWorkspaceModel clickupWorkspacesModel) {
    return localDataSource.setData(
        key: LocalDataSourceKeys.selectedWorkspace.name,
        value: clickupWorkspacesModel.toJson());
  }

  @override
  Future<ClickupWorkspaceModel> getSelectedWorkspace() async {
    final response = await localDataSource.getData(
        key: LocalDataSourceKeys.selectedWorkspace.name);
    return ClickupWorkspaceModel.fromJson(json.decode(response ?? ""));
  }

  @override
  Future<ClickupSpaceModel> getSelectedSpace() async {
    final response = await localDataSource.getData(
        key: LocalDataSourceKeys.selectedSpace.name);
    return ClickupSpaceModel.fromJson(json.decode(response ?? ""));
  }


  @override
  Future<void> saveSelectedSpace(ClickupSpaceModel clickupSpaceModel)  {
    return localDataSource.setData(
        key: LocalDataSourceKeys.selectedSpace.name,
        value: clickupSpaceModel.toJson());
  }

  @override
  Future<List<ClickupSpaceModel>> getSpaces() async {
    List<ClickupSpaceModel> result = [];
    final response = await localDataSource.getData(
        key: LocalDataSourceKeys.clickupSpaces.name);
    final responseList = json.decode(response ?? "");
    if (responseList is List) {
      for (var element in responseList) {
        result.add(ClickupSpaceModel.fromJson(element));
      }
    }
    return result;
  }

  @override
  Future<void> saveSpaces(List<ClickupSpaceModel> spaces) {
    List<Map<String, dynamic>> result = [];
    for (var element in spaces) {
      result.add(element.toJson());
    }
    return localDataSource.setData(
        key: LocalDataSourceKeys.clickupSpaces.name,
        value: result);
  }
}
