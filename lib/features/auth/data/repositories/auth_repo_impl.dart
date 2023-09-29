import 'package:dartz/dartz.dart';

import 'package:thetimeblockingapp/common/entities/clickup_user.dart';

import 'package:thetimeblockingapp/common/entities/clickup_workspace.dart';
import 'package:thetimeblockingapp/common/models/clickup_workspace_model.dart';

import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';

import 'package:thetimeblockingapp/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:thetimeblockingapp/features/auth/data/models/clickup_access_token_model.dart';

import 'package:thetimeblockingapp/features/auth/domain/entities/clickup_access_token.dart';

import 'package:thetimeblockingapp/features/auth/domain/use_cases/get_clickup_access_token_use_case.dart';

import '../../../../common/models/clickup_user_model.dart';
import '../../../../core/globals.dart';
import '../../../../core/repo_handler.dart';
import '../../domain/repositories/auth_repo.dart';
import '../../domain/use_cases/get_clickup_user_use_case.dart';
import '../../domain/use_cases/get_clickup_workspaces_use_case.dart';
import '../data_sources/auth_local_data_source.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;
  AuthRepoImpl(this.authRemoteDataSource, this.authLocalDataSource);

  @override
  Future<Either<Failure, ClickUpAccessToken>> getClickUpAccessToken(
      {required GetClickUpAccessTokenParams params}) async {
    final result = await repoHandler<ClickUpAccessToken>(
        remoteDataSourceRequest: () async =>
            await authRemoteDataSource.getClickUpAccessToken(params: params),
      trySaveResult: (result)async{
        Globals.clickUpAuthAccessToken =  result;
          await authLocalDataSource
              .saveClickUpAccessToken(result as ClickUpAccessTokenModel);
        printDebug(
            "getClickUpAccessToken $result ${Globals.clickUpAuthAccessToken}");
      },
        tryGetFromLocalStorage: () async =>
            await authLocalDataSource.getClickUpAccessToken());
    return result;
  }

  @override
  Future<Either<Failure, ClickupUser>> getClickUpUser(
      {required GetClickUpUserParams params}) {
    return repoHandler(
        remoteDataSourceRequest: () async =>
            await authRemoteDataSource.getClickUpUser(params: params),
        trySaveResult: (result)async{
          Globals.clickUpUser =  result;
          printDebug(
              "getClickUpUser $result ${Globals.clickUpUser}");
          await authLocalDataSource
              .saveClickUpUser(result as ClickupUserModel);
        },
        tryGetFromLocalStorage: () async =>
            await authLocalDataSource.getClickUpUser());
  }

  @override
  Future<Either<Failure, List<ClickupWorkspace>>> getClickUpWorkspaces(
      {required GetClickUpWorkspacesParams params}) {
    return repoHandler(
        remoteDataSourceRequest: () async =>
            await authRemoteDataSource.getClickUpWorkspaces(params: params),
        trySaveResult: (result)async{
          Globals.clickUpWorkspaces =  result;
          printDebug(
              "getClickUpWorkspaces $result ${Globals.clickUpWorkspaces}");
          await authLocalDataSource
              .saveClickUpWorkspaces(result as List<ClickupWorkspaceModel>);
        },
        tryGetFromLocalStorage: () async =>
            await authLocalDataSource.getClickUpWorkspaces());
  }
}
