import 'package:thetimeblockingapp/common/models/clickup_user_model.dart';
import 'package:thetimeblockingapp/common/models/clickup_workspace_model.dart';
import 'package:thetimeblockingapp/core/local_data_sources/local_data_source.dart';
import '../models/clickup_access_token_model.dart';

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
    return ClickUpAccessTokenModel.fromJson((await localDataSource.getData(
        key: LocalDataSourceKeys.clickUpAccessToken.name) as Map<String, dynamic>));
  }

  @override
  Future<ClickupUserModel> getClickUpUser() async {
    return ClickupUserModel.fromJson(await localDataSource.getData(
        key: LocalDataSourceKeys.clickUpUser.name)as Map<String, dynamic>);
  }

  @override
  Future<List<ClickupWorkspaceModel>> getClickUpWorkspaces() async {
    List<ClickupWorkspaceModel> result = [];
    final response = await localDataSource.getData(
        key: LocalDataSourceKeys.clickUpWorkspaces.name);
    if (response is List) {
      for (var element in response) {
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
