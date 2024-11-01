import 'dart:async';

import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/common/entities/tag.dart';
import 'package:thetimeblockingapp/common/enums/backend_mode.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';

import '../entities/task_parameters.dart';
import '../repositories/tasks_repo.dart';
import 'add_tag_to_task_use_case.dart';
import 'get_tasks_in_single_workspace_use_case.dart';

///TODO Z add note or attachment with link to task url in timeblockingapp for quick access
///TODO Z enable navigation to specific task with task id

class CreateTaskUseCase {
  final TasksRepo repo;

  CreateTaskUseCase(this.repo);


  Future<dartz.Either<Failure, dartz.Unit>?> call(CreateTaskParams params,int workspaceId) async {
    CreateTaskParams _params = params;
    bool isCreatingNewTask = params.task == null;
    if( isCreatingNewTask && _params.list == null) {
      _params = _params.copyWith(list: params.defaultList);
    }
    final result = await repo.createTaskInList(_params);
    await result?.fold(
            (l) async =>unawaited(serviceLocator<Analytics>()
            .logEvent(AnalyticsEvents.createTask.name, parameters: {
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
            if (params.tags?.isNotEmpty == true) {
              for (Tag tag in params.tags ?? []) {
                final addTagResult = await repo.addTagToTask(
                    params: AddTagToTaskParams(
                        task: task!,
                        tag: tag,
                         user: params.user));
                addTagResult.fold((l) => printDebug("addTagResult failed $l"),
                        (r) => printDebug("addTagResult success $r"));
              }
            }
          });



          unawaited(serviceLocator<Analytics>().logEvent(
              AnalyticsEvents.createTask.name,
              parameters: {AnalyticsEventParameter.status.name: true}));
        });
    return result;
  }
}
