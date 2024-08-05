import 'package:dartz/dartz.dart' as dartz; 
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';

import '../../../../common/entities/access_token.dart';
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

class DeleteFolderParams {
  final Folder folder;
  final AccessToken accessToken;

  DeleteFolderParams({
    required this.folder,
    required this.accessToken,
  });

  String get folderId => folder.id ?? "";
}
