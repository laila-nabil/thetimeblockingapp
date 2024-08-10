import 'package:dartz/dartz.dart' as dartz; 
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';


class SelectWorkspaceUseCase implements UseCase<dartz.Unit,SelectWorkspaceParams>{

  final TasksRepo repo;

  SelectWorkspaceUseCase(this.repo);
  @override
  Future<dartz.Either<Failure, dartz.Unit>?> call(SelectWorkspaceParams params) {
    return repo.selectWorkspace(params);
  }

}

class SelectWorkspaceParams{
  final Workspace workspace;

  SelectWorkspaceParams(this.workspace);
}
