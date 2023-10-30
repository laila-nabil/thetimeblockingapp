import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task_parameters.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/add_tags_to_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/remove_tags_from_task_use_case.dart';
import '../../../../core/print_debug.dart';
import '../repositories/tasks_repo.dart';

class UpdateClickupTaskUseCase
    implements UseCase<Unit, ClickupTaskParams> {
  final TasksRepo repo;
  final AddTagsToTaskUseCase addTagsToTaskUseCase;
  final RemoveTagsFromTaskUseCase removeTagsFromTaskUseCase;

  UpdateClickupTaskUseCase(
      this.repo, this.addTagsToTaskUseCase, this.removeTagsFromTaskUseCase);

  @override
  Future<Either<Failure, Unit>?> call(ClickupTaskParams params) async {
    Either<Failure, ClickupTask>? updateTaskResult ;
    List<Failure> failures = [];
    final taskTags= params.task?.tags;
    final newTags= params.tags;
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
          task: params.task!,
          tags: addTags,
          clickupAccessToken: params.clickupAccessToken));
      addTagsResult?.fold((l) => failures.add(l), (r) => null);
      printDebug("addTagsResult $addTagsResult");
      final removeTagsResult = await removeTagsFromTaskUseCase(
          RemoveTagsFromTaskParams(
              task: params.task!,
              tags: removeTags,
              clickupAccessToken: params.clickupAccessToken));
      removeTagsResult?.fold((l) => failures.add(l), (r) => null);
      printDebug("removeTagsResult $removeTagsResult");
    }
    updateTaskResult = await repo.updateTask(params);
    updateTaskResult?.fold((l) => failures.add(l), (r) => null);
    printDebug("updateTaskResult $updateTaskResult");
    printDebug("failures $failures");
    if(failures.isNotEmpty){
      return Left(FailuresList(failures: failures));
    }
    return const Right(unit);
  }
}
