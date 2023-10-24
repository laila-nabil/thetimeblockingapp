import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';

import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/clickup_list.dart';

class RemoveTaskFromListUseCase
    implements UseCase<void, RemoveTaskFromListParams> {
  @override
  Future<Either<Failure, void>?> call(RemoveTaskFromListParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class RemoveTaskFromListParams {
  final ClickupTask task;
  final ClickupList list;
  final ClickupAccessToken clickupAccessToken;

  String get taskId => task.id ?? "";

  String get listId => list.id ?? "";

  RemoveTaskFromListParams(
      {required this.task,
      required this.list,
      required this.clickupAccessToken});
}
