import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/common/entities/clickup_workspace.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/startup/domain/repositories/startup_repo.dart';


class SelectWorkspaceUseCase implements UseCase<Unit,SelectWorkspaceParams>{

  final StartUpRepo repo;

  SelectWorkspaceUseCase(this.repo);
  @override
  Future<Either<Failure, Unit>?> call(SelectWorkspaceParams params) {
    return repo.selectWorkspace(params);
  }

}

class SelectWorkspaceParams{
  final ClickupWorkspace clickupWorkspace;

  SelectWorkspaceParams(this.clickupWorkspace);
}
