import 'package:dartz/dartz.dart' as dartz; 
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';

import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/folder.dart';
import '../repositories/tasks_repo.dart';

class DeleteClickupFolderUseCase
    implements UseCase<dartz.Unit, DeleteClickupFolderParams> {
  final TasksRepo repo;

  DeleteClickupFolderUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> call(DeleteClickupFolderParams params) async {
    final result = await repo.deleteFolder(params);
    await result?.fold(
        (l) async => await serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.deleteFolder.name, parameters: {
              AnalyticsEventParameter.status.name: false,
              AnalyticsEventParameter.error.name: l.toString(),
            }),
        (r) async => await serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.deleteFolder.name, parameters: {
              AnalyticsEventParameter.status.name: true,
            }));
    return result;
  }
}

class DeleteClickupFolderParams {
  final Folder folder;
  final ClickupAccessToken clickupAccessToken;

  DeleteClickupFolderParams({
    required this.folder,
    required this.clickupAccessToken,
  });

  String get folderId => folder.id ?? "";
}
