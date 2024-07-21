import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import '../../../auth/domain/entities/access_token.dart';
import '../entities/folder.dart';
import '../entities/space.dart';

class GetFoldersInSpaceUseCase
    implements UseCase<List<Folder>, GetFoldersInSpaceParams> {
  final TasksRepo repo;

  GetFoldersInSpaceUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, List<Folder>>?> call(
      GetFoldersInSpaceParams params) {
    return repo.getFolders(params: params);
  }
}

class GetFoldersInSpaceParams extends Equatable {
  final AccessToken clickupAccessToken;
  final Space clickupSpace;
  final bool? archived;

  const GetFoldersInSpaceParams({
    required this.clickupAccessToken,
    required this.clickupSpace,
    this.archived,
  });

  @override
  List<Object?> get props => [clickupAccessToken, clickupSpace,archived];
}
