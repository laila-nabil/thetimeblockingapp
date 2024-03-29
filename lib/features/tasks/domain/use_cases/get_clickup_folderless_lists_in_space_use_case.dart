import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_space.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/clickup_list.dart';

class GetClickupFolderlessListsInSpaceUseCase
    implements UseCase<List<ClickupList>, GetClickupFolderlessListsInSpaceParams> {
  final TasksRepo repo;

  GetClickupFolderlessListsInSpaceUseCase(this.repo);

  @override
  Future<Either<Failure, List<ClickupList>>?> call(
      GetClickupFolderlessListsInSpaceParams params) {
    return repo.getClickupFolderlessLists(params: params);
  }
}

class GetClickupFolderlessListsInSpaceParams extends Equatable {
  final ClickupAccessToken clickupAccessToken;
  final ClickupSpace clickupSpace;
  final bool? archived;

  const GetClickupFolderlessListsInSpaceParams({
    required this.clickupAccessToken,
    required this.clickupSpace,
    this.archived,
  });

  @override
  List<Object?> get props => [clickupAccessToken, clickupSpace,archived];
}
