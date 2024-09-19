import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/common/entities/access_token.dart';

import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';

import 'package:thetimeblockingapp/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:thetimeblockingapp/features/auth/data/models/sign_up_result_model.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/sign_up_use_case.dart';
import '../../../../core/error/exception_to_failure.dart';

import '../../../../core/repo_handler.dart';
import '../../domain/repositories/auth_repo.dart';
import '../data_sources/auth_local_data_source.dart';
import '../models/sign_in_result_model.dart';

class AuthRepoImpl  implements AuthRepo{
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;
  AuthRepoImpl(this.authRemoteDataSource, this.authLocalDataSource);


  @override
  Future<dartz.Either<Failure, dartz.Unit>> signOut() async{
    try {
      await authRemoteDataSource.signOut();
      await authLocalDataSource.signOut();
      return const dartz.Right(dartz.unit);
    } catch (e) {
      printDebug(e,printLevel: PrintLevel.error);
      return dartz.Left(exceptionToFailure(e as Exception));
    }
  }

  @override
  Future<dartz.Either<Failure, SignInResultModel>> signIn({required SignInParams params}) async {
    dartz.Either<Failure, SignInResultModel> result;
    if(params.email.isNotEmpty && params.password.isNotEmpty){
      result = await repoHandleRemoteRequest<SignInResultModel>(
          remoteDataSourceRequest: () async =>
              await authRemoteDataSource.signInSupabase(params: params),
          trySaveResult: (result) async {
            await authLocalDataSource
                .saveSignInResult(result);
            serviceLocator.registerSingleton<String>(result.refreshToken,
                instanceName: ServiceLocatorName.refreshToken.name);
            serviceLocator.registerSingleton<AccessToken>(result.accessToken,
                instanceName: ServiceLocatorName.accessToken.name);
          },
          tryGetFromLocalStorage: () async {
            final result = await authLocalDataSource.getSignInResult();
            serviceLocator.registerSingleton<String>(result.refreshToken,
                instanceName: ServiceLocatorName.refreshToken.name);
            serviceLocator.registerSingleton<AccessToken>(result.accessToken,
                instanceName: ServiceLocatorName.accessToken.name);
            return result;
          }, );
    }else{
      result = await repoHandleLocalGetRequest<SignInResultModel>(
          tryGetFromLocalStorage: () async {
            final result = await authLocalDataSource.getSignInResult();
            serviceLocator.registerSingleton<String>(result.refreshToken,
                instanceName: ServiceLocatorName.refreshToken.name);
            serviceLocator.registerSingleton<AccessToken>(result.accessToken,
                instanceName: ServiceLocatorName.accessToken.name);
            return result;
          });
    }
    return result;
  }

  @override
  Future<dartz.Either<Failure, SignUpResultModel>> signUp({required SignUpParams params}) async {
    final result = await repoHandleRemoteRequest<SignUpResultModel>(
        remoteDataSourceRequest: () =>
          authRemoteDataSource.signUpSupabase(params: params),
    );
    return result;
  }
}
