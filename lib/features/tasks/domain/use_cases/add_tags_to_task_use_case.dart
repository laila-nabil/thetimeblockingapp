import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/add_tag_to_task_use_case.dart';

import '../../../auth/domain/entities/clickup_access_token.dart';

class AddTagsFromTaskUseCase
    implements UseCase<void, AddTagsFromTaskParams> {

  final AddTagToTaskUseCase addTagFromTaskUseCase;

  AddTagsFromTaskUseCase(this.addTagFromTaskUseCase);
  @override
  Future<Either<Failure, void>?> call(AddTagsFromTaskParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class AddTagsFromTaskParams {
  final ClickupTask task;
  final List<ClickupTag> tags;
  final ClickupAccessToken clickupAccessToken;

  String get taskId => task.id ?? "";

  List<String> get tagsNames => tags.map((e) => e.name??"").toList();

  AddTagsFromTaskParams(
      {required this.task,
      required this.tags,
      required this.clickupAccessToken});
}
