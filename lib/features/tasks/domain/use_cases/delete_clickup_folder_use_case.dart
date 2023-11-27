import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';

import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/clickup_folder.dart';
import '../repositories/tasks_repo.dart';

class DeleteClickupFolderUseCase
    implements UseCase<Unit, DeleteClickupFolderParams> {
  final TasksRepo repo;

  DeleteClickupFolderUseCase(this.repo);

  @override
  Future<Either<Failure, Unit>?> call(DeleteClickupFolderParams params) {
    return repo.deleteFolder(params);
  }
}

class DeleteClickupFolderParams {
  final ClickupFolder folder;
  final ClickupAccessToken clickupAccessToken;

  DeleteClickupFolderParams({
    required this.folder,
    required this.clickupAccessToken,
  });

  String get folderId => folder.id ?? "";
}
