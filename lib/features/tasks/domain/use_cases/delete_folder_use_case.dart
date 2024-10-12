import 'dart:async';

import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';

import '../../../../common/entities/folder.dart';
import '../repositories/tasks_repo.dart';

class DeleteFolderUseCase
    implements UseCase<dartz.Unit, DeleteFolderParams> {
  final TasksRepo repo;

  DeleteFolderUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> call(DeleteFolderParams params) async {
    final result = await repo.deleteFolder(params);
    await result?.fold(
        (l) async => unawaited(serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.deleteFolder.name, parameters: {
              AnalyticsEventParameter.status.name: false,
              AnalyticsEventParameter.error.name: l.toString(),
            })),
        (r) async => unawaited(serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.deleteFolder.name, parameters: {
              AnalyticsEventParameter.status.name: true,
            })));
    return result;
  }
}

class DeleteFolderParams {
  final Folder folder;


  DeleteFolderParams({
    required this.folder,
  });

  String get folderId => folder.id ?? "";
}
