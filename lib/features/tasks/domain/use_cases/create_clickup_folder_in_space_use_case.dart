import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/space.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/folder.dart';
import '../repositories/tasks_repo.dart';

class CreateClickupFolderInSpaceUseCase
    implements UseCase<Folder, CreateClickupFolderInSpaceParams> {
  final TasksRepo repo;

  CreateClickupFolderInSpaceUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, Folder>?> call(
      CreateClickupFolderInSpaceParams params) async{
    final result = await repo.createClickupFolderInSpace(params);
    await result?.fold(
            (l) async =>await serviceLocator<Analytics>()
            .logEvent(AnalyticsEvents.createFolder.name, parameters: {
          AnalyticsEventParameter.status.name: false,
          AnalyticsEventParameter.error.name: l.toString(),
        }),
            (r) async =>await  serviceLocator<Analytics>()
            .logEvent(AnalyticsEvents.createFolder.name, parameters: {
          AnalyticsEventParameter.status.name: true,
        }));
    return result;
  }
}

class CreateClickupFolderInSpaceParams extends Equatable {
  final ClickupAccessToken clickupAccessToken;
  final Space clickupSpace;
  final String folderName;
  const CreateClickupFolderInSpaceParams({
    required this.clickupAccessToken,
    required this.clickupSpace,
    required this.folderName,
  });

  @override
  List<Object?> get props =>
      [clickupAccessToken, clickupSpace,folderName,];
}
