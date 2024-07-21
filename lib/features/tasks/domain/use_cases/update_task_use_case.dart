import 'package:dartz/dartz.dart' as dartz; 
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task_parameters.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/add_tags_to_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/move_task_between_lists_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/remove_tags_from_task_use_case.dart';
import '../../../../core/print_debug.dart';
import '../repositories/tasks_repo.dart';

class UpdateTaskUseCase implements UseCase<dartz.Unit, CreateTaskParams> {
  final TasksRepo repo;
  final AddTagsToTaskUseCase addTagsToTaskUseCase;
  final RemoveTagsFromTaskUseCase removeTagsFromTaskUseCase;
  final MoveTaskBetweenListsUseCase moveClickupTaskBetweenListsUseCase;
  final CreateTaskUseCase createClickupTaskUseCase;
  final DeleteTaskUseCase deleteClickupTaskUseCase;

  UpdateTaskUseCase(
      this.repo,
      this.addTagsToTaskUseCase,
      this.removeTagsFromTaskUseCase,
      this.moveClickupTaskBetweenListsUseCase,
      this.createClickupTaskUseCase,
      this.deleteClickupTaskUseCase);

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> call(CreateTaskParams params) async {
    dartz.Either<Failure, Task>? updateTaskResult;
    List<Failure> failures = [];
    printDebug("params $params");
    final isCompletingTask = params.taskStatus != null &&
        params.taskStatus == Globals.selectedSpace?.statuses?.last;
    final eventName = isCompletingTask
        ? AnalyticsEvents.completeTask.name
        : AnalyticsEvents.updateTask.name;
    final task = params.task;
    printDebug("task?.list ${task?.list}");
    printDebug("params.clickupList ${params.list}");
    if (params.list?.id == task?.list?.id || params.list == null) {
      final taskTags = task?.tags;
      final newTags = params.tags;
      if (newTags != taskTags) {
        List<Tag> addTags = newTags
                ?.where((element) => taskTags?.contains(element) == false)
                .toList() ??
            [];
        List<Tag> removeTags = taskTags
                ?.where((element) => newTags?.contains(element) == false)
                .toList() ??
            [];
        final addTagsResult = await addTagsToTaskUseCase(AddTagsToTaskParams(
            task: task!,
            tags: addTags,
            clickupAccessToken: params.accessToken));
        addTagsResult?.fold((l) => failures.add(l), (r) => null);
        printDebug("addTagsResult $addTagsResult");
        final removeTagsResult = await removeTagsFromTaskUseCase(
            RemoveTagsFromTaskParams(
                task: task,
                tags: removeTags,
                clickupAccessToken: params.accessToken));
        removeTagsResult?.fold((l) => failures.add(l), (r) => null);
        printDebug("removeTagsResult $removeTagsResult");
      }
      updateTaskResult = await repo.updateTask(params);
      updateTaskResult?.fold((l) => failures.add(l), (r) => null);
      printDebug("updateTaskResult $updateTaskResult");
      printDebug("failures $failures");
      if (failures.isNotEmpty) {
        await serviceLocator<Analytics>().logEvent(eventName, parameters: {
          AnalyticsEventParameter.status.name: false,
          AnalyticsEventParameter.error.name: failures.toString(),
        });
        return dartz.Left(FailuresList(failures: failures));
      }
      await serviceLocator<Analytics>().logEvent(eventName, parameters: {
        AnalyticsEventParameter.status.name: true,
      });
      return const dartz.Right(dartz.unit);
    } else {
      await serviceLocator<Analytics>().logEvent(eventName, parameters: {
        AnalyticsEventParameter.status.name: false,
        AnalyticsEventParameter.error.name:'list problem',
      });
      return dartz.Left(FailuresList(
          failures: const [UnknownFailure(message: 'list problem')]));
    }
  }
}
