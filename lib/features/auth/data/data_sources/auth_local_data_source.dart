import 'package:thetimeblockingapp/common/models/clickup_user_model.dart';
import 'package:thetimeblockingapp/core/local_data_sources/local_data_source.dart';
import '../models/access_token_model.dart';
import 'dart:convert';

abstract class AuthLocalDataSource {
  Future<AccessTokenModel> getClickupAccessToken();

  Future<ClickupUserModel> getClickupUser();


  Future<void> saveClickupAccessToken(
      AccessTokenModel clickupAccessTokenModel);

  Future<void> saveClickupUser(ClickupUserModel clickupUserModel);

  Future<void> signOut();

}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final LocalDataSource localDataSource;

  AuthLocalDataSourceImpl(this.localDataSource);

  @override
  Future<AccessTokenModel> getClickupAccessToken() async {
    var data = await localDataSource.getData(
        key: LocalDataSourceKeys.clickupAccessToken.name);
    return AccessTokenModel.fromJson(json.decode(data ?? ""));
  }

  @override
  Future<ClickupUserModel> getClickupUser() async {
    var data = await localDataSource.getData(
        key: LocalDataSourceKeys.clickupUser.name);
    return ClickupUserModel.fromJson(json.decode(data.toString()));
  }


  @override
  Future<void> saveClickupAccessToken(
      AccessTokenModel clickupAccessTokenModel) {
    return localDataSource.setData(
        key: LocalDataSourceKeys.clickupAccessToken.name,
        value: clickupAccessTokenModel.toJson());
  }

  @override
  Future<void> saveClickupUser(ClickupUserModel clickupUserModel) {
    return localDataSource.setData(
        key: LocalDataSourceKeys.clickupUser.name,
        value: clickupUserModel.toJson());
  }

  @override
  Future<void> signOut() async {
    await localDataSource.clear();
  }

}
