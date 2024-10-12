import 'dart:async';
import 'dart:ui';

import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/user.dart';
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';

import '../../../../common/entities/folder.dart';
import '../repositories/tasks_repo.dart';

class CreateListInFolderUseCase
    implements UseCase<dartz.Unit, CreateListInFolderParams> {
  final TasksRepo repo;

  CreateListInFolderUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> call(
      CreateListInFolderParams params) async {
    final result = await repo.createListInFolder(params);
    await result?.fold(
        (l) async =>unawaited(serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.createList.name, parameters: {
              AnalyticsEventParameter.status.name: false,
              AnalyticsEventParameter.error.name: l.toString(),
            })),
        (r) async =>unawaited(serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.createList.name, parameters: {
              AnalyticsEventParameter.status.name: true,
            })));
    return result;
  }
}

class CreateListInFolderParams extends Equatable {

  final Folder folder;
  final String listName;
  final Color? statusColor;
  final User user;
  final Workspace workspace;
  const CreateListInFolderParams({
    required this.folder,
    required this.listName,
    required this.user,
    required this.workspace,
    this.statusColor,
  });

  @override
  List<Object?> get props => [
        folder,
        listName,
        statusColor,
        user,
        workspace,
      ];

  Map<String, dynamic> toJson() {
    return {
      'workspace_id': workspace.id,
      'name': listName,
      'folder_id': folder.id,
      'user_id': user.id,
    };
  }
}
