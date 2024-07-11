import 'package:dartz/dartz.dart' as dartz; 
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';

import '../../../tasks/domain/entities/space.dart';

class GetSelectedSpaceUseCase
    implements UseCase<Space, NoParams> {
  final TasksRepo repo;

  GetSelectedSpaceUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, Space>?> call(
      NoParams params)async {
    final result = await repo.getSelectedSpace(params);
    await result?.fold(
            (l) async => await serviceLocator<Analytics>()
            .logEvent(AnalyticsEvents.getData.name, parameters: {
          AnalyticsEventParameter.data.name: "selectedSpace",
          AnalyticsEventParameter.status.name: false,
          AnalyticsEventParameter.error.name: l.toString(),
        }), (r) async => await serviceLocator<Analytics>()
        .logEvent(AnalyticsEvents.getData.name, parameters: {
      AnalyticsEventParameter.data.name: "selectedSpace",
      AnalyticsEventParameter.status.name: true,
    }));
    return result;
  }
}
