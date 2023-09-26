import 'package:dartz/dartz.dart';

import 'package:thetimeblockingapp/common/entities/clickup_user.dart';

import 'package:thetimeblockingapp/common/entities/clickup_workspace.dart';

import 'package:thetimeblockingapp/core/error/failures.dart';

import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/auth/data/data_sources/auth_remote_data_source.dart';

import 'package:thetimeblockingapp/features/auth/domain/entities/clickup_access_token.dart';

import 'package:thetimeblockingapp/features/auth/domain/use_cases/get_clickup_access_token_use_case.dart';

import '../../../../core/globals.dart';
import '../../../../core/repo_handler.dart';
import '../../domain/repositories/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepoImpl(this.authRemoteDataSource);

  @override
  Future<Either<Failure, ClickUpAccessToken>> getClickUpAccessToken(
      {required GetClickUpAccessTokenParams params}) async {
    final result = await repoHandler<ClickUpAccessToken>(() async =>
        await authRemoteDataSource.getClickUpAccessToken(params: params));
    if(result.isRight()){
      Globals.clickUpAuthAccessToken =
          result.getOrElse(() => const ClickUpAccessToken(accessToken: "", tokenType: "")).accessToken;
    }
    return result;
  }

  @override
  Future<Either<Failure, ClickupUser>> getClickUpUser(
      {required NoParams params}) {
    return repoHandler(
        () async => await authRemoteDataSource.getClickUpUser(params: params));
  }

  @override
  Future<Either<Failure, List<ClickupWorkspace>>> getClickUpWorkspaces(
      {required NoParams params}) {
    return repoHandler(() async =>
        await authRemoteDataSource.getClickUpWorkspaces(params: params));
  }
}
