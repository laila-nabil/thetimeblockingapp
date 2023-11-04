import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';

import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/clickup_list.dart';

class RemoveTaskFromAdditionalListUseCase
    implements UseCase<Unit, RemoveTaskFromListParams> {
  
  final TasksRepo repo;

  RemoveTaskFromAdditionalListUseCase(this.repo);
  @override
  Future<Either<Failure, Unit>?> call(RemoveTaskFromListParams params) {
    return repo.removeTaskFromAdditionalList(params: params);
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
