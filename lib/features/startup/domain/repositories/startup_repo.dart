import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_list.dart';
import '../../../../common/entities/clickup_workspace.dart';
import '../../../../core/error/failures.dart';
import '../../../tasks/domain/entities/clickup_folder.dart';
import '../use_cases/get_clickup_folderless_lists_use_case.dart';
import '../use_cases/get_clickup_folders_use_case.dart';
import '../use_cases/get_clickup_lists_in_folder_use_case.dart';
import '../use_cases/get_clickup_workspaces_use_case.dart';

abstract class StartUpRepo {

  Future<Either<Failure, List<ClickupWorkspace>>> getClickupWorkspaces(
      {required GetClickupWorkspacesParams params});

  Future<Either<Failure, List<ClickupFolder>>> getClickupFolders(
      {required GetClickupFoldersParams params});

  Future<Either<Failure, List<ClickupList>>> getClickupListsInFolder(
      {required GetClickupListsInFolderParams params});

  Future<Either<Failure, List<ClickupList>>> getClickupFolderlessLists(
      {required GetClickupFolderlessListsParams params});
}
