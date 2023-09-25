import 'package:thetimeblockingapp/core/network/network.dart';
import '../../domain/use_cases/get_clickup_access_token_use_case.dart';
import '../models/clickup_access_token_model.dart';

abstract class AuthRemoteDataSource {
  Future<ClickUpAccessTokenModel> getClickUpAccessToken(
      {required GetClickUpAccessTokenParams params});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Network network;
  final String clickUpClientId;
  final String clickUpClientSecret;

  AuthRemoteDataSourceImpl({
    required this.network,
    required this.clickUpClientId,
    required this.clickUpClientSecret,
  });

  @override
  Future<ClickUpAccessTokenModel> getClickUpAccessToken(
      {required GetClickUpAccessTokenParams params}) async {
    final result = await network.post(
        url:
            "https://api.clickup.com/api/v2/oauth/token?client_id=$clickUpClientId&client_secret=$clickUpClientSecret&code=${params.code}");
    return ClickUpAccessTokenModel.fromJson(result.body);
  }
}
