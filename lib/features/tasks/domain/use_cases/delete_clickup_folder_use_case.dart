import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';

import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/clickup_folder.dart';
import '../repositories/tasks_repo.dart';

class DeleteClickupFolderUseCase
    implements UseCase<Unit, DeleteClickupFolderParams> {
  final TasksRepo repo;

  DeleteClickupFolderUseCase(this.repo);

  @override
  Future<Either<Failure, Unit>?> call(DeleteClickupFolderParams params) async {
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
  final ClickupFolder folder;
  final ClickupAccessToken clickupAccessToken;

  DeleteClickupFolderParams({
    required this.folder,
    required this.clickupAccessToken,
  });

  String get folderId => folder.id ?? "";
}
