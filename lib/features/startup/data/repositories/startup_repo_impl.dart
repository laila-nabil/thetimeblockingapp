import 'package:dartz/dartz.dart';

import 'package:thetimeblockingapp/common/entities/clickup_workspace.dart';
import 'package:thetimeblockingapp/common/models/clickup_workspace_model.dart';

import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import '../../../../core/globals.dart';
import '../../../../core/repo_handler.dart';
import '../../domain/repositories/startup_repo.dart';
import '../../domain/use_cases/get_clickup_workspaces_use_case.dart';
import '../data_sources/startup_local_data_source.dart';
import '../data_sources/startup_remote_data_source.dart';

class StartUpRepoImpl implements StartUpRepo {
  final StartUpRemoteDataSource startUpRemoteDataSource;
  final StartUpLocalDataSource startUpLocalDataSource;
  StartUpRepoImpl(this.startUpRemoteDataSource, this.startUpLocalDataSource,);

  @override
  Future<Either<Failure, List<ClickupWorkspace>>> getClickUpWorkspaces(
      {required GetClickUpWorkspacesParams params}) {
    return repoHandler(
        remoteDataSourceRequest: () async =>
            await startUpRemoteDataSource.getClickUpWorkspaces(params: params),
        trySaveResult: (result)async{
          Globals.clickUpWorkspaces =  result;
          printDebug(
              "getClickUpWorkspaces $result ${Globals.clickUpWorkspaces}");
          await startUpLocalDataSource
              .saveClickUpWorkspaces(result as List<ClickupWorkspaceModel>);
        },
        tryGetFromLocalStorage: () async =>
            await startUpLocalDataSource.getClickUpWorkspaces());
  }
}
