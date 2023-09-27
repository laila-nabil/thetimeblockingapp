import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/clickup_task.dart';
import '../use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';

abstract class TasksRepo{
  Future<Either<Failure,List<ClickupTask>>> getTasksInWorkspace(
      {required GetClickUpTasksInWorkspaceParams params});
}