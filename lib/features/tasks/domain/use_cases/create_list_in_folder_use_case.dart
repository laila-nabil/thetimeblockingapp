import 'dart:ui';

import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/space.dart';
import 'package:thetimeblockingapp/common/entities/user.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';

import '../../../../common/entities/access_token.dart';
import '../../../../common/entities/folder.dart';
import '../../../../common/entities/tasks_list.dart';
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
  final AccessToken accessToken;
  final Folder folder;
  final String listName;
  final Color? statusColor;
  final User user;
  final Space space;
  const CreateListInFolderParams({
    required this.accessToken,
    required this.folder,
    required this.listName,
    required this.user,
    required this.space,
    this.statusColor,
  });

  @override
  List<Object?> get props => [
        accessToken,
        folder,
        listName,
        statusColor,
        user,
        space,
      ];

  Map<String, dynamic> toJson() {
    return {
      'space_id': space.id,
      'name': listName,
      'folder_id': folder.id,
      'user_id': user.id,
    };
  }
}
