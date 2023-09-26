import 'dart:convert';

import 'package:thetimeblockingapp/common/models/clickup_user_model.dart';
import 'package:thetimeblockingapp/common/models/clickup_workspace_model.dart';
import 'package:thetimeblockingapp/core/network/network.dart';
import '../../../../core/network/clickup_header.dart';
import '../../domain/use_cases/get_clickup_access_token_use_case.dart';
import '../../domain/use_cases/get_clickup_user_use_case.dart';
import '../../domain/use_cases/get_clickup_workspaces_use_case.dart';
import '../models/clickup_access_token_model.dart';

abstract class AuthRemoteDataSource {
  Future<ClickUpAccessTokenModel> getClickUpAccessToken(
      {required GetClickUpAccessTokenParams params});

  Future<ClickupUserModel> getClickUpUser({required GetClickUpUserParams params});

  Future<List<ClickupWorkspaceModel>> getClickUpWorkspaces(
      {required GetClickUpWorkspacesParams params});
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
        url:
            "${clickUpUrl}oauth/token?client_id=$clickUpClientId&client_secret=$clickUpClientSecret&code=${params.code}");
    return ClickUpAccessTokenModel.fromJson(json.decode(result.body));
  }

  @override
  Future<ClickupUserModel> getClickUpUser({required GetClickUpUserParams params}) async {
    final result = await network.get(
        url: "${clickUpUrl}oauth/user",
        headers: clickUpHeader(clickUpAccessToken: params.clickUpAccessToken));
    return ClickupUserModel.fromJson(json.decode(result.body));
  }

  @override
  Future<List<ClickupWorkspaceModel>> getClickUpWorkspaces(
      {required GetClickUpWorkspacesParams params}) async {
    List<ClickupWorkspaceModel> result = [];
    final response = await network.get(
        url: "${clickUpUrl}oauth/team",
        headers: clickUpHeader(clickUpAccessToken: params.clickUpAccessToken));
    if (response.body is List) {
      for (var element in (response.body as List)) {
        result.add(ClickupWorkspaceModel.fromJson(json.decode(element)));
      }
    }
    return result;
  }
}
