import 'dart:ui';

import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import '../../../../core/globals.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/folder.dart';
import '../entities/tasks_list.dart';
import '../entities/task.dart';
import '../repositories/tasks_repo.dart';

class CreateListInFolderUseCase
    implements UseCase<TasksList, CreateListInFolderParams> {
  final TasksRepo repo;

  CreateListInFolderUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, TasksList>?> call(
      CreateListInFolderParams params) async {
    final result = await repo.createClickupListInFolder(params);
    await result?.fold(
        (l) async =>await  serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.createList.name, parameters: {
              AnalyticsEventParameter.status.name: false,
              AnalyticsEventParameter.error.name: l.toString(),
            }),
        (r) async =>await  serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.createList.name, parameters: {
              AnalyticsEventParameter.status.name: true,
            }));
    return result;
  }
}

class CreateListInFolderParams extends Equatable {
  final ClickupAccessToken clickupAccessToken;
  final Folder clickupFolder;
  final String listName;
  final Color? statusColor;
  final Assignee? assignee = Globals.user?.asAssignee;

  CreateListInFolderParams({
    required this.clickupAccessToken,
    required this.clickupFolder,
    required this.listName,
    this.statusColor,
  });

  @override
  List<Object?> get props => [
        clickupAccessToken,
        clickupFolder,
        listName,
        statusColor,
      ];
}
