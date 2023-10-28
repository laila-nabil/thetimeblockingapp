import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/startup/domain/repositories/startup_repo.dart';

import '../../../tasks/domain/entities/clickup_space.dart';


class SelectSpaceUseCase implements UseCase<Unit,SelectSpaceParams>{

  final StartUpRepo repo;

  SelectSpaceUseCase(this.repo);
  @override
  Future<Either<Failure, Unit>?> call(SelectSpaceParams params) {
    return repo.selectSpace(params);
  }

}

class SelectSpaceParams{
  final ClickupSpace clickupSpace;

  SelectSpaceParams(this.clickupSpace);
}
