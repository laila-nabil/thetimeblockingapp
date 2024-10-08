import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/common/entities/user.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/add_tag_to_task_use_case.dart';

import '../../../../common/entities/tag.dart';

class AddTagsToTaskUseCase implements UseCase<dartz.Unit, AddTagsToTaskParams> {
  final AddTagToTaskUseCase addTagFromTaskUseCase;

  AddTagsToTaskUseCase(this.addTagFromTaskUseCase);

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> call(AddTagsToTaskParams params) async {
    List<dartz.Either<Failure, dartz.Unit>?> result = [];
    for (var element in params.tags) {
      final elementResult = await addTagFromTaskUseCase(AddTagToTaskParams(
          task: params.task,
          tag: element, user: params.user));
      result.add(elementResult);
    }
    if (result.where((element) => element?.isLeft() == true).isNotEmpty ==
        false) {
      return const dartz.Right(dartz.unit);
    }
    return result.firstOrNull;
  }
}

class AddTagsToTaskParams {
  final Task task;
  final List<Tag> tags;
  final User user;

  String get taskId => task.id ?? "";

  List<String> get tagsNames => tags.map((e) => e.name ?? "").toList();

  AddTagsToTaskParams(
      {required this.task,
      required this.tags,
      required this.user,});
}
