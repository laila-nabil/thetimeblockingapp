import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/common/models/access_token_model.dart';

import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/features/tasks/data/data_sources/tasks_remote_data_source.dart';

import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folder_in_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_list_in_folder_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/add_tag_to_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_tag_in_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folderless_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_folder_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_tag_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_tags_in_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/remove_tag_from_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/update_tag_use_case.dart';

import '../../../../common/models/supabase_tag_model.dart';
import '../../../../common/models/supabase_task_model.dart';

import '../../../../core/repo_handler.dart';
import '../../domain/entities/task_parameters.dart';
import '../../domain/use_cases/get_tasks_in_single_workspace_use_case.dart';

class TasksRepoImpl implements TasksRepo {
  final TasksRemoteDataSource remoteDataSource;

  TasksRepoImpl(
    this.remoteDataSource,
  );

  @override
  Future<dartz.Either<Failure, List<TaskModel>>> getTasksInWorkspace(
      {required GetTasksInWorkspaceParams params}) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () async =>
            await remoteDataSource.getTasksInWorkspace(params: params),
        accessToken: params.filtersParams.accessToken.toModel);
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> createTaskInList(
      CreateTaskParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () async =>
            await remoteDataSource.createTaskInList(params: params),
        accessToken: params.accessToken.toModel);
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> updateTask(
      CreateTaskParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () async =>
            await remoteDataSource.updateTask(params: params),
        accessToken: params.accessToken.toModel);
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> deleteTask(
      DeleteTaskParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () async =>
            await remoteDataSource.deleteTask(params: params),
        accessToken: params.accessToken.toModel);
  }

  @override
  Future<dartz.Either<Failure, List<TagModel>>> getTags(
      {required GetTagsInWorkspaceParams params}) {
    return repoHandleRemoteRequest(
      remoteDataSourceRequest: () => remoteDataSource.getTags(params: params),
      accessToken: params.accessToken.toModel,
    );
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>> addTagToTask(
      {required AddTagToTaskParams params}) {
    return repoHandleRemoteRequest(
      remoteDataSourceRequest: () =>
          remoteDataSource.addTagToTask(params: params),
      accessToken: params.accessToken.toModel,
    );
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>> removeTagFromTask(
      {required RemoveTagFromTaskParams params}) {
    return repoHandleRemoteRequest(
      remoteDataSourceRequest: () =>
          remoteDataSource.removeTagFromTask(params: params),
      accessToken: params.accessToken.toModel,
    );
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> createListInFolder(
      CreateListInFolderParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.createListInFolder(params: params),
        accessToken: params.accessToken.toModel);
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> createFolderlessList(
      CreateFolderlessListParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.createFolderlessList(params: params),
        accessToken: params.accessToken.toModel);
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> createFolderInWorkspace(
      CreateFolderInSpaceParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.createFolderInWorkspace(params: params),
        accessToken: params.accessToken.toModel);
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> deleteList(
      DeleteListParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.deleteList(params: params),
        accessToken: params.accessToken.toModel);
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> deleteFolder(
      DeleteFolderParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.deleteFolder(params: params),
        accessToken: params.accessToken.toModel);
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> deleteTag(DeleteTagParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.deleteTag(params: params),
        accessToken: params.accessToken.toModel);
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> createTagInWorkspace(
      CreateTagInWorkspaceParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.createTagInWorkspace(params: params),
        accessToken: params.accessToken.toModel);
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> updateTag(UpdateTagParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.updateTag(params: params),
        accessToken: params.accessToken.toModel);
  }
}
