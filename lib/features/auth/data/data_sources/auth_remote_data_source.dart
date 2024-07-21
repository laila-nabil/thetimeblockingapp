import 'dart:convert';

import 'package:thetimeblockingapp/common/models/clickup_user_model.dart';
import 'package:thetimeblockingapp/core/network/network.dart';
import 'package:thetimeblockingapp/core/network/supabase_header.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/sign_in_use_case.dart';
import '../../../../core/network/clickup_header.dart';
import '../../domain/use_cases/get_access_token_use_case.dart';
import '../../domain/use_cases/get_user_use_case.dart';
import '../models/access_token_model.dart';

abstract class AuthRemoteDataSource {
  Future<AccessTokenModel> getAccessToken(
      {required GetAccessTokenParams params});

  Future<ClickupUserModel> getClickupUser(
      {required GetClickupUserParams params});

  Future<AccessTokenModel> signInSupabase({required SignInParams params});
}

class ClickupAuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Network network;
  final String clickupClientId;
  final String clickupClientSecret;
  final String clickupUrl;

  ClickupAuthRemoteDataSourceImpl({
    required this.network,
    required this.clickupClientId,
    required this.clickupClientSecret,
    required this.clickupUrl,
  });

  @override
  Future<AccessTokenModel> getAccessToken(
      {required GetAccessTokenParams params}) async {
    printDebug("params.code ${params.code}");
    final result = await network.post(
        uri: Uri.parse(
            "https://corsproxy.io/?https://api.clickup.com/api/v2/oauth/token?client_id=$clickupClientId&client_secret=$clickupClientSecret&code=${params.code}"));
    return AccessTokenModel.fromJson(json.decode(result.body));
  }

  @override
  Future<ClickupUserModel> getClickupUser(
      {required GetClickupUserParams params}) async {
    final result = await network.get(
        uri: Uri.parse("$clickupUrl/user"),
        headers: clickupHeader(clickupAccessToken: params.clickupAccessToken));
    return ClickupUserModel.fromJson(json.decode(result.body)["user"]);
  }

  @override
  Future<AccessTokenModel> signInSupabase({required SignInParams params}) {
    throw UnsupportedError('Sign in Supabase not supported for Clickup');
  }
}

class SupabaseAuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final String url;
  final String key;
  final Network network;

  SupabaseAuthRemoteDataSourceImpl(
      {required this.network, required this.url, required this.key});

  @override
  Future<AccessTokenModel> getAccessToken(
      {required GetAccessTokenParams params}) {
    throw UnsupportedError('Get access token is replaced with sign in for Supabase');
  }

  @override
  Future<ClickupUserModel> getClickupUser(
      {required GetClickupUserParams params}) {
    throw UnsupportedError('Get Clickup user is not supported for Supabase');
  }

  @override
  Future<AccessTokenModel> signInSupabase({required SignInParams params}) async {
    final result = await network.post(
        headers: supabaseHeader(accessToken: params.accessToken, apiKey: key),
        uri: Uri.parse("$url/auth/v1/token?grant_type=password"),
        body: {"email": params.email, "password": params.password});
    return AccessTokenModel.fromJson(json.decode(result.body));
  }
}
