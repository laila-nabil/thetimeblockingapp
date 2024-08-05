import 'package:thetimeblockingapp/common/models/clickup_user_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_user_model.dart';
import 'package:thetimeblockingapp/core/local_data_sources/local_data_source.dart';
import '../../../../common/models/access_token_model.dart';
import 'dart:convert';

abstract class AuthLocalDataSource {
  Future<AccessTokenModel> getAccessToken();

  Future<ClickupUserModel> getClickupUser();

  Future<SupabaseUserModel> getSupabaseUser();


  Future<void> saveAccessToken(
      AccessTokenModel clickupAccessTokenModel);

  Future<void> saveClickupUser(ClickupUserModel clickupUserModel);

  Future<void> saveSupabaseUser(SupabaseUserModel user);

  Future<void> signOut();

}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final LocalDataSource localDataSource;

  AuthLocalDataSourceImpl(this.localDataSource);

  @override
  Future<AccessTokenModel> getAccessToken() async {
    var data = await localDataSource.getData(
        key: LocalDataSourceKeys.accessToken.name);
    return AccessTokenModel.fromJson(json.decode(data ?? ""));
  }

  @override
  Future<ClickupUserModel> getClickupUser() async {
    var data = await localDataSource.getData(
        key: LocalDataSourceKeys.clickupUser.name);
    return ClickupUserModel.fromJson(json.decode(data.toString()));
  }


  @override
  Future<void> saveAccessToken(
      AccessTokenModel clickupAccessTokenModel) {
    return localDataSource.setData(
        key: LocalDataSourceKeys.accessToken.name,
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

  @override
  Future<SupabaseUserModel> getSupabaseUser() async {
    var data = await localDataSource.getData(
        key: LocalDataSourceKeys.supabaseUser.name);
    return SupabaseUserModel.fromJson(json.decode(data.toString()));
  }

  @override
  Future<void> saveSupabaseUser(SupabaseUserModel user) {
    return localDataSource.setData(
        key: LocalDataSourceKeys.supabaseUser.name,
        value: user.toJson());
  }

}
