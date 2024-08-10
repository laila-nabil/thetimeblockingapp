import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_tags_in_space_use_case.dart';
import '../../../../common/entities/access_token.dart';
import '../../../../common/entities/space.dart';
import 'get_folderless_lists_in_space_use_case.dart';
import 'get_folders_in_space_use_case.dart';

class GetAllInSpaceUseCase with GlobalsWriteAccess{
  final TasksRepo repo;

  GetAllInSpaceUseCase(this.repo);

  Future<dartz.Either<List<Map<String, Failure>>, Space>?> call(
      GetAllInSpaceParams params) async {
    Space space = params.space;
    List<Map<String, Failure>> failures = [];
    final tagsResult = await repo.getTags(
        params: GetTagsInSpaceParams(
            accessToken: params.accessToken,
            space: space));
    tagsResult.fold(
            (l) => failures.add({"tagS": l}),
            (rTags) {
          space = space.copyWith(tags : rTags);
        });
    final folderlessLists = await repo.getFolderlessLists(
        params: GetFolderlessListsInSpaceParams(
            accessToken: params.accessToken,
            space: space,
            archived: params.archived));
    printDebug(
        "GetAllInSpaceUseCase folderlessLists $folderlessLists");
    folderlessLists.fold(
            (l) => failures.add({"folderlessLists": l}),
            (rFolderlessLists) {
          space = space.copyWith(lists : rFolderlessLists);
        });
    final folders = await repo.getFolders(
        params: GetFoldersInSpaceParams(
            accessToken: params.accessToken,
            space: space,
            archived: params.archived));
    printDebug("GetAllInSpaceUseCase folders $folders");
    folders.fold(
            (lFolder) => failures.add({"folders": lFolder}),
            (rFolders) => space = space.copyWith(folders : rFolders));
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
  final AccessToken accessToken;
  final Space space;
  final bool? archived;

  const GetAllInSpaceParams({
    required this.accessToken,
    required this.space,
    this.archived,
  });

  @override
  List<Object?> get props => [accessToken, space, archived];
}
