import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/common/models/clickup_workspace_model.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/features/startup/domain/use_cases/select_space_use_case.dart';
import 'package:thetimeblockingapp/features/startup/domain/use_cases/select_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/data/data_sources/tasks_local_data_source.dart';
import 'package:thetimeblockingapp/features/tasks/data/models/clickup_space_model.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_space.dart';
import '../../../../core/repo_handler.dart';
import '../../../../core/usecase.dart';
import '../../domain/repositories/startup_repo.dart';
import '../data_sources/startup_local_data_source.dart';
import '../data_sources/startup_remote_data_source.dart';

class StartUpRepoImpl implements StartUpRepo {
  final StartUpRemoteDataSource startUpRemoteDataSource;
  final TasksLocalDataSource tasksLocalDataSource;

  StartUpRepoImpl(
    this.startUpRemoteDataSource,
    this.tasksLocalDataSource,
  );

  @override
  Future<Either<Failure, Unit>?> selectWorkspace(
      SelectWorkspaceParams params) async {
    return repoHandleLocalSaveRequest(
        trySaveResult: () => tasksLocalDataSource. saveSelectedWorkspace(
            params.clickupWorkspace as ClickupWorkspaceModel));
  }

  @override
  Future<Either<Failure, ClickupWorkspaceModel>?> getSelectedWorkspace(
      NoParams params) async {
    return repoHandleLocalGetRequest(
        tryGetFromLocalStorage: () =>
            tasksLocalDataSource.getSelectedWorkspace());
  }

  @override
  Future<Either<Failure, ClickupSpace>?> getSelectedSpace(NoParams params) async {
    return repoHandleLocalGetRequest(
        tryGetFromLocalStorage: () =>
            tasksLocalDataSource.getSelectedSpace());
  }

  @override
  Future<Either<Failure, Unit>?> selectSpace(SelectSpaceParams params) async {
    return repoHandleLocalSaveRequest(
        trySaveResult: () => tasksLocalDataSource.saveSelectedSpace(
            params.clickupSpace as ClickupSpaceModel));
  }
}
