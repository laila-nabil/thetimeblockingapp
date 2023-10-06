import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/update_clickup_task_use_case.dart';

import '../../../../core/error/failures.dart';
import '../entities/clickup_task.dart';
import '../use_cases/create_clickup_task_use_case.dart';
import '../use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';

abstract class TasksRepo{
  Future<Either<Failure,List<ClickupTask>>> getTasksInWorkspace(
      {required GetClickUpTasksInWorkspaceParams params});

  Future<Either<Failure, ClickupTask>?> createTaskInList(
      CreateClickUpTaskParams params);

  Future<Either<Failure, ClickupTask>?> updateTask(
      UpdateClickUpTaskParams params);
}