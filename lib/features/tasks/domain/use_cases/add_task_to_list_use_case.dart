import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task.dart';

import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/tasks_list.dart';
import '../repositories/tasks_repo.dart';

class AddTaskToListUseCase
    implements UseCase<Unit, AddTaskToListParams> {
  final TasksRepo repo;

  AddTaskToListUseCase(this.repo);
  @override
  Future<Either<Failure, Unit>?> call(AddTaskToListParams params) {
    return repo.addTaskToList(params: params);
  }
}

class AddTaskToListParams {
  final ClickupTask task;
  final TasksList list;
  final ClickupAccessToken clickupAccessToken;

  String get taskId => task.id ?? "";

  String get listId => list.id ?? "";

  AddTaskToListParams(
      {required this.task,
      required this.list,
      required this.clickupAccessToken});
}
