import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_tags_in_space_use_case.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/space.dart';
import 'get_folderless_lists_in_space_use_case.dart';
import 'get_folders_in_space_use_case.dart';

class GetAllInSpaceUseCase with GlobalsWriteAccess{
  final TasksRepo repo;

  GetAllInSpaceUseCase(this.repo);

  Future<dartz.Either<List<Map<String, Failure>>, Space>?> call(
      GetAllInSpaceParams params) async {
    Space space = params.clickupSpace;
    List<Map<String, Failure>> failures = [];
    final tagsResult = await repo.getClickupTags(
        params: GetTagsInSpaceParams(
            accessToken: params.clickupAccessToken,
            space: space));
    tagsResult.fold(
            (l) => failures.add({"tagS": l}),
            (rTags) {
          space.tags = rTags;
        });
    final folderlessLists = await repo.getClickupFolderlessLists(
        params: GetFolderlessListsInSpaceParams(
            clickupAccessToken: params.clickupAccessToken,
            clickupSpace: space,
            archived: params.archived));
    printDebug(
        "GetAllInClickupSpaceUseCase folderlessLists $folderlessLists");
    folderlessLists.fold(
            (l) => failures.add({"folderlessLists": l}),
            (rFolderlessLists) {
          space.lists = rFolderlessLists;
        });
    final folders = await repo.getClickupFolders(
        params: GetFoldersInSpaceParams(
            clickupAccessToken: params.clickupAccessToken,
            clickupSpace: space,
            archived: params.archived));
    printDebug("GetAllInClickupSpaceUseCase folders $folders");
    folders.fold(
            (lFolder) => failures.add({"folders": lFolder}),
            (rFolders) => space.folders = rFolders);
    setSelectedSpace(space);
    if (failures.isEmpty) {
      printDebug(
          "GetAllInSpaceUseCase Globals.selectedSpace ${Globals.selectedSpaceId}");
      await serviceLocator<Analytics>()
          .logEvent(AnalyticsEvents.getData.name, parameters: {
        AnalyticsEventParameter.data.name: "allInSpace",
        AnalyticsEventParameter.status.name: true,
      });
      return dartz.Right(space);
    }
    await serviceLocator<Analytics>()
        .logEvent(AnalyticsEvents.getData.name, parameters: {
      AnalyticsEventParameter.data.name: "allInSpace",
      AnalyticsEventParameter.status.name: false,
      AnalyticsEventParameter.error.name: failures.toString(),
    });
    return dartz.Left(failures);
  }
}

class GetAllInSpaceParams extends Equatable {
  final ClickupAccessToken clickupAccessToken;
  final Space clickupSpace;
  final bool? archived;

  const GetAllInSpaceParams({
    required this.clickupAccessToken,
    required this.clickupSpace,
    this.archived,
  });

  @override
  List<Object?> get props => [clickupAccessToken, clickupSpace, archived];
}
