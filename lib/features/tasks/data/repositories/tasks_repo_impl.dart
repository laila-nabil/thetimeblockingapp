import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/features/tasks/data/data_sources/tasks_remote_data_source.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_clickup_tasks_in_workspace_use_case.dart';

import '../../../../core/repo_handler.dart';

class TasksRepoImpl implements TasksRepo {
  final TasksRemoteDataSource remoteDataSource;

  TasksRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ClickupTask>>> getTasksInWorkspace(
      {required GetClickUpTasksInWorkspaceParams params}) {
    return repoHandler(
        () async => await remoteDataSource.getTasksInWorkspace(params: params));
  }
}