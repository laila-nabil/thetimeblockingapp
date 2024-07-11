import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/common/entities/space.dart';
import '../../../../common/entities/access_token.dart';
import '../../../../common/entities/folder.dart';
import '../../../../common/entities/tasks_list.dart';
import '../repositories/tasks_repo.dart';

class GetListsInFolderUseCase
    implements UseCase<List<TasksList>, GetListsInFolderParams> {
  final TasksRepo repo;

  GetListsInFolderUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, List<TasksList>>?> call(
      GetListsInFolderParams params) {
    return repo.getListsInFolder(params: params);
  }
}

class GetListsInFolderParams extends Equatable {
  final AccessToken accessToken;
  final Space space;
  final Folder folder;
  final bool? archived;

  const GetListsInFolderParams({
    required this.accessToken,
    required this.space,
    required this.folder,
    this.archived,
  });

  @override
  List<Object?> get props =>
      [accessToken, space, folder, archived];
}
