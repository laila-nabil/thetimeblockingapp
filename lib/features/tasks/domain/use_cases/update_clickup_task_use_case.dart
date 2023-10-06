import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';

import '../repositories/tasks_repo.dart';

class UpdateClickUpTaskUseCase
    implements UseCase<ClickupTask, UpdateClickUpTaskParams> {
  final TasksRepo repo;

  UpdateClickUpTaskUseCase(this.repo);
  @override
  Future<Either<Failure, ClickupTask>?> call(UpdateClickUpTaskParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class UpdateClickUpTaskParams {}
