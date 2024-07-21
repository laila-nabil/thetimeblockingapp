import 'package:dartz/dartz.dart' as dartz; 
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/features/tasks/data/data_sources/tasks_remote_data_source.dart';
import 'package:thetimeblockingapp/features/tasks/data/models/clickup_space_model.dart';
import 'package:thetimeblockingapp/features/tasks/data/models/clickup_task_model.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folder_in_space_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_list_in_folder_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/add_tag_to_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_tag_in_space_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folderless_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_folder_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_tag_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_spaces_in_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_tags_in_space_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_tasks_in_single_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/remove_tag_from_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/update_tag_use_case.dart';

import '../../../../common/models/clickup_workspace_model.dart';
import '../../../../core/globals.dart';
import '../../../../core/print_debug.dart';
import '../../../../core/repo_handler.dart';
import '../../../../core/usecase.dart';
import '../../../startup/domain/use_cases/save_spaces_use_case.dart';
import '../../../startup/domain/use_cases/select_space_use_case.dart';
import '../../../startup/domain/use_cases/select_workspace_use_case.dart';
import '../../domain/entities/space.dart';
import '../../domain/entities/task_parameters.dart';
import '../../domain/use_cases/get_folderless_lists_in_space_use_case.dart';
import '../../domain/use_cases/get_folders_in_space_use_case.dart';
import '../../domain/use_cases/get_lists_in_folder_use_case.dart';
import '../../domain/use_cases/get_workspaces_use_case.dart';
import '../data_sources/tasks_local_data_source.dart';
import '../models/clickup_folder_model.dart';
import '../models/clickup_list_model.dart';

class TasksRepoImpl with GlobalsWriteAccess implements TasksRepo {
  final TasksRemoteDataSource remoteDataSource;
  final TasksLocalDataSource localDataSource;

  TasksRepoImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<dartz.Either<Failure, List<ClickupTaskModel>>> getTasksInWorkspace(
      {required GetTasksInWorkspaceParams params}) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () async =>
            await remoteDataSource.getTasksInWorkspace(params: params));
  }

  @override
  Future<dartz.Either<Failure, ClickupTaskModel>?> createTaskInList(
      CreateTaskParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () async =>
            await remoteDataSource.createTaskInList(params: params));
  }

  @override
  Future<dartz.Either<Failure, ClickupTaskModel>?> updateTask(
      CreateTaskParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () async =>
            await remoteDataSource.updateTask(params: params));
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> deleteTask(DeleteTaskParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () async =>
            await remoteDataSource.deleteTask(params: params));
  }

  @override
  Future<dartz.Either<Failure, List<ClickupWorkspaceModel>>> getClickupWorkspaces(
      {required GetWorkspacesParams params}) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () async =>
            await remoteDataSource.getClickupWorkspaces(params: params),
        trySaveResult: (result) async {
          clickupWorkspaces = result;
          printDebug(
              "getClickUpWorkspaces $result ${Globals.workspaces}");
          await localDataSource.saveClickupWorkspaces(result);
        },
        tryGetFromLocalStorage: () async =>
            await localDataSource.getClickupWorkspaces());
  }

  @override
  Future<dartz.Either<Failure, List<ClickupFolderModel>>> getClickupFolders(
      {required GetFoldersInSpaceParams params}) {
    return repoHandleRemoteRequest(
      remoteDataSourceRequest: () =>
          remoteDataSource.getClickupFolders(params: params),
    );
  }

  @override
  Future<dartz.Either<Failure, List<ClickupListModel>>> getClickupListsInFolder(
      {required GetListsInFolderParams params}) {
    return repoHandleRemoteRequest(
      remoteDataSourceRequest: () =>
          remoteDataSource.getClickupListsInFolder(params: params),
    );
  }

  @override
  Future<dartz.Either<Failure, List<ClickupListModel>>> getClickupFolderlessLists(
      {required GetFolderlessListsInSpaceParams params}) {
    return repoHandleRemoteRequest(
      remoteDataSourceRequest: () =>
          remoteDataSource.getClickupFolderlessLists(params: params),
    );
  }

  @override
  Future<dartz.Either<Failure, List<ClickupSpaceModel>>> getClickupSpacesInWorkspaces(
      {required GetSpacesInWorkspacesParams params}) {
    return repoHandleRemoteRequest(
      remoteDataSourceRequest: () =>
          remoteDataSource.getClickupSpacesInWorkspaces(params: params),
    );
  }

  @override
  Future<dartz.Either<Failure, List<ClickupTagModel>>> getClickupTags(
      {required GetTagsInSpaceParams params}) {
    return repoHandleRemoteRequest(
      remoteDataSourceRequest: () =>
          remoteDataSource.getClickupTags(params: params),
    );
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>> addTagToTask(
      {required AddTagToTaskParams params}) {
    return repoHandleRemoteRequest(
      remoteDataSourceRequest: () =>
          remoteDataSource.addTagToTask(params: params),
    );
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>> removeTagFromTask(
      {required RemoveTagFromTaskParams params}) {
    return repoHandleRemoteRequest(
      remoteDataSourceRequest: () =>
          remoteDataSource.removeTagFromTask(params: params),
    );
  }


  @override
  Future<dartz.Either<Failure, dartz.Unit>?> selectWorkspace(
      SelectWorkspaceParams params) async {
    return repoHandleLocalSaveRequest(
        trySaveResult: () => localDataSource.saveSelectedWorkspace(
            params.clickupWorkspace as ClickupWorkspaceModel));
  }

  @override
  Future<dartz.Either<Failure, ClickupWorkspaceModel>?> getSelectedWorkspace(
      NoParams params) async {
    var result = await repoHandleLocalGetRequest<ClickupWorkspaceModel>(
        tryGetFromLocalStorage: () => localDataSource.getSelectedWorkspace());
    result.fold((l) => null, (r) => selectedWorkspace = r);
    return result;
  }

  @override
  Future<dartz.Either<Failure, Space>?> getSelectedSpace(
      NoParams params) async {
    final result = await repoHandleLocalGetRequest<Space>(
        tryGetFromLocalStorage: () => localDataSource.getSelectedSpace());
    result.fold((l) => null, (r) {
      setSelectedSpace(r);
    });
    return result;
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> selectSpace(SelectSpaceParams params) async {
    return repoHandleLocalSaveRequest(
        trySaveResult: () => localDataSource
            .saveSelectedSpace(params.clickupSpace as ClickupSpaceModel));
  }

  @override
  Future<dartz.Either<Failure, List<Space>>?> getSpacesOfSelectedWorkspace(
      NoParams params) async {
    final result = await repoHandleLocalGetRequest<List<Space>>(
        tryGetFromLocalStorage: () => localDataSource.getSpaces());
    result.fold((l) => null, (r) => clickupSpaces = r);
    return result;
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> saveSpacesOfSelectedWorkspace(
      SaveSpacesParams params) {
    return repoHandleLocalSaveRequest(
        trySaveResult: () => localDataSource
            .saveSpaces(params.clickupSpaces as List<ClickupSpaceModel>));
  }

  @override
  Future<dartz.Either<Failure, ClickupListModel>?> getClickupList(
      GetListParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.getClickupList(params: params));
  }

  @override
  Future<dartz.Either<Failure, ClickupListModel>?> createClickupListInFolder(
      CreateListInFolderParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.createClickupListInFolder(params: params));
  }

  @override
  Future<dartz.Either<Failure, ClickupListModel>?> createFolderlessClickupList(
      CreateFolderlessListParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.createFolderlessClickupList(params: params));
  }

  @override
  Future<dartz.Either<Failure, ClickupFolderModel>?> createClickupFolderInSpace(
      CreateFolderInSpaceParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.createClickupFolderInSpace(params: params));
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> deleteList(DeleteListParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.deleteList(params: params));
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> deleteFolder(DeleteFolderParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.deleteFolder(params: params));
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> deleteClickupTag(DeleteTagParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.deleteClickupTag(params: params));
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> createClickupTagInSpace(
      CreateTagInSpaceParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.createClickupTagInSpace(params: params));
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> updateClickupTag(
      UpdateTagParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.updateClickupTag(params: params));
  }
}
