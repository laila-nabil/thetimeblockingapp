import 'package:thetimeblockingapp/common/entities/access_token.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/auth/data/data_sources/auth_remote_data_source.dart';

import '../common/models/access_token_model.dart';
import '../features/auth/data/data_sources/auth_local_data_source.dart';
import 'error/exceptions.dart';
import 'network/network.dart';

Future<NetworkResponse> remoteDateRequestHandler<S>(
    {required Network network,
    required Future<NetworkResponse> Function(AccessTokenModel accessTokenModel) request
    }) async {
  late NetworkResponse response;
  AccessTokenModel accessTokenModel = serviceLocator<AppConfig>().accessToken.toModel;
  try {
    response = await request(accessTokenModel);
  } on TokenTimeOutException {
    ///TODO improve
    printDebug("TokenTimeOutException", printLevel: PrintLevel.error);
    try {
      final refreshTokenResult = await serviceLocator<AuthRemoteDataSource>()
          .refreshToken(
              refreshToken: serviceLocator<AppConfig>().refreshToken,
              accessToken: accessTokenModel);
      await serviceLocator<AuthLocalDataSource>()
          .saveSignInResult(refreshTokenResult);
      serviceLocator<AppConfig>().refreshToken = refreshTokenResult.refreshToken;
      serviceLocator<AppConfig>().accessToken = refreshTokenResult.accessToken;
      response = await request(refreshTokenResult.accessToken as AccessTokenModel);
    } on Exception catch (e) {
      printDebug("RefreshToken Exception $e", printLevel: PrintLevel.error);
    }
  }
  return response;
}
