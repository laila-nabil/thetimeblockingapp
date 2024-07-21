import 'package:dartz/dartz.dart' as dartz; 
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task.dart';

import '../../../auth/domain/entities/clickup_access_token.dart';
import '../repositories/tasks_repo.dart';

class DeleteTaskUseCase
    implements UseCase<dartz.Unit, DeleteTaskParams> {
  final TasksRepo repo;

  DeleteTaskUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> call(DeleteTaskParams params) async {
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

class DeleteTaskParams {
  final Task task;
  final ClickupAccessToken accessToken;

  DeleteTaskParams({
    required this.task,
    required this.accessToken,
  });

  String get taskId => task.id ?? "";
}
