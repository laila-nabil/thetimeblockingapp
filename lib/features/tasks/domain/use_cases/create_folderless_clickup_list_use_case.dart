import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_space.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/clickup_list.dart';
import '../repositories/tasks_repo.dart';

class CreateFolderlessClickupListUseCase
    implements UseCase<ClickupList, CreateFolderlessClickupParams> {
  final TasksRepo repo;

  CreateFolderlessClickupListUseCase(this.repo);

  @override
  Future<Either<Failure, ClickupList>?> call(
      CreateFolderlessClickupParams params) {
    return repo.createFolderlessClickupList(params);
  }
}

class CreateFolderlessClickupParams extends Equatable {
  final ClickupAccessToken clickupAccessToken;
  final ClickupSpace clickupSpace;
  final String listName;
  final Color? statusColor;
  final ClickupAssignee? assignee = Globals.clickupUser?.asAssignee ;
  CreateFolderlessClickupParams({
    required this.clickupAccessToken,
    required this.clickupSpace,
    required this.listName,
    this.statusColor,
  });

  @override
  List<Object?> get props =>
      [clickupAccessToken, clickupSpace,listName,statusColor];
}
