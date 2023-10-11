import 'package:dartz/dartz.dart';

import '../../../../common/entities/clickup_workspace.dart';
import '../../../../common/models/clickup_workspace_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase.dart';
import '../use_cases/get_selected_workspace_use_case.dart';
import '../use_cases/select_workspace_use_case.dart';

abstract class StartUpRepo {
  Future<Either<Failure, ClickupWorkspace>?> selectWorkspace(
      ClickupWorkspace params);

  Future<Either<Failure, ClickupWorkspace>?> getSelectedWorkspace(
      NoParams params);
}
