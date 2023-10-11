import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/common/entities/clickup_workspace.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/startup/domain/repositories/startup_repo.dart';

import '../../../../common/models/clickup_workspace_model.dart';

class SelectWorkspaceUseCase implements UseCase<Unit,ClickupWorkspace>{

  final StartUpRepo repo;

  SelectWorkspaceUseCase(this.repo);
  @override
  Future<Either<Failure, Unit>?> call(ClickupWorkspace params) {
    return repo.selectWorkspace(params);
  }

}
