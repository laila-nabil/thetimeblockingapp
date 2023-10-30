import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';

import '../../../tasks/domain/entities/clickup_space.dart';

class GetSelectedSpaceUseCase
    implements UseCase<ClickupSpace, NoParams> {
  final TasksRepo repo;

  GetSelectedSpaceUseCase(this.repo);

  @override
  Future<Either<Failure, ClickupSpace>?> call(
      NoParams params) {
    return repo.getSelectedSpace(params);
  }
}
