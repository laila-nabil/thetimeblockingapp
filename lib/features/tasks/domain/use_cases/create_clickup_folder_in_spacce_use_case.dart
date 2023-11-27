import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_space.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/clickup_folder.dart';
import '../repositories/tasks_repo.dart';

class CreateClickupFolderInSpaceUseCase
    implements UseCase<ClickupFolder, CreateClickupFolderInSpaceParams> {
  final TasksRepo repo;

  CreateClickupFolderInSpaceUseCase(this.repo);

  @override
  Future<Either<Failure, ClickupFolder>?> call(
      CreateClickupFolderInSpaceParams params) {
    return repo.createClickupFolderInSpace(params);
  }
}

class CreateClickupFolderInSpaceParams extends Equatable {
  final ClickupAccessToken clickupAccessToken;
  final ClickupSpace clickupSpace;
  final String folderName;
  const CreateClickupFolderInSpaceParams({
    required this.clickupAccessToken,
    required this.clickupSpace,
    required this.folderName,
  });

  @override
  List<Object?> get props =>
      [clickupAccessToken, clickupSpace,folderName,];
}
