import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import '../../../../core/globals.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/clickup_folder.dart';
import '../entities/clickup_list.dart';
import '../entities/clickup_task.dart';
import '../repositories/tasks_repo.dart';

class CreateClickupListInFolderUseCase
    implements UseCase<ClickupList, CreateClickupListInFolderParams> {
  final TasksRepo repo;

  CreateClickupListInFolderUseCase(this.repo);

  @override
  Future<Either<Failure, ClickupList>?> call(
      CreateClickupListInFolderParams params) {
    return repo.createClickupListInFolder(params);
  }
}

class CreateClickupListInFolderParams extends Equatable {
  final ClickupAccessToken clickupAccessToken;
  final ClickupFolder clickupFolder;
  final String listName;
  final Color? statusColor;
  final ClickupAssignee? assignee = Globals.clickupUser?.asAssignee ;
  CreateClickupListInFolderParams({
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
