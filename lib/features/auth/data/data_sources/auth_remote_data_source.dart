import 'dart:convert';

import 'package:thetimeblockingapp/common/models/clickup_user_model.dart';
import 'package:thetimeblockingapp/core/demo.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/network/network.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import '../../../../core/network/clickup_header.dart';
import '../../domain/use_cases/get_clickup_access_token_use_case.dart';
import '../../domain/use_cases/get_clickup_user_use_case.dart';
import '../models/clickup_access_token_model.dart';

abstract class AuthRemoteDataSource {
  Future<ClickupAccessTokenModel> getClickupAccessToken(
      {required GetClickupAccessTokenParams params});

  Future<ClickupUserModel> getClickupUser(
      {required GetClickupUserParams params});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Network network;
  final String clickupClientId;
  final String clickupClientSecret;
  final String clickupUrl;

  AuthRemoteDataSourceImpl({
    required this.network,
    required this.clickupClientId,
    required this.clickupClientSecret,
    required this.clickupUrl,
  });

  @override
  Future<ClickupAccessTokenModel> getClickupAccessToken(
      {required GetClickupAccessTokenParams params}) async {
    printDebug("params.code ${params.code}");
    final result = await network.post(
        uri: Uri.parse(
            "https://corsproxy.io/?https://api.clickup.com/api/v2/oauth/token?client_id=$clickupClientId&client_secret=$clickupClientSecret&code=${params.code}"));
    return ClickupAccessTokenModel.fromJson(json.decode(result.body));
  }

  @override
  Future<ClickupUserModel> getClickupUser({required GetClickupUserParams params}) async {
    final result = await network.get(
        uri: Uri.parse("$clickupUrl/user"),
        headers: clickupHeader(clickupAccessToken: params.clickupAccessToken));
    return ClickupUserModel.fromJson(json.decode(result.body)["user"]);
  }

}
