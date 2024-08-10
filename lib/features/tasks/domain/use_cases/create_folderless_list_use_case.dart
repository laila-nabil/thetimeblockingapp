import 'dart:ui';

import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/common/entities/space.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';
import '../../../../common/entities/access_token.dart';
import '../../../../common/entities/tasks_list.dart';
import '../repositories/tasks_repo.dart';

class CreateFolderlessListUseCase
    implements UseCase<TasksList, CreateFolderlessListParams> {
  final TasksRepo repo;

  CreateFolderlessListUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, TasksList>?> call(
      CreateFolderlessListParams params) async {
    final result = await repo.createFolderlessList(params);
    await result?.fold(
        (l) async => await serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.createList.name, parameters: {
              AnalyticsEventParameter.status.name: false,
              AnalyticsEventParameter.error.name: l.toString(),
            }),
        (r) async => await serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.createList.name, parameters: {
              AnalyticsEventParameter.status.name: true,
            }));
    return result;
  }
}

class CreateFolderlessListParams extends Equatable {
  final AccessToken accessToken;
  final Space space;
  final String listName;
  final Color? statusColor;

  const CreateFolderlessListParams({
    required this.accessToken,
    required this.space,
    required this.listName,
    this.statusColor,
  });

  @override
  List<Object?> get props =>
      [accessToken, space, listName, statusColor];
}
