import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import '../../../../core/globals.dart';
import '../../../../core/print_debug.dart';
import '../../../auth/domain/entities/access_token.dart';
import '../entities/space.dart';

class GetSpacesInWorkspacesUseCase
    with GlobalsWriteAccess
    implements UseCase<List<Space>, GetSpacesInWorkspacesParams> {
  final TasksRepo repo;

  GetSpacesInWorkspacesUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, List<Space>>?> call(
      GetSpacesInWorkspacesParams params) async {
    final result = await repo.getClickupSpacesInWorkspaces(params: params);
    await result.fold(
        (l) async => await serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.getData.name, parameters: {
              AnalyticsEventParameter.data.name: "spaces",
              AnalyticsEventParameter.status.name: false,
              AnalyticsEventParameter.error.name: l.toString(),
            }), (r) async {
      clickupSpaces = r;
      printDebug(
          "GetClickupSpacesInWorkspacesUseCase Globals.clickupSpaces ${Globals.spaces}");
      await serviceLocator<Analytics>()
          .logEvent(AnalyticsEvents.getData.name, parameters: {
        AnalyticsEventParameter.data.name: "spaces",
        AnalyticsEventParameter.status.name: true,
      });
    });
    return result;
  }
}

class GetSpacesInWorkspacesParams extends Equatable {
  final AccessToken clickupAccessToken;
  final Workspace clickupWorkspace;
  final bool? archived;

  const GetSpacesInWorkspacesParams({
    required this.clickupAccessToken,
    required this.clickupWorkspace,
    this.archived,
  });

  @override
  List<Object?> get props => [clickupAccessToken, clickupWorkspace, archived];
}
