import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/common/entities/priority.dart';
import 'package:thetimeblockingapp/common/entities/status.dart';
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/get_all_in_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/get_priorities_use_case.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/get_statuses_use_case.dart';

import '../../../../common/entities/task.dart';
import '../../../tasks/domain/use_cases/get_tasks_in_single_workspace_use_case.dart';
import '../use_cases/get_workspaces_use_case.dart';

abstract class GlobalRepo {

  Future<dartz.Either<Failure, List<Task>>> getTasksInWorkspace(
      {required GetTasksInWorkspaceParams params});


  Future<dartz.Either<Failure, List<Workspace>>> getWorkspaces(
      {required GetWorkspacesParams params});

  Future<dartz.Either<Failure, Workspace>> getAllInWorkspace(
      {required GetAllInWorkspaceParams params});

  Future<dartz.Either<Failure, List<TaskStatus>>> getStatuses(
      GetStatusesParams params);

  Future<dartz.Either<Failure, List<TaskPriority>>> getPriorities(
      GetPrioritiesParams params);
}
