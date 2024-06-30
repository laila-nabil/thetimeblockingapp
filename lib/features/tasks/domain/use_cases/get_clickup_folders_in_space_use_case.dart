import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/clickup_folder.dart';
import '../entities/clickup_space.dart';

class GetClickupFoldersInSpaceUseCase
    implements UseCase<List<ClickupFolder>, GetClickupFoldersInSpaceParams> {
  final TasksRepo repo;

  GetClickupFoldersInSpaceUseCase(this.repo);

  @override
  Future<Either<Failure, List<ClickupFolder>>?> call(
      GetClickupFoldersInSpaceParams params) {
    return repo.getClickupFolders(params: params);
  }
}

class GetClickupFoldersInSpaceParams extends Equatable {
  final ClickupAccessToken? clickupAccessToken;
  final ClickupSpace? clickupSpace;
  final bool? archived;

  const GetClickupFoldersInSpaceParams({
    required this.clickupAccessToken,
    required this.clickupSpace,
    this.archived,
  });

  @override
  List<Object?> get props => [clickupAccessToken, clickupSpace,archived];
}
