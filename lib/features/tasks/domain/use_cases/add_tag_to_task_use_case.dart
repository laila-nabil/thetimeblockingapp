import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';

import '../../../auth/domain/entities/clickup_access_token.dart';

class AddTagToTaskUseCase
    implements UseCase<Unit, AddTagToTaskParams> {
  
  final TasksRepo repo;

  AddTagToTaskUseCase(this.repo);
  @override
  Future<Either<Failure, Unit>?> call(AddTagToTaskParams params) async {
    final result = await repo.addTagToTask(params: params);
    await result.fold(
            (l) async => await serviceLocator<Analytics>()
            .logEvent(AnalyticsEvents.addTagToTask.name, parameters: {
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

class AddTagToTaskParams {
  final ClickupTask task;
  final ClickupTag tag;
  final ClickupAccessToken clickupAccessToken;

  String get taskId => task.id ?? "";

  String get tagName => tag.name ?? "";

  AddTagToTaskParams(
      {required this.task,
      required this.tag,
      required this.clickupAccessToken});
}
