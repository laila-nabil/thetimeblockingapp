import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';

import '../repositories/tasks_repo.dart';

class DeleteClickUpTaskUseCase
    implements UseCase<ClickupTask, DeleteClickUpTaskParams> {
  final TasksRepo repo;

  DeleteClickUpTaskUseCase(this.repo);
  @override
  Future<Either<Failure, ClickupTask>?> call(DeleteClickUpTaskParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class DeleteClickUpTaskParams {}
