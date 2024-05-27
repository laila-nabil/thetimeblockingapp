import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_space.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/clickup_list.dart';
import '../repositories/tasks_repo.dart';

class CreateFolderlessListClickupListUseCase
    implements UseCase<ClickupList, CreateFolderlessListClickupParams> {
  final TasksRepo repo;

  CreateFolderlessListClickupListUseCase(this.repo);

  @override
  Future<Either<Failure, ClickupList>?> call(
      CreateFolderlessListClickupParams params) async {
    final result = await repo.createFolderlessClickupList(params);
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

class CreateFolderlessListClickupParams extends Equatable {
  final ClickupAccessToken clickupAccessToken;
  final ClickupSpace clickupSpace;
  final String listName;
  final Color? statusColor;
  final ClickupAssignee? assignee = Globals.clickupUser?.asAssignee;

  CreateFolderlessListClickupParams({
    required this.clickupAccessToken,
    required this.clickupSpace,
    required this.listName,
    this.statusColor,
  });

  @override
  List<Object?> get props =>
      [clickupAccessToken, clickupSpace, listName, statusColor];
}
