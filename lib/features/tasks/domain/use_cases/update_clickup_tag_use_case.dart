import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/auth/domain/entities/clickup_access_token.dart';
import 'package:thetimeblockingapp/features/tasks/data/models/clickup_task_model.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_space.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';

class UpdateClickupTagUseCase
    implements UseCase<ClickupTag, UpdateClickupTagParams> {

  final TasksRepo repo;

  UpdateClickupTagUseCase(this.repo);
  @override
  Future<Either<Failure, ClickupTag>?> call(
      UpdateClickupTagParams params) {
    return repo.updateClickupTag(params);
  }
}

class UpdateClickupTagParams {
  final ClickupSpace space;
  final String originalTagName;
  final ClickupTagModel newTag;
  final ClickupAccessToken clickupAccessToken;

  UpdateClickupTagParams(
      {required this.space,
      required this.newTag,
      required this.originalTagName,
      required this.clickupAccessToken});
}
