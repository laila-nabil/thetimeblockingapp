import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task_parameters.dart';
import '../repositories/tasks_repo.dart';

class UpdateClickupTaskUseCase
    implements UseCase<ClickupTask, ClickupTaskParams> {
  final TasksRepo repo;

  UpdateClickupTaskUseCase(this.repo);

  @override
  Future<Either<Failure, ClickupTask>?> call(ClickupTaskParams params) {
    return repo.updateTask(params);
  }
}
