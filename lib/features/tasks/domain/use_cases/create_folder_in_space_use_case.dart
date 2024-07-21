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

class CreateFolderInSpaceUseCase
    implements UseCase<Folder, CreateFolderInSpaceParams> {
  final TasksRepo repo;

  CreateFolderInSpaceUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, Folder>?> call(
      CreateFolderInSpaceParams params) async{
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

class CreateFolderInSpaceParams extends Equatable {
  final ClickupAccessToken clickupAccessToken;
  final Space clickupSpace;
  final String folderName;
  const CreateFolderInSpaceParams({
    required this.clickupAccessToken,
    required this.clickupSpace,
    required this.folderName,
  });

  @override
  List<Object?> get props =>
      [clickupAccessToken, clickupSpace,folderName,];
}
