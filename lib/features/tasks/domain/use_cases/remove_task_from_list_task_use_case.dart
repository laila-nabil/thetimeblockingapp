import 'package:dartz/dartz.dart' as dartz; 
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';

import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/tasks_list.dart';

class RemoveTaskFromAdditionalListUseCase
    implements UseCase<dartz.Unit, RemoveTaskFromListParams> {
  
  final TasksRepo repo;

  RemoveTaskFromAdditionalListUseCase(this.repo);
  @override
  Future<dartz.Either<Failure, dartz.Unit>?> call(RemoveTaskFromListParams params) {
    return repo.removeTaskFromAdditionalList(params: params);
  }
}

class RemoveTaskFromListParams {
  final Task task;
  final TasksList list;
  final ClickupAccessToken clickupAccessToken;

  String get taskId => task.id ?? "";

  String get listId => list.id ?? "";

  RemoveTaskFromListParams(
      {required this.task,
      required this.list,
      required this.clickupAccessToken});
}
