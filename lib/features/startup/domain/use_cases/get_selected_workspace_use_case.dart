import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/common/entities/clickup_workspace.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/startup/domain/repositories/startup_repo.dart';

class GetSelectedWorkspaceUseCase
    implements UseCase<ClickupWorkspace, NoParams> {
  final StartUpRepo repo;

  GetSelectedWorkspaceUseCase(this.repo);

  @override
  Future<Either<Failure, ClickupWorkspace>?> call(
      NoParams params) {
    return repo.getSelectedWorkspace(params);
  }
}
