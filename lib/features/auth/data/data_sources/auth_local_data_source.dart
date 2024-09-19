import 'package:thetimeblockingapp/common/models/supabase_user_model.dart';
import 'package:thetimeblockingapp/core/local_data_sources/local_data_source.dart';
import 'package:thetimeblockingapp/features/auth/data/models/sign_in_result_model.dart';
import '../../../../common/models/access_token_model.dart';
import 'dart:convert';

abstract class AuthLocalDataSource {
  Future<AccessTokenModel> _getAccessToken();

  Future<SupabaseUserModel> _getSupabaseUser();

  Future<String> _getRefreshToken();


  Future<void> _saveAccessToken(
      AccessTokenModel accessTokenModel);

  Future<void> _saveSupabaseUser(SupabaseUserModel user);

  Future<void> _saveRefreshToken(String refreshToken);

  Future<void> saveSignInResult(SignInResultModel signInResultModel);

  Future<SignInResultModel> getSignInResult();

  Future<void> signOut();

}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final LocalDataSource localDataSource;

  AuthLocalDataSourceImpl(this.localDataSource);

  @override
  Future<AccessTokenModel> _getAccessToken() async {
    var data = await localDataSource.getData(
        key: LocalDataSourceKeys.accessToken.name);
    return AccessTokenModel.fromJson(json.decode(data ?? ""));
  }



  @override
  Future<void> _saveAccessToken(
      AccessTokenModel accessTokenModel) {
    return localDataSource.setData(
        key: LocalDataSourceKeys.accessToken.name,
        value: accessTokenModel.toJson());
  }

  @override
  Future<void> signOut() async {
    for (var v in LocalDataSourceKeys.values) {
      await localDataSource.setData(key: v.name, value: '');
    }
  }

  @override
  Future<SupabaseUserModel> _getSupabaseUser() async {
    var data = await localDataSource.getData(
        key: LocalDataSourceKeys.supabaseUser.name);
    return SupabaseUserModel.fromJson(json.decode(data.toString()));
  }

  @override
  Future<void> _saveSupabaseUser(SupabaseUserModel user) {
    return localDataSource.setData(
        key: LocalDataSourceKeys.supabaseUser.name,
        value: user.toJson());
  }

  @override
  Future<String> _getRefreshToken()async {
    var data = await localDataSource.getData(
        key: LocalDataSourceKeys.refreshToken.name);
    return json.decode(data.toString());
  }

  @override
  Future<void> _saveRefreshToken(String refreshToken) {
    return localDataSource.setData(
        key: LocalDataSourceKeys.refreshToken.name,
        value: refreshToken);
  }

  @override
  Future<void> saveSignInResult(SignInResultModel signInResultModel) async{
    await _saveSupabaseUser(signInResultModel.user as SupabaseUserModel);
    await _saveAccessToken(signInResultModel.accessToken.toModel);
    await _saveRefreshToken(signInResultModel.refreshToken);
  }

  @override
  Future<SignInResultModel> getSignInResult()async {
    final access = await _getAccessToken();
    final user = await _getSupabaseUser();
    final refreshToken = await _getRefreshToken();
    return SignInResultModel(
        accessToken: access, user: user, refreshToken: refreshToken);
  }

}
