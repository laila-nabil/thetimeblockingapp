import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/user.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/common/entities/space.dart';
import '../../../../common/entities/access_token.dart';
import '../../../../common/entities/folder.dart';
import '../repositories/tasks_repo.dart';

class CreateFolderInSpaceUseCase
    implements UseCase<dartz.Unit, CreateFolderInSpaceParams> {
  final TasksRepo repo;

  CreateFolderInSpaceUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> call(
      CreateFolderInSpaceParams params) async{
    final result = await repo.createFolderInSpace(params);
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
  final AccessToken accessToken;
  final Space space;
  final String folderName;
  final User user;
  const CreateFolderInSpaceParams({
    required this.accessToken,
    required this.space,
    required this.folderName,
    required this.user,
  });

  Map<String, dynamic> toJson() {
    return {
      'space_id': space.id,
      'name': folderName,
      'user_id': user.id,
    };
  }

  @override
  List<Object?> get props =>
      [accessToken, space,folderName,user];
}
