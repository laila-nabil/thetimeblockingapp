import 'package:dartz/dartz.dart' as dartz; 
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';

class GetSelectedWorkspaceUseCase
    implements UseCase<Workspace, NoParams> {
  final TasksRepo repo;

  GetSelectedWorkspaceUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, Workspace>?> call(
      NoParams params)async {
    final result = await repo.getSelectedWorkspace(params);
    await result?.fold(
            (l) async => await serviceLocator<Analytics>()
            .logEvent(AnalyticsEvents.getData.name, parameters: {
          AnalyticsEventParameter.data.name: "selectedWorkspace",
          AnalyticsEventParameter.status.name: false,
          AnalyticsEventParameter.error.name: l.toString(),
        }), (r) async => await serviceLocator<Analytics>()
        .logEvent(AnalyticsEvents.getData.name, parameters: {
      AnalyticsEventParameter.data.name: "selectedWorkspace",
      AnalyticsEventParameter.status.name: true,
    }));
    return result;
  }
}
