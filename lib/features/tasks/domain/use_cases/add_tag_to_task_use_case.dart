import 'dart:async';

import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';

import '../../../../common/entities/tag.dart';
import '../../../../common/entities/user.dart';

class AddTagToTaskUseCase
    implements UseCase<dartz.Unit, AddTagToTaskParams> {
  
  final TasksRepo repo;

  AddTagToTaskUseCase(this.repo);
  @override
  Future<dartz.Either<Failure, dartz.Unit>?> call(AddTagToTaskParams params) async {
    final result = await repo.addTagToTask(params: params);
    await result.fold(
            (l) async => unawaited(serviceLocator<Analytics>()
            .logEvent(AnalyticsEvents.addTagToTask.name, parameters: {
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

class AddTagToTaskParams {
  final Task task;
  final Tag tag;
  final User? user;
  String get taskId => task.id ?? "";

  String get tagName => tag.name ?? "";

  AddTagToTaskParams(
      {required this.task,
      required this.tag,
      required this.user,});

  Map<String, dynamic> toJson() {
    return {
      'task_id': task.id,
      'tag_id': tag.id,
      'user_id': user?.id,
    };
  }
}
