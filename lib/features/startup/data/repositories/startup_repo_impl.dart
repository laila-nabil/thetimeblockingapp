import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/common/models/clickup_workspace_model.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/features/startup/domain/use_cases/select_workspace_use_case.dart';
import '../../../../core/repo_handler.dart';
import '../../../../core/usecase.dart';
import '../../domain/repositories/startup_repo.dart';
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
  Future<Either<Failure, Unit>?> selectWorkspace(
      SelectWorkspaceParams params) async {
    return repoHandleLocalSaveRequest(
        trySaveResult: () => startUpLocalDataSource.saveSelectedWorkspace(
            params.clickupWorkspace as ClickupWorkspaceModel));
  }

  @override
  Future<Either<Failure, ClickupWorkspaceModel>?> getSelectedWorkspace(
      NoParams params) async {
    return repoHandleLocalGetRequest(
        tryGetFromLocalStorage: () =>
            startUpLocalDataSource.getSelectedWorkspace());
  }
}
