import 'package:dartz/dartz.dart';

import 'package:thetimeblockingapp/common/entities/clickup_user.dart';
import 'package:thetimeblockingapp/core/backend.dart';

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

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepoImpl(this.authRemoteDataSource, this.authLocalDataSource);

  @override
  Future<Either<Failure, ClickupAccessToken>> getClickupAccessToken(
      {required GetClickupAccessTokenParams params}) async {
    final result = await repoHandleRemoteRequest<ClickupAccessToken>(
        remoteDataSourceRequest: () async =>
            await authRemoteDataSource.getClickupAccessToken(params: params),
        trySaveResult: (result) async {
          Globals.clickupGlobals =
              Globals.clickupGlobals?.copyWith(clickupAuthAccessToken: result);
          await authLocalDataSource
              .saveClickupAccessToken(result as ClickupAccessTokenModel);
          printDebug(
              "getClickUpAccessToken $result ${Globals.clickupGlobals?.clickupAuthAccessToken}");
        },
        tryGetFromLocalStorage: () async =>
            await authLocalDataSource.getClickupAccessToken());
    return result;
  }

  @override
  Future<Either<Failure, ClickupUser>> getClickupUser(
      {required GetClickupUserParams params}) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () async =>
            await authRemoteDataSource.getClickupUser(params: params),
        trySaveResult: (result) async {
          Globals.clickupGlobals =
              Globals.clickupGlobals?.copyWith(clickupUser: result);
          printDebug(
              "getClickUpUser $result ${Globals.clickupGlobals?.clickupUser}");
          await authLocalDataSource.saveClickupUser(result as ClickupUserModel);
        },
        tryGetFromLocalStorage: () async =>
            await authLocalDataSource.getClickupUser());
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await authLocalDataSource.signOut();
      Globals.clickupGlobals = ClickupGlobals(
          clickupUrl: '',
          clickupClientId: '',
          clickupClientSecret: '',
          clickupRedirectUrl: '',
          clickupAuthAccessToken:
              const ClickupAccessToken(accessToken: '', tokenType: ''));
      return const Right(unit);
    } catch (e) {
      printDebug(e);
      return Left(exceptionToFailure(e as Exception));
    }
  }
}
