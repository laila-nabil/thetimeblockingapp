import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';

import '../entities/task_parameters.dart';
import '../repositories/tasks_repo.dart';

///TODO add note or attachment with link to task url in timeblockingapp for quick access
///TODO enable navigation to specific task with task id
///TODO have brain dump/ inbox or default list

class CreateClickupTaskUseCase
    implements UseCase<ClickupTask, ClickupTaskParams> {
  final TasksRepo repo;

  CreateClickupTaskUseCase(this.repo);

  @override
  Future<Either<Failure, ClickupTask>?> call(ClickupTaskParams params) {
    return repo.createTaskInList(params);
  }
}
