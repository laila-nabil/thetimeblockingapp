import 'package:dartz/dartz.dart';
import '../../../../common/entities/clickup_workspace.dart';
import '../../../../core/error/failures.dart';
import '../../../tasks/domain/entities/clickup_folder.dart';
import '../use_cases/get_clickup_folders_use_case.dart';
import '../use_cases/get_clickup_workspaces_use_case.dart';

abstract class StartUpRepo {

  Future<Either<Failure, List<ClickupWorkspace>>> getClickupWorkspaces(
      {required GetClickupWorkspacesParams params});

  Future<Either<Failure, List<ClickupFolder>>> getClickupFolders(
      {required GetClickupFoldersParams params});
}
