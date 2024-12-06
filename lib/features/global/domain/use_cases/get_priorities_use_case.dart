import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/common/entities/priority.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/global/domain/repositories/global_repo.dart';

class GetPrioritiesUseCase implements UseCase<List<TaskPriority>,GetPrioritiesParams>{
  final GlobalRepo repo;

  GetPrioritiesUseCase(this.repo);
  @override
  Future<Either<Failure, List<TaskPriority>>> call(GetPrioritiesParams params) {
    return repo.getPriorities(params);
  }

}

class GetPrioritiesParams{
  final LanguagesEnum languagesEnum;

  GetPrioritiesParams(this.languagesEnum);
}