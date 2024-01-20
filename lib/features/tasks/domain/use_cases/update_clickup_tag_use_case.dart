import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/auth/domain/entities/clickup_access_token.dart';
import 'package:thetimeblockingapp/features/tasks/data/models/clickup_task_model.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_space.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';

import '../entities/clickup_task.dart';

class UpdateClickupTagUseCase
    implements UseCase<Unit, UpdateClickupTagParams> {

  final TasksRepo repo;

  static bool readyToSubmit(ClickupTag tag) =>
      tag.name?.isNotEmpty == true &&
          tag.name?.endsWith("?") == false &&
          tag.name?.endsWith("؟") == false;

  UpdateClickupTagUseCase(this.repo);
  @override
  Future<Either<Failure, Unit>?> call(
      UpdateClickupTagParams params) async{
    if(readyToSubmit(params.newTag) == false){
      return const Left(InputFailure(message: "must not contain ? at the end"));
    }
    return await repo.updateClickupTag(params);
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
