import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/common/enums/backend_mode.dart';
import 'package:thetimeblockingapp/common/models/supabase_folder_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_workspace_model.dart';

import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/features/tasks/data/data_sources/tasks_remote_data_source.dart';


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


import '../../../../common/models/supabase_list_model.dart';
import '../../../../common/models/supabase_space_model.dart';
import '../../../../common/models/supabase_tag_model.dart';
import '../../../../common/models/supabase_task_model.dart';
import '../../../../core/globals.dart';
import '../../../../core/print_debug.dart';
import '../../../../core/repo_handler.dart';
import '../../../../core/usecase.dart';
import '../../../startup/domain/use_cases/save_spaces_use_case.dart';
import '../../../startup/domain/use_cases/select_space_use_case.dart';
import '../../../startup/domain/use_cases/select_workspace_use_case.dart';
import '../../../../common/entities/space.dart';
import '../../domain/entities/task_parameters.dart';
import '../../domain/use_cases/get_folderless_lists_in_space_use_case.dart';
import '../../domain/use_cases/get_folders_in_space_use_case.dart';
import '../../domain/use_cases/get_lists_in_folder_use_case.dart';
import '../../domain/use_cases/get_workspaces_use_case.dart';
import '../data_sources/tasks_local_data_source.dart';

class TasksRepoImpl with GlobalsWriteAccess implements TasksRepo {
  final TasksRemoteDataSource remoteDataSource;
  final TasksLocalDataSource localDataSource;

  TasksRepoImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<dartz.Either<Failure, List<TaskModel>>> getTasksInWorkspace(
      {required GetTasksInWorkspaceParams params}) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () async =>
            await remoteDataSource.getTasksInWorkspace(params: params));
  }

  @override
  Future<dartz.Either<Failure, TaskModel>?> createTaskInList(
      CreateTaskParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () async =>
            await remoteDataSource.createTaskInList(params: params));
  }

  @override
  Future<dartz.Either<Failure, TaskModel>?> updateTask(
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
  Future<dartz.Either<Failure, List<WorkspaceModel>>> getWorkspaces(
      {required GetWorkspacesParams params}) {
    if(Globals.backendMode == BackendMode.supabase){
      return repoHandleRemoteRequest(
          remoteDataSourceRequest: () async =>
          await remoteDataSource.getWorkspaces(params: params),
          trySaveResult: (result) async {
            workspaces = result;
            printDebug(
                "getSupabaseWorkspaces $result ${Globals.workspaces}");
            await localDataSource
                .saveWorkspaces(result);
          },
          tryGetFromLocalStorage: () async =>
          await localDataSource.getWorkspaces());
    }
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () async =>
            await remoteDataSource.getWorkspaces(params: params),
        trySaveResult: (result) async {
          workspaces = result;
          printDebug(
              "getWorkspaces $result ${Globals.workspaces}");
          await localDataSource
              .saveWorkspaces(result);
        },
        tryGetFromLocalStorage: () async =>
            await localDataSource.getWorkspaces());
  }

  @override
  Future<dartz.Either<Failure, List<FolderModel>>> getFolders(
      {required GetFoldersInSpaceParams params}) {
    return repoHandleRemoteRequest(
      remoteDataSourceRequest: () =>
          remoteDataSource.getFolders(params: params),
    );
  }

  @override
  Future<dartz.Either<Failure, List<ListModel>>> getListsInFolder(
      {required GetListsInFolderParams params}) {
    return repoHandleRemoteRequest(
      remoteDataSourceRequest: () =>
          remoteDataSource.getListsInFolder(params: params),
    );
  }

  @override
  Future<dartz.Either<Failure, List<ListModel>>> getFolderlessLists(
      {required GetFolderlessListsInSpaceParams params}) {
    return repoHandleRemoteRequest(
      remoteDataSourceRequest: () =>
          remoteDataSource.getFolderlessLists(params: params),
    );
  }

  @override
  Future<dartz.Either<Failure, List<SpaceModel>>> getSpacesInWorkspaces(
      {required GetSpacesInWorkspacesParams params}) {
    return repoHandleRemoteRequest(
      remoteDataSourceRequest: () =>
          remoteDataSource.getSpacesInWorkspaces(params: params),
    );
  }

  @override
  Future<dartz.Either<Failure, List<TagModel>>> getTags(
      {required GetTagsInSpaceParams params}) {
    return repoHandleRemoteRequest(
      remoteDataSourceRequest: () =>
          remoteDataSource.getTags(params: params),
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
            params.workspace as WorkspaceModel));
  }

  @override
  Future<dartz.Either<Failure, WorkspaceModel>?> getSelectedWorkspace(
      NoParams params) async {
    var result = await repoHandleLocalGetRequest<WorkspaceModel>(
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
            .saveSelectedSpace(params.space as SpaceModel));
  }

  @override
  Future<dartz.Either<Failure, List<Space>>?> getSpacesOfSelectedWorkspace(
      NoParams params) async {
    final result = await repoHandleLocalGetRequest<List<Space>>(
        tryGetFromLocalStorage: () => localDataSource.getSpaces());
    result.fold((l) => null, (r) => setSpaces = r);
    return result;
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> saveSpacesOfSelectedWorkspace(
      SaveSpacesParams params) {
    return repoHandleLocalSaveRequest(
        trySaveResult: () => localDataSource
            .saveSpaces(params.spaces as List<SpaceModel>));
  }

  @override
  Future<dartz.Either<Failure, ListModel>?> getList(
      GetListParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.getList(params: params));
  }

  @override
  Future<dartz.Either<Failure, ListModel>?> createListInFolder(
      CreateListInFolderParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.createListInFolder(params: params));
  }

  @override
  Future<dartz.Either<Failure, ListModel>?> createFolderlessList(
      CreateFolderlessListParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.createFolderlessList(params: params));
  }

  @override
  Future<dartz.Either<Failure, FolderModel>?> createFolderInSpace(
      CreateFolderInSpaceParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.createFolderInSpace(params: params));
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
  Future<dartz.Either<Failure, dartz.Unit>?> deleteTag(DeleteTagParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.deleteTag(params: params));
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> createTagInSpace(
      CreateTagInSpaceParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.createTagInSpace(params: params));
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> updateTag(
      UpdateTagParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.updateTag(params: params));
  }
}
