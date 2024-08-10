import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/common/entities/space.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import '../../../../common/entities/access_token.dart';
import '../../../../common/entities/tasks_list.dart';

class GetFolderlessListsInSpaceUseCase
    implements UseCase<List<TasksList>, GetFolderlessListsInSpaceParams> {
  final TasksRepo repo;

  GetFolderlessListsInSpaceUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, List<TasksList>>?> call(
      GetFolderlessListsInSpaceParams params) {
    return repo.getFolderlessLists(params: params);
  }
}

class GetFolderlessListsInSpaceParams extends Equatable {
  final AccessToken accessToken;
  final Space space;
  final bool? archived;

  const GetFolderlessListsInSpaceParams({
    required this.accessToken,
    required this.space,
    this.archived,
  });

  @override
  List<Object?> get props => [accessToken, space,archived];
}
