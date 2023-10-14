import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/clickup_space.dart';

class GetClickupTagsInSpaceUseCase
    implements UseCase<List<ClickupTag>, GetClickupTagsInSpaceParams> {
  final TasksRepo repo;

  GetClickupTagsInSpaceUseCase(this.repo);

  @override
  Future<Either<Failure, List<ClickupTag>>?> call(
      GetClickupTagsInSpaceParams params) {
    return repo.getClickupTags(params: params);
  }
}

class GetClickupTagsInSpaceParams extends Equatable {
  final ClickupAccessToken clickupAccessToken;
  final ClickupSpace clickupSpace;
  final bool? archived;

  const GetClickupTagsInSpaceParams({
    required this.clickupAccessToken,
    required this.clickupSpace,
    this.archived,
  });

  @override
  List<Object?> get props => [clickupAccessToken, clickupSpace,archived];
}
