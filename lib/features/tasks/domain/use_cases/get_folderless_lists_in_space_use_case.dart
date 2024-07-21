import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/space.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import '../../../auth/domain/entities/access_token.dart';
import '../entities/tasks_list.dart';

class GetFolderlessListsInSpaceUseCase
    implements UseCase<List<TasksList>, GetFolderlessListsInSpaceParams> {
  final TasksRepo repo;

  GetFolderlessListsInSpaceUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, List<TasksList>>?> call(
      GetFolderlessListsInSpaceParams params) {
    return repo.getClickupFolderlessLists(params: params);
  }
}

class GetFolderlessListsInSpaceParams extends Equatable {
  final AccessToken clickupAccessToken;
  final Space clickupSpace;
  final bool? archived;

  const GetFolderlessListsInSpaceParams({
    required this.clickupAccessToken,
    required this.clickupSpace,
    this.archived,
  });

  @override
  List<Object?> get props => [clickupAccessToken, clickupSpace,archived];
}
