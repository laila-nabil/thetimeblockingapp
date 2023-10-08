import 'package:thetimeblockingapp/common/models/clickup_user_model.dart';
import 'package:thetimeblockingapp/core/local_data_sources/local_data_source.dart';
import '../models/clickup_access_token_model.dart';
import 'dart:convert';

abstract class AuthLocalDataSource {
  Future<ClickUpAccessTokenModel> getClickUpAccessToken();

  Future<ClickupUserModel> getClickUpUser();


  Future<void> saveClickUpAccessToken(
      ClickUpAccessTokenModel clickUpAccessTokenModel);

  Future<void> saveClickUpUser(ClickupUserModel clickupUserModel);

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

}
