import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';

import '../../../auth/domain/entities/clickup_access_token.dart';

class RemoveTagFromTaskUseCase
    implements UseCase<Unit, RemoveTagFromTaskParams> {
  
  final TasksRepo repo;

  RemoveTagFromTaskUseCase(this.repo);
  @override
  Future<Either<Failure, Unit>?> call(RemoveTagFromTaskParams params) async {
    var result = await repo.removeTagFromTask(params: params);
    await result.fold(
            (l) async => await serviceLocator<Analytics>()
            .logEvent(AnalyticsEvents.removeTagToTask.name, parameters: {
          AnalyticsEventParameter.status.name: false,
          AnalyticsEventParameter.error.name: l.toString(),
        }),
            (r) async => await serviceLocator<Analytics>()
            .logEvent(AnalyticsEvents.removeTagToTask.name, parameters: {
          AnalyticsEventParameter.status.name: true,
        }));
    return result;
  }
}

class RemoveTagFromTaskParams {
  final ClickupTask task;
  final ClickupTag tag;
  final ClickupAccessToken clickupAccessToken;

  String get taskId => task.id ?? "";

  String get tagName => tag.name ?? "";

  RemoveTagFromTaskParams(
      {required this.task,
      required this.tag,
      required this.clickupAccessToken});
}
