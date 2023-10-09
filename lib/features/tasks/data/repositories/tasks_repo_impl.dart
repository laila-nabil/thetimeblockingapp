import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/features/tasks/data/data_sources/tasks_remote_data_source.dart';
import 'package:thetimeblockingapp/features/tasks/data/models/clickup_task_model.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';

import '../../../../common/models/clickup_workspace_model.dart';
import '../../../../core/globals.dart';
import '../../../../core/print_debug.dart';
import '../../../../core/repo_handler.dart';
import '../../domain/entities/clickup_list.dart';
import '../../domain/entities/task_parameters.dart';
import '../../domain/use_cases/get_clickup_folderless_lists_in_space_use_case.dart';
import '../../domain/use_cases/get_clickup_folders_in_space_use_case.dart';
import '../../domain/use_cases/get_clickup_lists_in_folder_use_case.dart';
import '../../domain/use_cases/get_clickup_workspaces_use_case.dart';
import '../data_sources/tasks_local_data_source.dart';
import '../models/clickup_folder_model.dart';
import '../models/clickup_list_model.dart';

class TasksRepoImpl implements TasksRepo {
  final TasksRemoteDataSource remoteDataSource;
  final TasksLocalDataSource localDataSource;
  TasksRepoImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Failure, List<ClickupTaskModel>>> getTasksInWorkspace(
      {required GetClickupTasksInWorkspaceParams params}) {
    return repoHandler(
        remoteDataSourceRequest: () async =>
            await remoteDataSource.getTasksInWorkspace(params: params));
  }

  @override
  Future<Either<Failure, ClickupTaskModel>?> createTaskInList(
      ClickupTaskParams params) {
    return repoHandler(
        remoteDataSourceRequest: () async =>
            await remoteDataSource.createTaskInList(params: params));
  }

  @override
  Future<Either<Failure, ClickupTask>?> updateTask(
      ClickupTaskParams params) {
    return repoHandler(
        remoteDataSourceRequest: () async =>
        await remoteDataSource.updateTask(params: params));
  }

  @override
  Future<Either<Failure, Unit>?> deleteTask(DeleteClickupTaskParams params) {
    return repoHandler(
        remoteDataSourceRequest: () async =>
        await remoteDataSource.deleteTask(params: params));
  }

  @override
  Future<Either<Failure, List<ClickupWorkspaceModel>>> getClickupWorkspaces(
      {required GetClickupWorkspacesParams params}) {
    return repoHandler(
        remoteDataSourceRequest: () async =>
        await remoteDataSource.getClickupWorkspaces(params: params),
        trySaveResult: (result) async {
          Globals.clickupWorkspaces = result;
          printDebug(
              "getClickUpWorkspaces $result ${Globals.clickupWorkspaces}");
          await localDataSource.saveClickupWorkspaces(result);
        },
        tryGetFromLocalStorage: () async =>
        await localDataSource.getClickupWorkspaces());
  }

  @override
  Future<Either<Failure, List<ClickupFolderModel>>> getClickupFolders(
      {required GetClickupFoldersInSpaceParams params}) {
    return repoHandler(
      remoteDataSourceRequest: () =>
          remoteDataSource.getClickupFolders(params: params),
      trySaveResult: (result) async {
        Globals.clickupListsInFolders = {};
        result.map((e) => Globals.clickupListsInFolders![e] = []);
        printDebug(
            "clickupListsInFolders $result ${Globals.clickupListsInFolders}");
      },
    );
  }

  @override
  Future<Either<Failure, List<ClickupListModel>>> getClickupListsInFolder(
      {required GetClickupListsInFolderParams params}) {
    return repoHandler(
      remoteDataSourceRequest: () =>
          remoteDataSource.getClickupListsInFolder(params: params),
      trySaveResult: (result) async {
        Globals.clickupListsInFolders?[params.clickupFolder] = result;
        printDebug(
            "clickupListsInFolders $result ${Globals.clickupListsInFolders}");
      },
    );
  }

  @override
  Future<Either<Failure, List<ClickupList>>> getClickupFolderlessLists(
      {required GetClickupFolderlessListsInSpaceParams params})  {
    return repoHandler(
      remoteDataSourceRequest: () =>
          remoteDataSource.getClickupFolderlessLists(params: params),
      trySaveResult: (result) async {
        Globals.clickupFolderLessLists = result;
        printDebug(
            "clickupFolderLessLists $result ${Globals.clickupFolderLessLists}");
      },
    );
  }
}
