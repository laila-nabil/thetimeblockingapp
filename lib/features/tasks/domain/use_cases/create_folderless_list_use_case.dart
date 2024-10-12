import 'dart:async';
import 'dart:ui';

import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';

import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import '../../../../common/entities/user.dart';
import '../repositories/tasks_repo.dart';

class CreateFolderlessListUseCase
    implements UseCase<dartz.Unit, CreateFolderlessListParams> {
  final TasksRepo repo;

  CreateFolderlessListUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> call(
      CreateFolderlessListParams params) async {
    final result = await repo.createFolderlessList(params);
    await result?.fold(
        (l) async => unawaited(serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.createList.name, parameters: {
              AnalyticsEventParameter.status.name: false,
              AnalyticsEventParameter.error.name: l.toString(),
            })),
        (r) async => unawaited(serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.createList.name, parameters: {
              AnalyticsEventParameter.status.name: true,
            })));
    return result;
  }
}

class CreateFolderlessListParams extends Equatable {

  String? listName;
  final Color? statusColor;
  final User user;
  final Workspace workspace;
  CreateFolderlessListParams({
    required String this.listName,
    required this.user,
    required this.workspace,
    this.statusColor,
  });

  CreateFolderlessListParams.defaultList({
    required this.user,
    required this.workspace,
    this.statusColor,
  });


  @override
  List<Object?> get props => [
    listName,
    statusColor,
    user,
    workspace,
  ];

  Map<String, dynamic> toJson() {
    return {
      'workspace_id': workspace.id,
      if(listName?.isNotEmpty==true)'name': listName,
      'user_id': user.id,
    };
  }
}
