import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_list.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task_parameters.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_task_use_case.dart';

import '../../../auth/domain/entities/clickup_access_token.dart';

class MoveClickupTaskBetweenListsUseCase
    implements UseCase<Unit, MoveClickupTaskBetweenListsParams> {
  final TasksRepo repo;

  MoveClickupTaskBetweenListsUseCase(this.repo);

  @override
  Future<Either<Failure, Unit>?> call(
      MoveClickupTaskBetweenListsParams params) async {
    ClickupTask task = params.task;
    Either<Failure, ClickupTask>? createResult;
    Either<Failure, Unit>? deleteResult;
    createResult = await repo.createTaskInList(ClickupTaskParams.createNewTask(
        clickupAccessToken: params.clickupAccessToken,
        clickupList: params.newList,
        title: task.name ?? "",
        startDate: task.startDateUtc,
        taskPriority: task.priority,
        taskStatus: task.status,
        space: task.space,
        folder: task.folder,
        dueDate: task.dueDateUtc,
        description: task.description,
        tags: task.tags));
    if (createResult?.isRight() == true) {
      deleteResult = await repo.deleteTask(DeleteClickupTaskParams(
          task: task, clickupAccessToken: params.clickupAccessToken));
    }
    if (createResult?.isRight() == true && deleteResult?.isRight() == true) {
      return const Right(unit);
    } else {
      List<Failure> failures = [];
      createResult?.fold((l) => failures.add(l), (r) => null);
      deleteResult?.fold((l) => failures.add(l), (r) => null);
      return Left(FailuresList(failures: failures));
    }
  }
}

class MoveClickupTaskBetweenListsParams {
  final ClickupTask task;
  final ClickupList newList;
  final ClickupAccessToken clickupAccessToken;

  MoveClickupTaskBetweenListsParams(
      {required this.task,
      required this.newList,
      required this.clickupAccessToken});
}
