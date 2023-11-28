import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/auth/domain/entities/clickup_access_token.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_space.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';

import '../../data/models/clickup_task_model.dart';

class CreateClickupTagInSpaceUseCase
    implements UseCase<Unit, CreateClickupTagInSpaceParams> {
  final TasksRepo repo;

  CreateClickupTagInSpaceUseCase(this.repo);

  @override
  Future<Either<Failure, Unit>?> call(CreateClickupTagInSpaceParams params) {
    return repo.createClickupTagInSpace(params);
  }
}

class CreateClickupTagInSpaceParams {
  final ClickupSpace space;
  final ClickupAccessToken clickupAccessToken;
  final ClickupTagModel newTag;

  CreateClickupTagInSpaceParams(
      {required this.space,
      required this.clickupAccessToken,
      required this.newTag});
}
