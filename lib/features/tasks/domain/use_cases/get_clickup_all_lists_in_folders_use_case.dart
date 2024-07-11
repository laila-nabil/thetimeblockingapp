import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/space.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/folder.dart';
import '../entities/tasks_list.dart';
import 'get_clickup_lists_in_folder_use_case.dart';

class GetClickupAllListsInFoldersUseCase
    implements
        UseCase<Map<Folder, List<TasksList>>,
            GetClickupAllListsInFoldersParams> {
  final GetClickupListsInFolderUseCase getClickupListsInFolderUseCase;

  GetClickupAllListsInFoldersUseCase(this.getClickupListsInFolderUseCase);

  @override
  Future<Either<Failure, Map<Folder, List<TasksList>>>?> call(
      GetClickupAllListsInFoldersParams params) async {
    Map<Folder, List<TasksList>> resultRight = {};
    Map<Folder, Failure> resultLeft = {};
    for (var folder in params.clickupFolders) {
      final lists = await getClickupListsInFolderUseCase(
          GetClickupListsInFolderParams(
              clickupAccessToken: params.clickupAccessToken,
              clickupFolder: folder, clickupSpace: params.clickupSpace));
      lists?.fold(
              (l) => resultLeft[folder] = l, (r) => resultRight[folder] = r);
    }
    if (resultRight.isEmpty && resultLeft.isNotEmpty) {
      return Left(resultLeft.entries.first.value);
    }
    return Right(resultRight);
  }
}

class GetClickupAllListsInFoldersParams extends Equatable {
  final ClickupAccessToken clickupAccessToken;
  final Space clickupSpace;
  final List<Folder> clickupFolders;
  final bool? archived;

  const GetClickupAllListsInFoldersParams({
    required this.clickupAccessToken,
    required this.clickupFolders,
    required this.clickupSpace,
    this.archived,
  });

  @override
  List<Object?> get props =>
      [clickupAccessToken, clickupSpace, clickupFolders, archived];
}
