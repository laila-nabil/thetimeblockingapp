import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/clickup_workspace.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import '../../../../core/globals.dart';
import '../../../../core/print_debug.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/clickup_space.dart';

class GetClickupSpacesInWorkspacesUseCase
    
    implements UseCase<List<ClickupSpace>, GetClickupSpacesInWorkspacesParams> {
  final TasksRepo repo;

  GetClickupSpacesInWorkspacesUseCase(this.repo);

  @override
  Future<Either<Failure, List<ClickupSpace>>?> call(
      GetClickupSpacesInWorkspacesParams params) async {
    final result = await repo.getClickupSpacesInWorkspaces(params: params);
    await result.fold(
        (l) async => await serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.getData.name, parameters: {
              AnalyticsEventParameter.data.name: "spaces",
              AnalyticsEventParameter.status.name: false,
              AnalyticsEventParameter.error.name: l.toString(),
            }), (r) async {
          Globals.clickupGlobals = Globals.clickupGlobals?.copyWith(
            clickupSpaces: r
          );
      printDebug(
          "GetClickupSpacesInWorkspacesUseCase Globals.clickupSpaces ${Globals.clickupGlobals?.clickupSpaces}");
      await serviceLocator<Analytics>()
          .logEvent(AnalyticsEvents.getData.name, parameters: {
        AnalyticsEventParameter.data.name: "spaces",
        AnalyticsEventParameter.status.name: true,
      });
    });
    return result;
  }
}

class GetClickupSpacesInWorkspacesParams extends Equatable {
  final ClickupAccessToken? clickupAccessToken;
  final ClickupWorkspace? clickupWorkspace;
  final bool? archived;

  const GetClickupSpacesInWorkspacesParams({
    required this.clickupAccessToken,
    required this.clickupWorkspace,
    this.archived,
  });

  @override
  List<Object?> get props => [clickupAccessToken, clickupWorkspace, archived];
}
