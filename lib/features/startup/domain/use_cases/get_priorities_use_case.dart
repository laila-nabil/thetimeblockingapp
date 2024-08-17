import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/common/entities/access_token.dart';
import 'package:thetimeblockingapp/common/entities/priority.dart';
import 'package:thetimeblockingapp/common/entities/status.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/startup/domain/repositories/startup_repo.dart';

class GetPrioritiesUseCase implements UseCase<List<TaskPriority>,GetPrioritiesParams>{
  final StartUpRepo repo;

  GetPrioritiesUseCase(this.repo);
  @override
  Future<Either<Failure, List<TaskPriority>>> call(GetPrioritiesParams params) {
    return repo.getPriorities(params);
  }

}

class GetPrioritiesParams{
  final AccessToken accessToken;

  GetPrioritiesParams(this.accessToken);
}