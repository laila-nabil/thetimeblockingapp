import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
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
      DeleteClickupTagParams params) async {
    final result = await repo.deleteClickupTag(params);
    await result?.fold(
            (l) async =>await serviceLocator<Analytics>()
            .logEvent(AnalyticsEvents.deleteTag.name, parameters: {
          AnalyticsEventParameter.status.name: false,
          AnalyticsEventParameter.error.name: l.toString(),
        }),
            (r) async =>await  serviceLocator<Analytics>()
            .logEvent(AnalyticsEvents.deleteTag.name, parameters: {
          AnalyticsEventParameter.status.name: true,
        }));
    return result;
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
