import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/features/tasks/data/data_sources/tasks_remote_data_source.dart';
import 'package:thetimeblockingapp/features/tasks/data/models/clickup_task_model.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_clickup_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/update_clickup_task_use_case.dart';

import '../../../../core/repo_handler.dart';

class TasksRepoImpl implements TasksRepo {
  final TasksRemoteDataSource remoteDataSource;

  TasksRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ClickupTaskModel>>> getTasksInWorkspace(
      {required GetClickUpTasksInWorkspaceParams params}) {
    return repoHandler(
        remoteDataSourceRequest: () async =>
            await remoteDataSource.getTasksInWorkspace(params: params));
  }

  @override
  Future<Either<Failure, ClickupTaskModel>?> createTaskInList(
      CreateClickUpTaskParams params) {
    return repoHandler(
        remoteDataSourceRequest: () async =>
            await remoteDataSource.createTaskInList(params: params));
  }

  @override
  Future<Either<Failure, ClickupTask>?> updateTask(
      UpdateClickUpTaskParams params) {
    return repoHandler(
        remoteDataSourceRequest: () async =>
        await remoteDataSource.updateTask(params: params));
  }
}
