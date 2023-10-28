import 'package:dartz/dartz.dart';
import '../../../../common/entities/clickup_workspace.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase.dart';
import '../../../tasks/domain/entities/clickup_space.dart';
import '../use_cases/select_space_use_case.dart';
import '../use_cases/select_workspace_use_case.dart';

abstract class StartUpRepo {
  Future<Either<Failure, Unit>?> selectWorkspace(
      SelectWorkspaceParams params);

  Future<Either<Failure, ClickupWorkspace>?> getSelectedWorkspace(
      NoParams params);

  Future<Either<Failure, Unit>?> selectSpace(
      SelectSpaceParams params);

  Future<Either<Failure, ClickupSpace>?> getSelectedSpace(
      NoParams params);
}
