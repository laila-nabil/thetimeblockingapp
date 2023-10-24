import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';

import '../../../auth/domain/entities/clickup_access_token.dart';

class AddTagToTaskUseCase
    implements UseCase<void, AddTagToTaskParams> {
  @override
  Future<Either<Failure, void>?> call(AddTagToTaskParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class AddTagToTaskParams {
  final ClickupTask task;
  final ClickupTag tag;
  final ClickupAccessToken clickupAccessToken;

  String get taskId => task.id ?? "";

  String get tagName => tag.name ?? "";

  AddTagToTaskParams(
      {required this.task,
      required this.tag,
      required this.clickupAccessToken});
}
