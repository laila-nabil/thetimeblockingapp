import 'package:dartz/dartz.dart' as dartz; 
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/remove_tag_from_task_use_case.dart';

import '../../../auth/domain/entities/access_token.dart';

class RemoveTagsFromTaskUseCase implements UseCase<dartz.Unit, RemoveTagsFromTaskParams> {
  final RemoveTagFromTaskUseCase removeTagFromTaskUseCase;

  RemoveTagsFromTaskUseCase(this.removeTagFromTaskUseCase);

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> call(RemoveTagsFromTaskParams params) async {
    List<dartz.Either<Failure, dartz.Unit>?> result = [];
    for (var element in params.tags) {
      final elementResult = await removeTagFromTaskUseCase(RemoveTagFromTaskParams(
          task: params.task,
          clickupAccessToken: params.clickupAccessToken,
          tag: element));
      result.add(elementResult);
    }
    if (result.where((element) => element?.isLeft() == true).isNotEmpty ==
        false) {
      return const dartz.Right(dartz.unit);
    }
    return result.firstOrNull;
  }
}

class RemoveTagsFromTaskParams {
  final Task task;
  final List<Tag> tags;
  final AccessToken clickupAccessToken;

  String get taskId => task.id ?? "";

  List<String> get tagsNames => tags.map((e) => e.name ?? "").toList();

  RemoveTagsFromTaskParams(
      {required this.task,
      required this.tags,
      required this.clickupAccessToken});
}
