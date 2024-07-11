import 'package:dartz/dartz.dart' as dartz; 
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';

import '../../../../common/entities/space.dart';


class SelectSpaceUseCase implements UseCase<dartz.Unit,SelectSpaceParams>{

  final TasksRepo repo;

  SelectSpaceUseCase(this.repo);
  @override
  Future<dartz.Either<Failure, dartz.Unit>?> call(SelectSpaceParams params) {
    return repo.selectSpace(params);
  }

}

class SelectSpaceParams{
  final Space space;

  SelectSpaceParams(this.space);
}
