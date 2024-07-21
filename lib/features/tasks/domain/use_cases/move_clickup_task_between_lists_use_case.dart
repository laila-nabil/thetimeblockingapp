import 'package:dartz/dartz.dart' as dartz; 
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/tasks_list.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task_parameters.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_task_use_case.dart';

import '../../../auth/domain/entities/clickup_access_token.dart';

class MoveClickupTaskBetweenListsUseCase
    implements UseCase<dartz.Unit, MoveClickupTaskBetweenListsParams> {
  final TasksRepo repo;

  MoveClickupTaskBetweenListsUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> call(
      MoveClickupTaskBetweenListsParams params) async {
    Task task = params.task;
    dartz.Either<Failure, Task>? createResult;
    dartz.Either<Failure, dartz.Unit>? deleteResult;
    createResult = await repo.createTaskInList(CreateTaskParams.createNewTask(
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
      deleteResult = await repo.deleteTask(DeleteTaskParams(
          task: task, clickupAccessToken: params.clickupAccessToken));
    }
    if (createResult?.isRight() == true && deleteResult?.isRight() == true) {
      await serviceLocator<Analytics>()
          .logEvent(AnalyticsEvents.moveTaskBetweenLists.name, parameters: {
        AnalyticsEventParameter.status.name: true,
      });
      return const dartz.Right(dartz.unit);
    } else {
      List<Failure> failures = [];
      createResult?.fold((l) => failures.add(l), (r) => null);
      deleteResult?.fold((l) => failures.add(l), (r) => null);
      await serviceLocator<Analytics>()
          .logEvent(AnalyticsEvents.moveTaskBetweenLists.name, parameters: {
        AnalyticsEventParameter.status.name: false,
        AnalyticsEventParameter.error.name: failures.toString(),
      });
      return dartz.Left(FailuresList(failures: failures));
    }
  }
}

class MoveClickupTaskBetweenListsParams {
  final Task task;
  final TasksList newList;
  final ClickupAccessToken clickupAccessToken;

  MoveClickupTaskBetweenListsParams(
      {required this.task,
      required this.newList,
      required this.clickupAccessToken});
}
