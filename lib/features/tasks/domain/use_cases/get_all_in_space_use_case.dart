import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_clickup_tags_in_space_use_case.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/clickup_space.dart';
import 'get_clickup_folderless_lists_in_space_use_case.dart';
import 'get_clickup_folders_in_space_use_case.dart';

class GetAllInClickupSpaceUseCase {
  final TasksRepo repo;

  GetAllInClickupSpaceUseCase(this.repo);

  Future<Either<List<Map<String, Failure>>, ClickupSpace>?> call(
      GetAllInClickupSpaceParams params) async {
    ClickupSpace space = params.clickupSpace;
    List<Map<String, Failure>> failures = [];
    final tagsResult = await repo.getClickupTags(
        params: GetClickupTagsInSpaceParams(
            clickupAccessToken: params.clickupAccessToken,
            clickupSpace: space));
    tagsResult.fold(
            (l) => failures.add({"tagS": l}),
            (rTags) {
          space.tags = rTags;
        });
    final folderlessLists = await repo.getClickupFolderlessLists(
        params: GetClickupFolderlessListsInSpaceParams(
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
        params: GetClickupFoldersInSpaceParams(
            clickupAccessToken: params.clickupAccessToken,
            clickupSpace: space,
            archived: params.archived));
    printDebug("GetAllInClickupSpaceUseCase folders $folders");
    folders.fold(
            (lFolder) => failures.add({"folders": lFolder}),
            (rFolders) => space.folders = rFolders);
    Globals.selectedSpace = space;
    if (failures.isEmpty) {
      printDebug(
          "GetAllInSpaceUseCase Globals.selectedSpace ${Globals.selectedSpace}");
      return Right(space);
    }
    return Left(failures);
  }
}

class GetAllInClickupSpaceParams extends Equatable {
  final ClickupAccessToken clickupAccessToken;
  final ClickupSpace clickupSpace;
  final bool? archived;

  const GetAllInClickupSpaceParams({
    required this.clickupAccessToken,
    required this.clickupSpace,
    this.archived,
  });

  @override
  List<Object?> get props => [clickupAccessToken, clickupSpace, archived];
}
