import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_task_use_case.dart';

import '../../../../core/error/failures.dart';
import '../entities/clickup_task.dart';
import '../entities/task_parameters.dart';
import '../use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';

abstract class TasksRepo{
  Future<Either<Failure,List<ClickupTask>>> getTasksInWorkspace(
      {required GetClickUpTasksInWorkspaceParams params});

  Future<Either<Failure, ClickupTask>?> createTaskInList(
      ClickUpTaskParams params);

  Future<Either<Failure, ClickupTask>?> updateTask(
      ClickUpTaskParams params);

  Future<Either<Failure, Unit>?> deleteTask(
      DeleteClickUpTaskParams params);
}