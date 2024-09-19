import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/common/entities/user.dart';
import 'package:thetimeblockingapp/common/enums/backend_mode.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';

import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/common/entities/tasks_list.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task_parameters.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_task_use_case.dart';

import '../../../../common/entities/access_token.dart';

class MoveTaskBetweenListsUseCase
    implements UseCase<dartz.Unit, MoveTaskBetweenListsParams> {
  final TasksRepo repo;

  MoveTaskBetweenListsUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> call(
      MoveTaskBetweenListsParams params) async {
    Task task = params.task;
    dartz.Either<Failure, dartz.Unit>? createResult;
    dartz.Either<Failure, dartz.Unit>? deleteResult;
    createResult = await repo.createTaskInList(CreateTaskParams.createNewTask(

        list: params.newList,
        title: task.title ?? "",
        startDate: task.startDateUtc,
        taskPriority: task.priority,
        taskStatus: task.status,
        workspace: task.workspace,
        folder: task.folder,
        dueDate: task.dueDateUtc,
        description: task.description,
        tags: task.tags,
        backendMode: serviceLocator<BackendMode>().mode, user: params.user));
    if (createResult?.isRight() == true) {
      deleteResult = await repo.deleteTask(DeleteTaskParams(
          task: task, ));
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

class MoveTaskBetweenListsParams {
  final Task task;
  final TasksList newList;

  final User user;

  MoveTaskBetweenListsParams(
      {required this.task,
      required this.newList,

      required this.user,
      });
}
