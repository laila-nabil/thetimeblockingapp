import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/common/entities/access_token.dart';
import 'package:thetimeblockingapp/common/entities/status.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';

import '../repositories/tasks_repo.dart';

class GetStatusesUseCase implements UseCase<List<TaskStatus>,GetStatusesParams>{
  final TasksRepo repo;

  GetStatusesUseCase(this.repo);
  @override
  Future<Either<Failure, List<TaskStatus>>> call(GetStatusesParams params) {
    return repo.getStatuses(params);
  }

}

class GetStatusesParams{
  final AccessToken accessToken;

  GetStatusesParams(this.accessToken);
}