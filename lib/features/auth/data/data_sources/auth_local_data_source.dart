import 'package:thetimeblockingapp/common/models/clickup_user_model.dart';
import 'package:thetimeblockingapp/common/models/clickup_workspace_model.dart';
import 'package:thetimeblockingapp/core/local_data_sources/local_data_source.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import '../models/clickup_access_token_model.dart';
import 'dart:convert';

abstract class AuthLocalDataSource {
  Future<ClickUpAccessTokenModel> getClickUpAccessToken();

  Future<ClickupUserModel> getClickUpUser();

  Future<List<ClickupWorkspaceModel>> getClickUpWorkspaces();

  Future<void> saveClickUpAccessToken(
      ClickUpAccessTokenModel clickUpAccessTokenModel);

  Future<void> saveClickUpUser(ClickupUserModel clickupUserModel);

  Future<void> saveClickUpWorkspaces(
      List<ClickupWorkspaceModel> clickupWorkspacesModel);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final LocalDataSource localDataSource;

  AuthLocalDataSourceImpl(this.localDataSource);

  @override
  Future<ClickUpAccessTokenModel> getClickUpAccessToken() async {
    var data = await localDataSource.getData(
        key: LocalDataSourceKeys.clickUpAccessToken.name);
    return ClickUpAccessTokenModel.fromJson(json.decode(data ?? ""));
  }

  @override
  Future<ClickupUserModel> getClickUpUser() async {
    var data = await localDataSource.getData(
        key: LocalDataSourceKeys.clickUpUser.name);
    return ClickupUserModel.fromJson(json.decode(data.toString()));
  }

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
  Future<void> saveClickUpAccessToken(
      ClickUpAccessTokenModel clickUpAccessTokenModel) {
    return localDataSource.setData(
        key: LocalDataSourceKeys.clickUpAccessToken.name,
        value: clickUpAccessTokenModel.toJson());
  }

  @override
  Future<void> saveClickUpUser(ClickupUserModel clickupUserModel) {
    return localDataSource.setData(
        key: LocalDataSourceKeys.clickUpUser.name,
        value: clickupUserModel.toJson());
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
