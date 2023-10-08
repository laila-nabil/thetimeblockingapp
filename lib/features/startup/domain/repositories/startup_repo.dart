import 'package:dartz/dartz.dart';
import '../../../../common/entities/clickup_workspace.dart';
import '../../../../core/error/failures.dart';
import '../use_cases/get_clickup_workspaces_use_case.dart';

abstract class StartUpRepo {

  Future<Either<Failure, List<ClickupWorkspace>>> getClickUpWorkspaces(
      {required GetClickUpWorkspacesParams params});
}
