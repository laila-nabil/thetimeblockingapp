import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/common/entities/user.dart';
import 'package:thetimeblockingapp/common/models/access_token_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_user_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_workspace_model.dart';

import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';

import 'package:thetimeblockingapp/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:thetimeblockingapp/features/auth/data/models/sign_up_result_model.dart';
import 'package:thetimeblockingapp/features/auth/domain/entities/sign_up_anonymously_result.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/sign_up_anonymously_use_case.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/update_user_use_case.dart';
import 'package:thetimeblockingapp/features/global/data/data_sources/global_remote_data_source.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/delete_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/get_workspaces_use_case.dart';
import '../../../../core/error/exception_to_failure.dart';

import '../../../../core/repo_handler.dart';
import '../../domain/repositories/auth_repo.dart';
import '../../domain/use_cases/delete_account_use_case.dart';
import '../data_sources/auth_local_data_source.dart';
import '../models/sign_in_result_model.dart';

class AuthRepoImpl  implements AuthRepo{
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;
  final GlobalRemoteDataSource globalRemoteDataSource;
  AuthRepoImpl(this.authRemoteDataSource, this.authLocalDataSource, this.globalRemoteDataSource);


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
                serviceLocator<AppConfig>().refreshToken = result.refreshToken;
                serviceLocator<AppConfig>().accessToken = result.accessToken;
          },
          tryGetFromLocalStorage: () async {
            final result = await authLocalDataSource.getSignInResult();
            serviceLocator<AppConfig>().refreshToken = result.refreshToken;
            serviceLocator<AppConfig>().accessToken = result.accessToken;
            return result;
          }, );
    }else{
      result = await repoHandleLocalGetRequest<SignInResultModel>(
          tryGetFromLocalStorage: () async {
            final result = await authLocalDataSource.getSignInResult();
             serviceLocator<AppConfig>().refreshToken = result.refreshToken;
            serviceLocator<AppConfig>().accessToken = result.accessToken;
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


  @override
  Future<dartz.Either<Failure, dartz.Unit>> deleteAccount(
      DeleteAccountParams params) async {
    dartz.Either<Failure, List<WorkspaceModel>>? getWorkspacesResult;
    dartz.Either<Failure, dartz.Unit>? deleteAccountResult;
    getWorkspacesResult = await repoHandleRemoteRequest(
      remoteDataSourceRequest: () async =>
      await globalRemoteDataSource.getWorkspaces(
          params: GetWorkspacesParams(userId: params.user.id ?? "")),
    );
    await getWorkspacesResult
        .fold((l) async => printDebug("getWorkspacesResult $l"), (r) async {
      for (var workspace in r) {
        final deleteWorkspace = await globalRemoteDataSource.deleteWorkspace(
            params: DeleteWorkspaceParams(workspace));
        printDebug("deleteWorkspace $deleteWorkspace");
      }
    });

    deleteAccountResult = await repoHandleRemoteRequest(
      remoteDataSourceRequest: () async =>
      await authRemoteDataSource.deleteAccount(),
    );
    await deleteAccountResult
        .fold((l) async => printDebug("deleteAccountResult $l"), (r) async {
      await authLocalDataSource.signOut();
    });

    return deleteAccountResult;
  }

  @override
  Future<dartz.Either<Failure, SignUpAnonymouslyResult>> signUpAnonymously(
      {required SignUpAnonymouslyParams params}) async {
    dartz.Either<Failure, SignUpAnonymouslyResult> result;

    result = await repoHandleRemoteRequest<SignUpAnonymouslyResult>(
      remoteDataSourceRequest: () async =>
      await authRemoteDataSource.signUpAnonymouslySupabase(params: params),
      trySaveResult: (result) async {
        if (result.accessToken != null &&
            result.user != null &&
            result.refreshToken != null) {
          await authLocalDataSource.saveSignInResult(SignInResultModel(
              accessToken: result.accessToken as AccessTokenModel,
              user: result.user as SupabaseUserModel,
              refreshToken: result.refreshToken!));
          serviceLocator<AppConfig>().refreshToken = result.refreshToken!;
          serviceLocator<AppConfig>().accessToken = result.accessToken!;
        }
      },);
    return result;
  }

  @override
  Future<dartz.Either<Failure, User>> updateUser({required UpdateUserParams params}) async {
    dartz.Either<Failure, User> result;
    result = await repoHandleRemoteRequest<User>(
      remoteDataSourceRequest: () async =>
      await authRemoteDataSource.updateUser(params: params),
      trySaveResult: (result) async {
        await authLocalDataSource.saveSupabaseUser(result as SupabaseUserModel);
      },);
    return result;
  }
}
