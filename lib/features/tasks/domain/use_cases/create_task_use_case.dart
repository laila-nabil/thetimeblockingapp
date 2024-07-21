import 'package:dartz/dartz.dart' as dartz; 
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task.dart';

import '../entities/task_parameters.dart';
import '../repositories/tasks_repo.dart';

///TODO add note or attachment with link to task url in timeblockingapp for quick access
///TODO enable navigation to specific task with task id
///TODO have brain dump/ inbox or default list

class CreateTaskUseCase
    implements UseCase<Task, CreateTaskParams> {
  final TasksRepo repo;

  CreateTaskUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, Task>?> call(CreateTaskParams params) async {
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