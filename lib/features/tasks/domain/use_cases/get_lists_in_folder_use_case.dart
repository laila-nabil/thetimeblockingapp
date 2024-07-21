import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/space.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/folder.dart';
import '../entities/tasks_list.dart';
import '../repositories/tasks_repo.dart';

class GetListsInFolderUseCase
    implements UseCase<List<TasksList>, GetListsInFolderParams> {
  final TasksRepo repo;

  GetListsInFolderUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, List<TasksList>>?> call(
      GetListsInFolderParams params) {
    return repo.getClickupListsInFolder(params: params);
  }
}

class GetListsInFolderParams extends Equatable {
  final ClickupAccessToken clickupAccessToken;
  final Space clickupSpace;
  final Folder clickupFolder;
  final bool? archived;

  const GetListsInFolderParams({
    required this.clickupAccessToken,
    required this.clickupSpace,
    required this.clickupFolder,
    this.archived,
  });

  @override
  List<Object?> get props =>
      [clickupAccessToken, clickupSpace, clickupFolder, archived];
}
