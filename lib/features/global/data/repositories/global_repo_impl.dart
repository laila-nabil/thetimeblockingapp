import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/common/models/supabase_status_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_task_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_workspace_model.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/core/repo_handler.dart';
import 'package:thetimeblockingapp/features/global/data/data_sources/global_remote_data_source.dart';
import 'package:thetimeblockingapp/features/global/domain/repositories/global_repo.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/get_all_in_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/get_priorities_use_case.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/get_statuses_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_tasks_in_single_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/get_workspaces_use_case.dart';

import '../../../../common/models/priority_model.dart';

class GlobalRepoImpl implements GlobalRepo {
  final GlobalRemoteDataSource remoteDataSource;

  GlobalRepoImpl(this.remoteDataSource);

  @override
  Future<dartz.Either<Failure, List<TaskModel>>> getTasksInWorkspace(
      {required GetTasksInWorkspaceParams params}) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () async =>
            await remoteDataSource.getTasksInWorkspace(params: params));
  }

  @override
  Future<dartz.Either<Failure, List<TaskStatusModel>>> getStatuses(
      GetStatusesParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () => remoteDataSource.getStatuses(params));
  }

  @override
  Future<dartz.Either<Failure, List<TaskPriorityModel>>> getPriorities(
      GetPrioritiesParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () => remoteDataSource.getPriorities(params));
  }

  @override
  Future<dartz.Either<Failure, Workspace>> getAllInWorkspace(
      {required GetAllInWorkspaceParams params}) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () =>
            remoteDataSource.getAllInWorkspace(params: params));
  }

  @override
  Future<dartz.Either<Failure, List<WorkspaceModel>>> getWorkspaces(
      {required GetWorkspacesParams params}) {
    return repoHandleRemoteRequest(
      remoteDataSourceRequest: () => remoteDataSource.getWorkspaces(params: params),
    );
  }
}
