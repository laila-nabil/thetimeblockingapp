import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_space.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/clickup_folder.dart';
import '../entities/clickup_list.dart';
import 'get_clickup_lists_in_folder_use_case.dart';

class GetClickupAllListsInFoldersUseCase
    implements
        UseCase<Map<ClickupFolder, List<ClickupList>>,
            GetClickupAllListsInFoldersParams> {
  final GetClickupListsInFolderUseCase getClickupListsInFolderUseCase;

  GetClickupAllListsInFoldersUseCase(this.getClickupListsInFolderUseCase);

  @override
  Future<Either<Failure, Map<ClickupFolder, List<ClickupList>>>?> call(
      GetClickupAllListsInFoldersParams params) async {
    Map<ClickupFolder, List<ClickupList>> resultRight = {};
    Map<ClickupFolder, Failure> resultLeft = {};
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
  final ClickupSpace clickupSpace;
  final List<ClickupFolder> clickupFolders;
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
