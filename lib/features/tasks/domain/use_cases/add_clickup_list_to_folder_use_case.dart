import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_space.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/clickup_folder.dart';
import '../entities/clickup_list.dart';
import '../repositories/tasks_repo.dart';

class AddClickupListToFolderUseCase
    implements UseCase<List<ClickupList>, AddClickupListToFolderParams> {
  final TasksRepo repo;

  AddClickupListToFolderUseCase(this.repo);

  @override
  Future<Either<Failure, List<ClickupList>>?> call(
      AddClickupListToFolderParams params) {
    return repo.addClickupListToFolder(params: params);
  }
}

class AddClickupListToFolderParams extends Equatable {
  final ClickupAccessToken clickupAccessToken;
  final ClickupFolder clickupFolder;
  final bool? archived;

  const AddClickupListToFolderParams({
    required this.clickupAccessToken,
    required this.clickupFolder,
    this.archived,
  });

  @override
  List<Object?> get props =>
      [clickupAccessToken, clickupFolder, archived];
}
