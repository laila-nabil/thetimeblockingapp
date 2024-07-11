import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/common/entities/priority.dart';
import 'package:thetimeblockingapp/common/entities/status.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/features/startup/domain/use_cases/get_priorities_use_case.dart';
import 'package:thetimeblockingapp/features/startup/domain/use_cases/get_statuses_use_case.dart';

abstract class StartUpRepo {
  Future<Either<Failure, List<TaskStatus>>> getStatuses(GetStatusesParams params);

  Future<Either<Failure, List<TaskPriority>>> getPriorities(GetPrioritiesParams params);

}
