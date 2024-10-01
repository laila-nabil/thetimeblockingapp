import 'dart:convert';

import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/common/entities/access_token.dart';
import 'package:thetimeblockingapp/core/network/network.dart';
import 'package:thetimeblockingapp/core/network/supabase_header.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/sign_up_use_case.dart';
import '../../../../common/models/access_token_model.dart';
import '../../../../core/response_interceptor.dart';
import '../models/sign_in_result_model.dart';
import '../models/sign_up_result_model.dart';
import 'auth_local_data_source.dart';

abstract class AuthRemoteDataSource {

  Future<SignInResultModel> signInSupabase({required SignInParams params});

  Future<dartz.Unit> signOut();

  Future<SignUpResultModel> signUpSupabase({required SignUpParams params});

  Future<SignInResultModel> refreshToken(
      {required String refreshToken, required AccessToken accessToken});
}

class SupabaseAuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final String url;
  final String key;
  final Network network;
  final AccessTokenModel accessTokenModel;
  final ResponseInterceptorFunc responseInterceptor;
  final AuthLocalDataSource authLocalDataSource;

  SupabaseAuthRemoteDataSourceImpl(
      {required this.network,
      required this.url,
      required this.key,
      required this.accessTokenModel,
      required this.responseInterceptor,
      required this.authLocalDataSource,
      });

  @override
  Future<SignInResultModel> signInSupabase(
      {required SignInParams params}) async {
    final result = await network.post(
        headers: supabaseHeader(
            accessToken: const AccessTokenModel(accessToken: "", tokenType: ""),
            apiKey: key),
        uri: Uri.parse("$url/auth/v1/token?grant_type=password"),
        body: {"email": params.email, "password": params.password});
    return SignInResultModel.fromJson(json.decode(result.body));
  }

  @override
  Future<dartz.Unit> signOut() async{
    NetworkResponse result = await responseInterceptor(
        authLocalDataSource:authLocalDataSource,
        authRemoteDataSource: this,
        request: (accessToken) => network.post(
        headers: supabaseHeader(
            accessToken: accessToken,
            apiKey: key),
        uri: Uri.parse("$url/auth/v1/logout"),));
    printDebug("logout api result $result");
    return dartz.unit;
  }

  @override
  Future<SignUpResultModel> signUpSupabase({required SignUpParams params}) async {
    final result = await network.post(
        headers: supabaseHeader(
            accessToken: const AccessTokenModel(accessToken: "", tokenType: ""),
            apiKey: key),
        uri: Uri.parse("$url/auth/v1/signup"),
        body: {"email": params.email, "password": params.password});
    return SignUpResultModel.fromJson(json.decode(result.body));
  }

  @override
  Future<SignInResultModel> refreshToken(
      {required String refreshToken, required AccessToken accessToken}) async{
    final result = await network.post(
        headers: supabaseHeader(
            accessToken: accessTokenModel,
            apiKey: key),
        uri: Uri.parse("$url/auth/v1/token?grant_type=refresh_token"),
        body: {"refresh_token": refreshToken});
    return SignInResultModel.fromJson(json.decode(result.body));
  }
}
