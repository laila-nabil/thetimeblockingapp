import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';

import '../../../tasks/domain/entities/clickup_space.dart';


class SaveSpacesUseCase implements UseCase<Unit,SaveSpacesParams>{

  final TasksRepo repo;

  SaveSpacesUseCase(this.repo);
  @override
  Future<Either<Failure, Unit>?> call(SaveSpacesParams params) {
    return repo.saveSpacesOfSelectedWorkspace(params);
  }

}

class SaveSpacesParams{
  final List<ClickupSpace> clickupSpaces;

  SaveSpacesParams(this.clickupSpaces);
}
