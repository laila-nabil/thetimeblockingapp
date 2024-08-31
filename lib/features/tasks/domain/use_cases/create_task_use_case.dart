import 'package:dartz/dartz.dart' as dartz; 
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';

import '../entities/task_parameters.dart';
import '../repositories/tasks_repo.dart';

///TODO Z add note or attachment with link to task url in timeblockingapp for quick access
///TODO Z enable navigation to specific task with task id
///TODO D have brain dump/ inbox or default list

class CreateTaskUseCase
    implements UseCase<dartz.Unit, CreateTaskParams> {
  final TasksRepo repo;

  CreateTaskUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> call(CreateTaskParams params) async {
    final result = await repo.createTaskInList(params);
    await result?.fold(
        (l) async =>await  serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.createTask.name, parameters: {
              AnalyticsEventParameter.status.name: false,
              AnalyticsEventParameter.error.name: l.toString(),
            }),
        (r) async =>await  serviceLocator<Analytics>().logEvent(
            AnalyticsEvents.createTask.name,
            parameters: {AnalyticsEventParameter.status.name: true}));
    return result;
  }
}
