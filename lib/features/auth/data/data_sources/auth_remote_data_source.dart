import 'dart:convert';

import 'package:thetimeblockingapp/common/models/clickup_user_model.dart';
import 'package:thetimeblockingapp/core/network/network.dart';
import '../../../../core/network/clickup_header.dart';
import '../../domain/use_cases/get_clickup_access_token_use_case.dart';
import '../../domain/use_cases/get_clickup_user_use_case.dart';
import '../models/clickup_access_token_model.dart';

abstract class AuthRemoteDataSource {
  Future<ClickUpAccessTokenModel> getClickUpAccessToken(
      {required GetClickUpAccessTokenParams params});

  Future<ClickupUserModel> getClickUpUser({required GetClickUpUserParams params});

}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Network network;
  final String clickUpClientId;
  final String clickUpClientSecret;
  final String clickUpUrl;

  AuthRemoteDataSourceImpl({
    required this.network,
    required this.clickUpClientId,
    required this.clickUpClientSecret,
    required this.clickUpUrl,
  });

  @override
  Future<ClickUpAccessTokenModel> getClickUpAccessToken(
      {required GetClickUpAccessTokenParams params}) async {
    final result = await network.post(
        uri:
        Uri.parse("$clickUpUrl/oauth/token?client_id=$clickUpClientId&client_secret=$clickUpClientSecret&code=${params.code}"));
    return ClickUpAccessTokenModel.fromJson(json.decode(result.body));
  }

  @override
  Future<ClickupUserModel> getClickUpUser({required GetClickUpUserParams params}) async {
    final result = await network.get(
        uri: Uri.parse("$clickUpUrl/user"),
        headers: clickUpHeader(clickUpAccessToken: params.clickUpAccessToken));
    return ClickupUserModel.fromJson(json.decode(result.body)["user"]);
  }

}
