import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/folder.dart';
import '../entities/space.dart';

class GetClickupFoldersInSpaceUseCase
    implements UseCase<List<Folder>, GetClickupFoldersInSpaceParams> {
  final TasksRepo repo;

  GetClickupFoldersInSpaceUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, List<Folder>>?> call(
      GetClickupFoldersInSpaceParams params) {
    return repo.getClickupFolders(params: params);
  }
}

class GetClickupFoldersInSpaceParams extends Equatable {
  final ClickupAccessToken clickupAccessToken;
  final Space clickupSpace;
  final bool? archived;

  const GetClickupFoldersInSpaceParams({
    required this.clickupAccessToken,
    required this.clickupSpace,
    this.archived,
  });

  @override
  List<Object?> get props => [clickupAccessToken, clickupSpace,archived];
}
