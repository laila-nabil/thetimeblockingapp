import 'package:dartz/dartz.dart' as dartz;
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/global/domain/repositories/global_repo.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/create_workspace_use_case.dart';
import '../../../../common/entities/workspace.dart';
import '../../../../common/entities/access_token.dart';

class GetWorkspacesUseCase
    implements UseCase<List<Workspace>, GetWorkspacesParams> {
  final GlobalRepo repo;

  GetWorkspacesUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, List<Workspace>>> call(
      GetWorkspacesParams params) async {
    final result = await repo.getWorkspaces(params: params);
    await result.fold(
        (l)async  =>  serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.getData.name, parameters: {
              AnalyticsEventParameter.data.name: "workspaces",
              AnalyticsEventParameter.status.name: false,
              AnalyticsEventParameter.error.name: l.toString(),
            }),
        (r)async {
          serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.getData.name, parameters: {
              AnalyticsEventParameter.data.name: "workspaces",
              AnalyticsEventParameter.status.name: true,
            });
      final result = await repo.createWorkspace(
          params: CreateWorkspaceParams(
              accessToken: params.accessToken, userId: params.userId, name: "Main workspace"));
    });
    return result;
  }
}

class GetWorkspacesParams extends Equatable {
  final AccessToken accessToken;
  final String userId;

  const GetWorkspacesParams({required this.accessToken, required this.userId});

  @override
  List<Object?> get props => [accessToken, userId];
}
