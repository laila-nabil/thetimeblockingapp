import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/auth/domain/repositories/auth_repo.dart';

import '../../../../common/entities/clickup_workspace.dart';

class GetClickUpWorkspacesUseCase implements UseCase<List<ClickupWorkspace>, NoParams> {
  final AuthRepo repo;

  GetClickUpWorkspacesUseCase(this.repo);

  @override
  Future<Either<Failure, List<ClickupWorkspace>>?> call(NoParams params) {
    return repo.getClickUpWorkspaces(params: params);
  }
}
