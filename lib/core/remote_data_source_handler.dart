import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/common/entities/access_token.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:thetimeblockingapp/features/auth/data/models/sign_in_result_model.dart';
import 'package:thetimeblockingapp/features/auth/presentation/bloc/auth_bloc.dart';

import '../common/models/access_token_model.dart';
import '../features/auth/data/data_sources/auth_local_data_source.dart';
import 'error/exception_to_failure.dart';
import 'error/exceptions.dart';
import 'error/failures.dart';
import 'network/network.dart';

Future<NetworkResponse> remoteDateRequestHandler<S>(
    {required Network network,
    required Future<NetworkResponse> Function(AccessTokenModel accessTokenModel) request
    }) async {
  late NetworkResponse response;
  AccessTokenModel accessTokenModel = serviceLocator<AccessToken>(
      instanceName: ServiceLocatorName.accessToken.name)
      .toModel;
  try {
    response = await request(accessTokenModel);
  } on TokenTimeOutException catch (e) {
    ///TODO improve
    printDebug("TokenTimeOutException", printLevel: PrintLevel.error);
    try {
      final refreshTokenResult = await serviceLocator<AuthRemoteDataSource>()
          .refreshToken(
              refreshToken: serviceLocator<String>(
                  instanceName: ServiceLocatorName.refreshToken.name),
              accessToken: accessTokenModel);
      await serviceLocator<AuthLocalDataSource>()
          .saveSignInResult(refreshTokenResult);
      serviceLocator.registerSingleton<String>(refreshTokenResult.refreshToken,
          instanceName: ServiceLocatorName.refreshToken.name);
      serviceLocator.registerSingleton<AccessToken>(
          refreshTokenResult.accessToken,
          instanceName: ServiceLocatorName.accessToken.name);
      response = await request(refreshTokenResult.accessToken as AccessTokenModel);
    } on Exception catch (e) {
      printDebug("RefreshToken Exception $e", printLevel: PrintLevel.error);
    }
  }
  return response;
}
