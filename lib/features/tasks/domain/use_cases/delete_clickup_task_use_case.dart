import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';

import '../../../auth/domain/entities/clickup_access_token.dart';
import '../repositories/tasks_repo.dart';

class DeleteClickupTaskUseCase
    implements UseCase<Unit, DeleteClickupTaskParams> {
  final TasksRepo repo;

  DeleteClickupTaskUseCase(this.repo);
  @override
  Future<Either<Failure, Unit>?> call(DeleteClickupTaskParams params) {
    return repo.deleteTask(params);
  }
}

class DeleteClickupTaskParams {
  final ClickupTask task;
  final ClickupAccessToken clickupAccessToken;
  DeleteClickupTaskParams({required this.task,required this.clickupAccessToken, });

  String get taskId => task.id ?? "";
}
