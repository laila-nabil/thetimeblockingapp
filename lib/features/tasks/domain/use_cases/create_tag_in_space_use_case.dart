import 'package:dartz/dartz.dart' as dartz; 
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/auth/domain/entities/clickup_access_token.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/space.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';

import '../../data/models/clickup_task_model.dart';
import '../entities/task.dart';

class CreateTagInSpaceUseCase
    implements UseCase<dartz.Unit, CreateTagInSpaceParams> {
  final TasksRepo repo;

  CreateTagInSpaceUseCase(this.repo);

  static bool readyToSubmit(Tag tag) =>
      tag.name?.isNotEmpty == true &&
          tag.name?.endsWith("?") == false &&
          tag.name?.endsWith("؟") == false;

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> call(CreateTagInSpaceParams params) async{
    if(readyToSubmit(params.newTag) == false){
      await serviceLocator<Analytics>()
          .logEvent(AnalyticsEvents.createTag.name, parameters: {
        AnalyticsEventParameter.status.name: false,
        AnalyticsEventParameter.error.name: "must not contain ? at the end",
      });
      return const dartz.Left(InputFailure(message: "must not contain ? at the end"));
    }
    final result = await repo.createClickupTagInSpace(params);
    await result?.fold(
            (l) async =>await serviceLocator<Analytics>()
            .logEvent(AnalyticsEvents.createTag.name, parameters: {
          AnalyticsEventParameter.status.name: false,
          AnalyticsEventParameter.error.name: l.toString(),
        }),
            (r) async =>await  serviceLocator<Analytics>()
            .logEvent(AnalyticsEvents.createTag.name, parameters: {
          AnalyticsEventParameter.status.name: true,
        }));
    return result;
  }
}

class CreateTagInSpaceParams {
  final Space space;
  final ClickupAccessToken clickupAccessToken;
  final ClickupTagModel newTag;

  CreateTagInSpaceParams(
      {required this.space,
      required this.clickupAccessToken,
      required this.newTag});
}