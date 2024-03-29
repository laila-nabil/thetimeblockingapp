import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/features/tasks/data/data_sources/tasks_remote_data_source.dart';
import 'package:thetimeblockingapp/features/tasks/data/models/clickup_space_model.dart';
import 'package:thetimeblockingapp/features/tasks/data/models/clickup_task_model.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_clickup_folder_in_space_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_clickup_list_in_folder_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/add_tag_to_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/add_task_to_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_clickup_tag_in_space_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folderless_list_clickup_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_folder_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_tag_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_clickup_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_clickup_spaces_in_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_clickup_tags_in_space_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/remove_tag_from_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/remove_task_from_list_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/update_clickup_tag_use_case.dart';

import '../../../../common/models/clickup_workspace_model.dart';
import '../../../../core/globals.dart';
import '../../../../core/print_debug.dart';
import '../../../../core/repo_handler.dart';
import '../../../../core/usecase.dart';
import '../../../startup/domain/use_cases/save_spaces_use_case.dart';
import '../../../startup/domain/use_cases/select_space_use_case.dart';
import '../../../startup/domain/use_cases/select_workspace_use_case.dart';
import '../../domain/entities/clickup_space.dart';
import '../../domain/entities/task_parameters.dart';
import '../../domain/use_cases/get_clickup_folderless_lists_in_space_use_case.dart';
import '../../domain/use_cases/get_clickup_folders_in_space_use_case.dart';
import '../../domain/use_cases/get_clickup_lists_in_folder_use_case.dart';
import '../../domain/use_cases/get_clickup_workspaces_use_case.dart';
import '../data_sources/tasks_local_data_source.dart';
import '../models/clickup_folder_model.dart';
import '../models/clickup_list_model.dart';

class TasksRepoImpl with GlobalsWriteAccess implements TasksRepo {
  final TasksRemoteDataSource remoteDataSource;
  final TasksLocalDataSource localDataSource;

  TasksRepoImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Failure, List<ClickupTaskModel>>> getTasksInWorkspace(
      {required GetClickupTasksInWorkspaceParams params}) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () async =>
            await remoteDataSource.getTasksInWorkspace(params: params));
  }

  @override
  Future<Either<Failure, ClickupTaskModel>?> createTaskInList(
      ClickupTaskParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () async =>
            await remoteDataSource.createTaskInList(params: params));
  }

  @override
  Future<Either<Failure, ClickupTaskModel>?> updateTask(
      ClickupTaskParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () async =>
            await remoteDataSource.updateTask(params: params));
  }

  @override
  Future<Either<Failure, Unit>?> deleteTask(DeleteClickupTaskParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () async =>
            await remoteDataSource.deleteTask(params: params));
  }

  @override
  Future<Either<Failure, List<ClickupWorkspaceModel>>> getClickupWorkspaces(
      {required GetClickupWorkspacesParams params}) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () async =>
            await remoteDataSource.getClickupWorkspaces(params: params),
        trySaveResult: (result) async {
          clickupWorkspaces = result;
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
    return repoHandleRemoteRequest(
      remoteDataSourceRequest: () =>
          remoteDataSource.getClickupFolders(params: params),
    );
  }

  @override
  Future<Either<Failure, List<ClickupListModel>>> getClickupListsInFolder(
      {required GetClickupListsInFolderParams params}) {
    return repoHandleRemoteRequest(
      remoteDataSourceRequest: () =>
          remoteDataSource.getClickupListsInFolder(params: params),
    );
  }

  @override
  Future<Either<Failure, List<ClickupListModel>>> getClickupFolderlessLists(
      {required GetClickupFolderlessListsInSpaceParams params}) {
    return repoHandleRemoteRequest(
      remoteDataSourceRequest: () =>
          remoteDataSource.getClickupFolderlessLists(params: params),
    );
  }

  @override
  Future<Either<Failure, List<ClickupSpaceModel>>> getClickupSpacesInWorkspaces(
      {required GetClickupSpacesInWorkspacesParams params}) {
    return repoHandleRemoteRequest(
      remoteDataSourceRequest: () =>
          remoteDataSource.getClickupSpacesInWorkspaces(params: params),
    );
  }

  @override
  Future<Either<Failure, List<ClickupTagModel>>> getClickupTags(
      {required GetClickupTagsInSpaceParams params}) {
    return repoHandleRemoteRequest(
      remoteDataSourceRequest: () =>
          remoteDataSource.getClickupTags(params: params),
    );
  }

  @override
  Future<Either<Failure, Unit>> addTagToTask(
      {required AddTagToTaskParams params}) {
    return repoHandleRemoteRequest(
      remoteDataSourceRequest: () =>
          remoteDataSource.addTagToTask(params: params),
    );
  }

  @override
  Future<Either<Failure, Unit>> addTaskToList(
      {required AddTaskToListParams params}) {
    return repoHandleRemoteRequest(
      remoteDataSourceRequest: () =>
          remoteDataSource.addTaskToList(params: params),
    );
  }

  @override
  Future<Either<Failure, Unit>> removeTagFromTask(
      {required RemoveTagFromTaskParams params}) {
    return repoHandleRemoteRequest(
      remoteDataSourceRequest: () =>
          remoteDataSource.removeTagFromTask(params: params),
    );
  }

  @override
  Future<Either<Failure, Unit>> removeTaskFromAdditionalList(
      {required RemoveTaskFromListParams params}) {
    return repoHandleRemoteRequest(
      remoteDataSourceRequest: () =>
          remoteDataSource.removeTaskFromAdditionalList(params: params),
    );
  }

  @override
  Future<Either<Failure, Unit>?> selectWorkspace(
      SelectWorkspaceParams params) async {
    return repoHandleLocalSaveRequest(
        trySaveResult: () => localDataSource.saveSelectedWorkspace(
            params.clickupWorkspace as ClickupWorkspaceModel));
  }

  @override
  Future<Either<Failure, ClickupWorkspaceModel>?> getSelectedWorkspace(
      NoParams params) async {
    var result = await repoHandleLocalGetRequest<ClickupWorkspaceModel>(
        tryGetFromLocalStorage: () => localDataSource.getSelectedWorkspace());
    result.fold((l) => null, (r) => selectedWorkspace = r);
    return result;
  }

  @override
  Future<Either<Failure, ClickupSpace>?> getSelectedSpace(
      NoParams params) async {
    final result = await repoHandleLocalGetRequest<ClickupSpace>(
        tryGetFromLocalStorage: () => localDataSource.getSelectedSpace());
    result.fold((l) => null, (r) {
      setSelectedSpace(r);
    });
    return result;
  }

  @override
  Future<Either<Failure, Unit>?> selectSpace(SelectSpaceParams params) async {
    return repoHandleLocalSaveRequest(
        trySaveResult: () => localDataSource
            .saveSelectedSpace(params.clickupSpace as ClickupSpaceModel));
  }

  @override
  Future<Either<Failure, List<ClickupSpace>>?> getSpacesOfSelectedWorkspace(
      NoParams params) async {
    final result = await repoHandleLocalGetRequest<List<ClickupSpace>>(
        tryGetFromLocalStorage: () => localDataSource.getSpaces());
    result.fold((l) => null, (r) => clickupSpaces = r);
    return result;
  }

  @override
  Future<Either<Failure, Unit>?> saveSpacesOfSelectedWorkspace(
      SaveSpacesParams params) {
    return repoHandleLocalSaveRequest(
        trySaveResult: () => localDataSource
            .saveSpaces(params.clickupSpaces as List<ClickupSpaceModel>));
  }

  @override
  Future<Either<Failure, ClickupListModel>?> getClickupList(
      GetClickupListParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.getClickupList(params: params));
  }

  @override
  Future<Either<Failure, ClickupListModel>?> createClickupListInFolder(
      CreateClickupListInFolderParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.createClickupListInFolder(params: params));
  }

  @override
  Future<Either<Failure, ClickupListModel>?> createFolderlessClickupList(
      CreateFolderlessListClickupParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.createFolderlessClickupList(params: params));
  }

  @override
  Future<Either<Failure, ClickupFolderModel>?> createClickupFolderInSpace(
      CreateClickupFolderInSpaceParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.createClickupFolderInSpace(params: params));
  }

  @override
  Future<Either<Failure, Unit>?> deleteList(DeleteClickupListParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.deleteList(params: params));
  }

  @override
  Future<Either<Failure, Unit>?> deleteFolder(DeleteClickupFolderParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.deleteFolder(params: params));
  }

  @override
  Future<Either<Failure, Unit>?> deleteClickupTag(DeleteClickupTagParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.deleteClickupTag(params: params));
  }

  @override
  Future<Either<Failure, Unit>?> createClickupTagInSpace(
      CreateClickupTagInSpaceParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.createClickupTagInSpace(params: params));
  }

  @override
  Future<Either<Failure, Unit>?> updateClickupTag(
      UpdateClickupTagParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.updateClickupTag(params: params));
  }
}
