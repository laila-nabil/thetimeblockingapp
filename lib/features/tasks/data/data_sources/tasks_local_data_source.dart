
import 'package:thetimeblockingapp/common/models/supabase_space_model.dart';
import 'package:thetimeblockingapp/core/local_data_sources/local_data_source.dart';
import 'dart:convert';

import '../../../../common/models/supabase_workspace_model.dart';


abstract class TasksLocalDataSource {
  Future<List<WorkspaceModel>> getWorkspaces();

  Future<void> saveWorkspaces(
      List<WorkspaceModel> workspaceModels);

  Future<void> saveSelectedWorkspace(
      WorkspaceModel workspacesModel);

  Future<WorkspaceModel> getSelectedWorkspace();

  Future<void> saveSelectedSpace(SpaceModel spaceModel);

  Future<SpaceModel> getSelectedSpace();

  Future<void> saveSpaces(List<SpaceModel> spaces);

  Future<List<SpaceModel>> getSpaces();
}

class TasksLocalDataSourceImpl implements TasksLocalDataSource {
  final LocalDataSource localDataSource;

  TasksLocalDataSourceImpl(this.localDataSource);

  @override
  Future<List<WorkspaceModel>> getWorkspaces() async {
    List<WorkspaceModel> result = [];
    final response =
        await localDataSource.getData(key: LocalDataSourceKeys.workspaces.name);
    final responseList = json.decode(response ?? "");
    if (responseList is List) {
      for (var element in responseList) {
        result.add(WorkspaceModel.fromJson(element));
      }
    }
    return result;
  }


  @override
  Future<void> saveSelectedWorkspace(
      WorkspaceModel workspacesModel) {
    return localDataSource.setData(
        key: LocalDataSourceKeys.selectedWorkspace.name,
        value: workspacesModel.toJson());
  }

  @override
  Future<WorkspaceModel> getSelectedWorkspace() async {
    final response = await localDataSource.getData(
        key: LocalDataSourceKeys.selectedWorkspace.name);
    return WorkspaceModel.fromJson(json.decode(response ?? ""));
  }

  @override
  Future<SpaceModel> getSelectedSpace() async {
    final response = await localDataSource.getData(
        key: LocalDataSourceKeys.selectedSpace.name);
    return SpaceModel.fromJson(json.decode(response ?? ""));
  }

  @override
  Future<void> saveSelectedSpace(SpaceModel SpaceModel) {
    return localDataSource.setData(
        key: LocalDataSourceKeys.selectedSpace.name,
        value: SpaceModel.toJson());
  }

  @override
  Future<List<SpaceModel>> getSpaces() async {
    List<SpaceModel> result = [];
    final response =
        await localDataSource.getData(key: LocalDataSourceKeys.spaces.name);
    final responseList = json.decode(response ?? "");
    if (responseList is List) {
      for (var element in responseList) {
        result.add(SpaceModel.fromJson(element));
      }
    }
    return result;
  }

  @override
  Future<void> saveSpaces(List<SpaceModel> spaces) {
    List<Map<String, dynamic>> result = [];
    for (var element in spaces) {
      result.add(element.toJson());
    }
    return localDataSource.setData(
        key: LocalDataSourceKeys.spaces.name, value: result);
  }

  @override
  Future<void> saveWorkspaces(
      List<WorkspaceModel> supabaseWorkspaceModels) {
    List<Map<String, dynamic>> result = [];
    for (var element in supabaseWorkspaceModels) {
      result.add(element.toJson());
    }
    return localDataSource.setData(
        key: LocalDataSourceKeys.workspaces.name, value: result);
  }
}
