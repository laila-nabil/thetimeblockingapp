import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_tags_in_space_use_case.dart';
import '../../../auth/domain/entities/access_token.dart';
import '../entities/space.dart';
import 'get_folderless_lists_in_space_use_case.dart';
import 'get_folders_in_space_use_case.dart';
import 'get_spaces_in_workspace_use_case.dart';

class GetAllInWorkspaceUseCase with GlobalsWriteAccess {
  final TasksRepo repo;

  GetAllInWorkspaceUseCase(this.repo);

  Future<dartz.Either<List<Map<String, Failure>>, List<Space>>?> call(
      GetAllInWorkspaceParams params) async {
    List<Space> spaces = [];
    List<Map<String, Failure>> failures = [];
    final spacesResult = await repo.getClickupSpacesInWorkspaces(
        params: GetSpacesInWorkspacesParams(
            clickupAccessToken: params.accessToken,
            clickupWorkspace: params.workspace,
            archived: params.archived));
    printDebug("GetAllInClickupWorkspaceUseCase spacesResult $spacesResult");
    await spacesResult.fold((l) async => failures.add({"spaces": l}),
            (rSpace) async {
          spaces = rSpace;
          int indexSpace = 0;
          for (var eSpace in rSpace){
            final tagsResult = await repo.getClickupTags(
                params: GetTagsInSpaceParams(
                    accessToken: params.accessToken,
                    space: eSpace));
            tagsResult.fold(
                    (l) => failures.add({"tagS$indexSpace": l}),
                    (rTags) {
                  spaces[indexSpace].tags = rTags;
                });
            final folderlessLists = await repo.getClickupFolderlessLists(
                params: GetFolderlessListsInSpaceParams(
                    clickupAccessToken: params.accessToken,
                    clickupSpace: eSpace,
                    archived: params.archived));
            printDebug(
                "GetAllInClickupWorkspaceUseCase folderlessLists $folderlessLists");
            folderlessLists.fold(
                    (l) => failures.add({"folderlessLists$indexSpace": l}),
                    (rFolderlessLists) {
                  spaces[indexSpace].lists = rFolderlessLists;
                });
            final folders = await repo.getClickupFolders(
                params: GetFoldersInSpaceParams(
                    clickupAccessToken: params.accessToken,
                    clickupSpace: eSpace,
                    archived: params.archived));
            printDebug("GetAllInClickupWorkspaceUseCase folders $folders");
            folders.fold(
                    (lFolder) => failures.add({"folders$indexSpace": lFolder}),
                    (rFolders) => spaces[indexSpace].folders = rFolders);
            indexSpace++;
          }
        });

    if (spaces.isNotEmpty) {
      clickupSpaces = spaces;
      printDebug(
          "GetAllInClickupWorkspaceUseCase Globals.clickupSpaces ${Globals
              .spaces}");
      await serviceLocator<Analytics>()
          .logEvent(AnalyticsEvents.getData.name, parameters: {
        AnalyticsEventParameter.data.name: "allInWorkspace",
        AnalyticsEventParameter.status.name: true,
      });
      return dartz.Right(spaces);
    }
    await serviceLocator<Analytics>()
        .logEvent(AnalyticsEvents.getData.name, parameters: {
      AnalyticsEventParameter.data.name: "allInWorkspace",
      AnalyticsEventParameter.status.name: false,
      AnalyticsEventParameter.error.name: failures.toString(),
    });
    return dartz.Left(failures);
  }
}

class GetAllInWorkspaceParams extends Equatable {
  final AccessToken accessToken;
  final Workspace workspace;
  final bool? archived;

  const GetAllInWorkspaceParams({
    required this.accessToken,
    required this.workspace,
    this.archived,
  });

  @override
  List<Object?> get props => [accessToken, workspace, archived];
}
