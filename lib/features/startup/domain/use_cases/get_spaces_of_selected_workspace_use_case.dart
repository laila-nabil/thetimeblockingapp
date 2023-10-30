import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/common/entities/clickup_workspace.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';

class GetSpacesOfSelectedWorkspaceUseCase
    implements UseCase<ClickupWorkspace, NoParams> {
  final TasksRepo repo;

  GetSpacesOfSelectedWorkspaceUseCase(this.repo);

  @override
  Future<Either<Failure, ClickupWorkspace>?> call(
      NoParams params) {
    return repo.getSelectedWorkspace(params);
  }
}
