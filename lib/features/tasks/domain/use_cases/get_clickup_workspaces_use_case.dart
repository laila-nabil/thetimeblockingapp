import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import '../../../../common/entities/workspace.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';
import '../repositories/tasks_repo.dart';

class GetClickupWorkspacesUseCase
    implements UseCase<List<Workspace>, GetClickupWorkspacesParams> {
  final TasksRepo repo;

  GetClickupWorkspacesUseCase(this.repo);

  @override
  Future<Either<Failure, List<Workspace>>?> call(
      GetClickupWorkspacesParams params) async {
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

class GetClickupWorkspacesParams extends Equatable {
  final ClickupAccessToken clickupAccessToken;

  const GetClickupWorkspacesParams(this.clickupAccessToken);

  @override
  List<Object?> get props => [clickupAccessToken];
}
