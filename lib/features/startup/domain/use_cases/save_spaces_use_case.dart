import 'package:dartz/dartz.dart' as dartz; 
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';

import '../../../../common/entities/space.dart';


class SaveSpacesUseCase implements UseCase<dartz.Unit,SaveSpacesParams>{

  final TasksRepo repo;

  SaveSpacesUseCase(this.repo);
  @override
  Future<dartz.Either<Failure, dartz.Unit>?> call(SaveSpacesParams params) {
    return repo.saveSpacesOfSelectedWorkspace(params);
  }

}

class SaveSpacesParams{
  final List<Space> spaces;

  SaveSpacesParams(this.spaces);
}
