import 'package:thetimeblockingapp/common/models/clickup_user_model.dart';
import 'package:thetimeblockingapp/core/network/network.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import '../../../../core/network/clickup_header.dart';
import '../../domain/use_cases/get_clickup_access_token_use_case.dart';
import '../models/clickup_access_token_model.dart';

abstract class AuthRemoteDataSource {
  Future<ClickUpAccessTokenModel> getClickUpAccessToken(
      {required GetClickUpAccessTokenParams params});

  Future<ClickupUserModel> getClickUpUser({required NoParams params});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Network network;
  final String clickUpClientId;
  final String clickUpClientSecret;
  final String clickUpUrl;
  final String clickUpAccessToken;

  AuthRemoteDataSourceImpl({
    required this.network,
    required this.clickUpClientId,
    required this.clickUpClientSecret,
    required this.clickUpUrl,
    required this.clickUpAccessToken,
  });

  @override
  Future<ClickUpAccessTokenModel> getClickUpAccessToken(
      {required GetClickUpAccessTokenParams params}) async {
    final result = await network.post(
        url:
            "$clickUpUrl/oauth/token?client_id=$clickUpClientId&client_secret=$clickUpClientSecret&code=${params.code}");
    return ClickUpAccessTokenModel.fromJson(result.body);
  }

  @override
  Future<ClickupUserModel> getClickUpUser({required NoParams params}) async {
    final result = await network.get(
        url: "$clickUpUrl/oauth/user",
        headers: clickUpHeader(clickUpAccessToken: clickUpAccessToken));
    return ClickupUserModel.fromJson(result.body);
  }
}