import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';

import '../../../auth/domain/entities/clickup_access_token.dart';

class RemoveTagFromTaskUseCase
    implements UseCase<void, RemoveTagFromTaskParams> {
  @override
  Future<Either<Failure, void>?> call(RemoveTagFromTaskParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class RemoveTagFromTaskParams {
  final ClickupTask task;
  final ClickupTag tag;
  final ClickupAccessToken clickupAccessToken;

  String get taskId => task.id ?? "";

  String get tagName => tag.name ?? "";

  RemoveTagFromTaskParams(
      {required this.task,
      required this.tag,
      required this.clickupAccessToken});
}
