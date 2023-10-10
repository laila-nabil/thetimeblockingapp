import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/clickup_workspace.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/clickup_space.dart';
import 'get_clickup_folderless_lists_in_space_use_case.dart';
import 'get_clickup_folders_in_space_use_case.dart';
import 'get_clickup_spaces_in_workspace_use_case.dart';

class GetAllInClickupWorkspaceUseCase {
  final TasksRepo repo;

  GetAllInClickupWorkspaceUseCase(this.repo);

  Future<Either<List<Map<String, Failure>>, List<ClickupSpace>>?> call(
      GetAllInClickupWorkspaceParams params) async {
    List<ClickupSpace> spaces = [];
    List<Map<String, Failure>> failures = [];
    final spacesResult = await repo.getClickupSpacesInWorkspaces(
        params: GetClickupSpacesInWorkspacesParams(
            clickupAccessToken: params.clickupAccessToken,
            clickupWorkspace: params.clickupWorkspace,
            archived: params.archived));
    printDebug("GetAllInClickupWorkspaceUseCase spacesResult $spacesResult");
    await spacesResult.fold((l) async => failures.add({"spaces": l}),
        (rSpace) async {
      spaces = rSpace;
      int indexSpace = 0;
      for (var eSpace in rSpace) {
        final folderlessLists = await repo.getClickupFolderlessLists(
            params: GetClickupFolderlessListsInSpaceParams(
                clickupAccessToken: params.clickupAccessToken,
                clickupSpace: eSpace,
                archived: params.archived));
        printDebug("GetAllInClickupWorkspaceUseCase folderlessLists $folderlessLists");
        folderlessLists.fold(
                (l) => failures.add({"folderlessLists$indexSpace": l}),
                (rFolderlessLists) {
                  spaces[indexSpace].lists = rFolderlessLists;
                });
        final folders = await repo.getClickupFolders(
            params: GetClickupFoldersInSpaceParams(
                clickupAccessToken: params.clickupAccessToken,
                clickupSpace: eSpace,
                archived: params.archived));
        printDebug("GetAllInClickupWorkspaceUseCase folders $folders");
        folders.fold(
            (lFolder) => failures.add({"folders$indexSpace": lFolder}),
            (rFolders) =>  spaces[indexSpace].folders = rFolders);
        indexSpace++;
      }
    });

    if (spaces.isNotEmpty) {
      Globals.clickupSpaces = spaces;
      printDebug("GetAllInClickupWorkspaceUseCase Globals.clickupSpaces ${Globals.clickupSpaces}");
      return Right(spaces);
    }
    return Left(failures);
  }
}

class GetAllInClickupWorkspaceParams extends Equatable {
  final ClickupAccessToken clickupAccessToken;
  final ClickupWorkspace clickupWorkspace;
  final bool? archived;

  const GetAllInClickupWorkspaceParams({
    required this.clickupAccessToken,
    required this.clickupWorkspace,
    this.archived,
  });

  @override
  List<Object?> get props => [clickupAccessToken, clickupWorkspace, archived];
}
