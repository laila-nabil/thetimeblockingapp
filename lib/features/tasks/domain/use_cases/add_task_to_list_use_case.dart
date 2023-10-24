import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';

import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/clickup_list.dart';

class AddTaskToListUseCase
    implements UseCase<void, AddTaskToListParams> {
  @override
  Future<Either<Failure, void>?> call(AddTaskToListParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class AddTaskToListParams {
  final ClickupTask task;
  final ClickupList list;
  final ClickupAccessToken clickupAccessToken;

  String get taskId => task.id ?? "";

  String get listId => list.id ?? "";

  AddTaskToListParams(
      {required this.task,
      required this.list,
      required this.clickupAccessToken});
}
