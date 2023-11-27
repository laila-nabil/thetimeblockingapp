import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';

import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/clickup_space.dart';

class DeleteClickupTagUseCase
    implements UseCase<Unit, DeleteClickupTagParams> {

  final TasksRepo repo;

  DeleteClickupTagUseCase(this.repo);
  @override
  Future<Either<Failure, Unit>?> call(
      DeleteClickupTagParams params) {
    return repo.deleteClickupTag(params);
  }
}

class DeleteClickupTagParams {
  final ClickupSpace space;
  final ClickupTag tag;
  final ClickupAccessToken clickupAccessToken;

  DeleteClickupTagParams(
      {required this.space,
        required this.tag,
        required this.clickupAccessToken});
}
