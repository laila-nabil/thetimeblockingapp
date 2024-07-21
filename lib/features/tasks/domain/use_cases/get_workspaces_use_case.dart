import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import '../../../../common/entities/workspace.dart';
import '../../../auth/domain/entities/access_token.dart';
import '../repositories/tasks_repo.dart';

class GetWorkspacesUseCase
    implements UseCase<List<Workspace>, GetWorkspacesParams> {
  final TasksRepo repo;

  GetWorkspacesUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, List<Workspace>>?> call(
      GetWorkspacesParams params) async {
    final result = await repo.getClickupWorkspaces(params: params);
    await result.fold(
            (l) async => await serviceLocator<Analytics>()
            .logEvent(AnalyticsEvents.getData.name, parameters: {
          AnalyticsEventParameter.data.name: "workspaces",
          AnalyticsEventParameter.status.name: false,
          AnalyticsEventParameter.error.name: l.toString(),
        }), (r) async => await serviceLocator<Analytics>()
          .logEvent(AnalyticsEvents.getData.name, parameters: {
        AnalyticsEventParameter.data.name: "workspaces",
        AnalyticsEventParameter.status.name: true,
      }));
    return result;
  }
}

class GetWorkspacesParams extends Equatable {
  final AccessToken clickupAccessToken;

  const GetWorkspacesParams(this.clickupAccessToken);

  @override
  List<Object?> get props => [clickupAccessToken];
}
