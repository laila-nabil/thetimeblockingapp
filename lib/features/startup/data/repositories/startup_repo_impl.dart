import 'package:dartz/dartz.dart';

import 'package:thetimeblockingapp/common/models/clickup_workspace_model.dart';

import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/tasks/data/models/clickup_folder_model.dart';
import 'package:thetimeblockingapp/features/startup/domain/use_cases/get_clickup_folders_use_case.dart';
import '../../../../core/globals.dart';
import '../../../../core/repo_handler.dart';
import '../../domain/repositories/startup_repo.dart';
import '../../domain/use_cases/get_clickup_workspaces_use_case.dart';
import '../data_sources/startup_local_data_source.dart';
import '../data_sources/startup_remote_data_source.dart';

class StartUpRepoImpl implements StartUpRepo {
  final StartUpRemoteDataSource startUpRemoteDataSource;
  final StartUpLocalDataSource startUpLocalDataSource;

  StartUpRepoImpl(
    this.startUpRemoteDataSource,
    this.startUpLocalDataSource,
  );

  @override
  Future<Either<Failure, List<ClickupWorkspaceModel>>> getClickupWorkspaces(
      {required GetClickupWorkspacesParams params}) {
    return repoHandler(
        remoteDataSourceRequest: () async =>
            await startUpRemoteDataSource.getClickupWorkspaces(params: params),
        trySaveResult: (result) async {
          Globals.clickupWorkspaces = result;
          printDebug(
              "getClickUpWorkspaces $result ${Globals.clickupWorkspaces}");
          await startUpLocalDataSource
              .saveClickupWorkspaces(result);
        },
        tryGetFromLocalStorage: () async =>
            await startUpLocalDataSource.getClickupWorkspaces());
  }

  @override
  Future<Either<Failure, List<ClickupFolderModel>>> getClickupFolders(
      {required GetClickupFoldersParams params}) {
    return repoHandler(
        remoteDataSourceRequest: () =>
        startUpRemoteDataSource.getClickupFolders(params: params),
        trySaveResult: (result) async {
          Globals.clickupFolders = result;
          printDebug(
              "getClickUpWorkspaces $result ${Globals.clickupWorkspaces}");
          await startUpLocalDataSource
              .saveClickupWorkspaces(result as List<ClickupWorkspaceModel>);
        },);
  }
}
