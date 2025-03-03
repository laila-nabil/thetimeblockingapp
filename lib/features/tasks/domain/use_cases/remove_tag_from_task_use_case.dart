import 'dart:async';

import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';

import '../../../../common/entities/tag.dart';

class RemoveTagFromTaskUseCase
    implements UseCase<dartz.Unit, RemoveTagFromTaskParams> {
  
  final TasksRepo repo;

  RemoveTagFromTaskUseCase(this.repo);
  @override
  Future<dartz.Either<Failure, dartz.Unit>?> call(RemoveTagFromTaskParams params) async {
    var result = await repo.removeTagFromTask(params: params);
    await result.fold(
            (l) async => unawaited(serviceLocator<Analytics>()
            .logEvent(AnalyticsEvents.removeTagToTask.name, parameters: {
          AnalyticsEventParameter.status.name: false,
          AnalyticsEventParameter.error.name: l.toString(),
        })),
            (r) async => unawaited(serviceLocator<Analytics>()
            .logEvent(AnalyticsEvents.removeTagToTask.name, parameters: {
          AnalyticsEventParameter.status.name: true,
        })));
    return result;
  }
}

class RemoveTagFromTaskParams {
  final Task task;
  final Tag tag;


  String get taskId => task.id ?? "";

  String get tagName => tag.name ?? "";

  RemoveTagFromTaskParams(
      {required this.task,
      required this.tag,
      });
}
