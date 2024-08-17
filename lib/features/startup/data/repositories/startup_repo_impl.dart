import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/common/entities/status.dart';
import 'package:thetimeblockingapp/common/models/priority_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_status_model.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/core/repo_handler.dart';
import 'package:thetimeblockingapp/features/startup/domain/use_cases/get_priorities_use_case.dart';
import 'package:thetimeblockingapp/features/startup/domain/use_cases/get_statuses_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/data/data_sources/tasks_local_data_source.dart';
import '../../domain/repositories/startup_repo.dart';
import '../data_sources/startup_remote_data_source.dart';

class StartUpRepoImpl with GlobalsWriteAccess implements StartUpRepo {
  final StartUpRemoteDataSource startUpRemoteDataSource;
  final TasksLocalDataSource tasksLocalDataSource;

  StartUpRepoImpl(
    this.startUpRemoteDataSource,
    this.tasksLocalDataSource,
  );

  @override
  Future<Either<Failure, List<TaskStatusModel>>> getStatuses(GetStatusesParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () async {
          var result = await startUpRemoteDataSource.getStatuses(params);
          Globals.statuses = result;
          printDebug("Globals.statuses now ${Globals.statuses}");
          return result;
        });
  }

  @override
  Future<Either<Failure, List<TaskPriorityModel>>> getPriorities(GetPrioritiesParams params) {
    return repoHandleRemoteRequest(
        remoteDataSourceRequest: () async {
          var result = await startUpRemoteDataSource.getPriorities(params);
          Globals.priorities = result;
          printDebug("Globals.priorities now ${Globals.priorities}");
          return result;
        });
  }


}
