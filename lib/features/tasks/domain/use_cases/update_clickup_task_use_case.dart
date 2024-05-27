import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/extensions.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task_parameters.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/add_tags_to_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_clickup_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/move_clickup_task_between_lists_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/remove_tags_from_task_use_case.dart';
import '../../../../core/print_debug.dart';
import '../repositories/tasks_repo.dart';

class UpdateClickupTaskUseCase implements UseCase<Unit, ClickupTaskParams> {
  final TasksRepo repo;
  final AddTagsToTaskUseCase addTagsToTaskUseCase;
  final RemoveTagsFromTaskUseCase removeTagsFromTaskUseCase;
  final MoveClickupTaskBetweenListsUseCase moveClickupTaskBetweenListsUseCase;
  final CreateClickupTaskUseCase createClickupTaskUseCase;
  final DeleteClickupTaskUseCase deleteClickupTaskUseCase;

  UpdateClickupTaskUseCase(
      this.repo,
      this.addTagsToTaskUseCase,
      this.removeTagsFromTaskUseCase,
      this.moveClickupTaskBetweenListsUseCase,
      this.createClickupTaskUseCase,
      this.deleteClickupTaskUseCase);

  @override
  Future<Either<Failure, Unit>?> call(ClickupTaskParams params) async {
    Either<Failure, ClickupTask>? updateTaskResult;
    List<Failure> failures = [];
    printDebug("params $params");
    final isCompletingTask = params.taskStatus != null &&
        params.taskStatus == Globals.selectedSpace?.statuses?.last;
    final eventName = isCompletingTask
        ? AnalyticsEvents.completeTask.name
        : AnalyticsEvents.updateTask.name;
    final task = params.task;
    if (params.clickupList == task?.list || params.clickupList == null) {
      final taskTags = task?.tags;
      final newTags = params.tags;
      if (newTags != taskTags) {
        List<ClickupTag> addTags = newTags
                ?.where((element) => taskTags?.contains(element) == false)
                .toList() ??
            [];
        List<ClickupTag> removeTags = taskTags
                ?.where((element) => newTags?.contains(element) == false)
                .toList() ??
            [];
        final addTagsResult = await addTagsToTaskUseCase(AddTagsToTaskParams(
            task: task!,
            tags: addTags,
            clickupAccessToken: params.clickupAccessToken));
        addTagsResult?.fold((l) => failures.add(l), (r) => null);
        printDebug("addTagsResult $addTagsResult");
        final removeTagsResult = await removeTagsFromTaskUseCase(
            RemoveTagsFromTaskParams(
                task: task,
                tags: removeTags,
                clickupAccessToken: params.clickupAccessToken));
        removeTagsResult?.fold((l) => failures.add(l), (r) => null);
        printDebug("removeTagsResult $removeTagsResult");
      }
      updateTaskResult = await repo.updateTask(params);
      updateTaskResult?.fold((l) => failures.add(l), (r) => null);
      printDebug("updateTaskResult $updateTaskResult");
      printDebug("failures $failures");
      if (failures.isNotEmpty) {
        await serviceLocator<Analytics>().logEvent(
            eventName,
            parameters: {
              AnalyticsEventParameter.status.name: false,
              AnalyticsEventParameter.error.name: failures.toString(),
            });
        return Left(FailuresList(failures: failures));
      }
      await serviceLocator<Analytics>()
          .logEvent(eventName, parameters: {
        AnalyticsEventParameter.status.name: true,
      });
      return const Right(unit);
    } else {
      Either<Failure, ClickupTask>? createTask;
      Either<Failure, Unit>? deleteOldTask;
      try {
        createTask = await createClickupTaskUseCase(
                  ClickupTaskParams.createNewTask(
                      clickupAccessToken: params.clickupAccessToken,
                      clickupList: (params.clickupList ?? task?.list)!,
                      title: params.title?? task?.name?? "",
                      space: (params.clickupSpace ?? task?.space)!,
                      tags: params.tags ?? task?.tags,
                      description: params.description ?? task?.description,
                      dueDate: params.dueDate ?? task?.dueDateUtc,
                      folder: params.folder ?? task?.folder,
                      taskStatus: params.taskStatus ?? task?.status,
                      taskPriority: params.taskPriority ?? task?.priority,
                      startDate: params.startDate ?? task?.startDateUtc,
                      timeEstimate: params.timeEstimate ?? task?.timeEstimate,
                      notifyAll: params.notifyAll,
                      requiredCustomFields: params.requiredCustomFields,
                parentTask: (params.parentTask != null)
                    ? params.parentTask
                    : (task?.parent != null)
                        ? ClickupTask(id: task?.parent ?? "")
                        : null,
                linkedTask: params.linkedTask ?? ((task?.linkedTasks != null)
                          ? ClickupTask(id: task?.linkedTasks?.tryElementAt(0) ?? "")
                          : null),
              ));
        await createTask?.fold((l) async => failures.add(l), (r) async {
          deleteOldTask = await deleteClickupTaskUseCase(DeleteClickupTaskParams(
              task: task!, clickupAccessToken: params.clickupAccessToken));
          deleteOldTask?.fold((l) => failures.add(l), (r) => null);
        });
      } catch (e) {
        printDebug("createTask === $e $createTask");
      }
      if (failures.isNotEmpty || createTask == null) {
        return Left(FailuresList(failures: failures));
      }
      return const Right(unit);
    }
  }
}
