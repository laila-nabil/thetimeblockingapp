import 'package:dartz/dartz.dart' as dartz; 

import 'package:thetimeblockingapp/common/entities/user.dart';

import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';

import 'package:thetimeblockingapp/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:thetimeblockingapp/features/auth/data/models/clickup_access_token_model.dart';

import 'package:thetimeblockingapp/features/auth/domain/entities/clickup_access_token.dart';

import 'package:thetimeblockingapp/features/auth/domain/use_cases/get_clickup_access_token_use_case.dart';

import '../../../../common/models/clickup_user_model.dart';
import '../../../../core/error/exception_to_failure.dart';
import '../../../../core/globals.dart';
import '../../../../core/repo_handler.dart';
import '../../domain/repositories/auth_repo.dart';
import '../../domain/use_cases/get_clickup_user_use_case.dart';
import '../data_sources/auth_local_data_source.dart';

class AuthRepoImpl  with GlobalsWriteAccess implements AuthRepo{
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;
  AuthRepoImpl(this.authRemoteDataSource, this.authLocalDataSource);

  @override
  Future<dartz.Either<Failure, ClickupAccessToken>> getClickupAccessToken(
      {required GetClickupAccessTokenParams params}) async {
    final result = await repoHandleRemoteRequest<ClickupAccessToken>(
        remoteDataSourceRequest: () async =>
            await authRemoteDataSource.getClickupAccessToken(params: params),
      trySaveResult: (result)async{
        clickupAuthAccessToken =  result;
          await authLocalDataSource
              .saveClickupAccessToken(result as ClickupAccessTokenModel);
        printDebug(
            "getClickUpAccessToken $result ${Globals.clickupAuthAccessToken}");
      },
        tryGetFromLocalStorage: () async =>
            await authLocalDataSource.getClickupAccessToken());
    return result;
  }

  @override
  Future<dartz.Either<Failure, User>> getClickupUser(
      {required GetClickupUserParams params}) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () async =>
            await authRemoteDataSource.getClickupUser(params: params),
        trySaveResult: (result)async{
          clickupUser =  result;
          printDebug(
              "getClickUpUser $result ${Globals.clickupUser}");
          await authLocalDataSource
              .saveClickupUser(result as ClickupUserModel);
        },
        tryGetFromLocalStorage: () async =>
            await authLocalDataSource.getClickupUser());
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>> signOut() async {
    try {
      await authLocalDataSource.signOut();
      clearGlobals();
      return const dartz.Right(dartz.unit);
    } catch (e) {
      printDebug(e);
      return dartz.Left(exceptionToFailure(e as Exception));
    }
  }

}
