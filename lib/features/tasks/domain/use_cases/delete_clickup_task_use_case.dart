import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';

import '../../../auth/domain/entities/clickup_access_token.dart';
import '../repositories/tasks_repo.dart';

class DeleteClickUpTaskUseCase
    implements UseCase<Unit, DeleteClickUpTaskParams> {
  final TasksRepo repo;

  DeleteClickUpTaskUseCase(this.repo);
  @override
  Future<Either<Failure, Unit>?> call(DeleteClickUpTaskParams params) {
    return repo.deleteTask(params);
  }
}

class DeleteClickUpTaskParams {
  final ClickupTask task;
  final ClickUpAccessToken clickUpAccessToken;
  DeleteClickUpTaskParams({required this.task,required this.clickUpAccessToken, });

  String get taskId => task.id ?? "";
}
