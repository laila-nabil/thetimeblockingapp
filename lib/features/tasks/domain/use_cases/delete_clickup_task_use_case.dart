import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task.dart';

import '../../../auth/domain/entities/clickup_access_token.dart';
import '../repositories/tasks_repo.dart';

class DeleteClickupTaskUseCase
    implements UseCase<Unit, DeleteClickupTaskParams> {
  final TasksRepo repo;

  DeleteClickupTaskUseCase(this.repo);

  @override
  Future<Either<Failure, Unit>?> call(DeleteClickupTaskParams params) async {
    final result = await repo.deleteTask(params);
    await result?.fold(
        (l) async =>await  serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.deleteTask.name, parameters: {
              AnalyticsEventParameter.status.name: false,
              AnalyticsEventParameter.error.name: l.toString(),
            }),
        (r) async =>await  serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.deleteTask.name, parameters: {
              AnalyticsEventParameter.status.name: true,
            }));
    return result;
  }
}

class DeleteClickupTaskParams {
  final ClickupTask task;
  final ClickupAccessToken clickupAccessToken;

  DeleteClickupTaskParams({
    required this.task,
    required this.clickupAccessToken,
  });

  String get taskId => task.id ?? "";
}
