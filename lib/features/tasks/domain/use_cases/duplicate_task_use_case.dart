import 'dart:async';

import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/common/entities/status.dart';
import 'package:thetimeblockingapp/common/entities/tag.dart';
import 'package:thetimeblockingapp/common/enums/backend_mode.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/add_tag_to_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_tasks_in_single_workspace_use_case.dart';

import '../entities/task_parameters.dart';
import '../repositories/tasks_repo.dart';


class DuplicateTaskUseCase {
  final TasksRepo repo;

  DuplicateTaskUseCase(this.repo);


  Future<dartz.Either<Failure, dartz.Unit>?> call(DuplicateTaskParams params,
      int workspaceId) async {
    final result = await repo.createTaskInList(params.createTaskParams.copyWith(
      taskStatus: params.todoTaskStatus
    ));
    await result?.fold(
        (l) async =>unawaited(serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.duplicateTask.name, parameters: {
              AnalyticsEventParameter.status.name: false,
              AnalyticsEventParameter.error.name: l.toString(),
            })),
        (r) async {
          final newTasks = await repo.getTasksInWorkspace(
              params: GetTasksInWorkspaceParams(
                  workspaceId: workspaceId,
                  filtersParams: const GetTasksInWorkspaceFiltersParams(
                      ),
                  backendMode: serviceLocator<BackendMode>().mode));
          await newTasks.fold((l)async{}, (tasks) async {
        final task = tasks.lastOrNull;
        if (params.createTaskParams.tags?.isNotEmpty == true) {
              for (Tag tag in params.createTaskParams.tags ?? []) {
                final addTagResult = await repo.addTagToTask(
                    params: AddTagToTaskParams(
                        task: task!,
                        tag: tag,
                         user: params.createTaskParams.user));
                addTagResult.fold((l) => printDebug("addTagResult failed $l"),
                        (r) => printDebug("addTagResult success $r"));
              }
            }
          });

          

      unawaited(serviceLocator<Analytics>().logEvent(
              AnalyticsEvents.duplicateTask.name,
              parameters: {AnalyticsEventParameter.status.name: true}));
        });
    return result;
  }
}

class DuplicateTaskParams {
  final CreateTaskParams createTaskParams;
  final TaskStatus? todoTaskStatus;

  DuplicateTaskParams({required this.createTaskParams,required this.todoTaskStatus});
}