import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';

import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/tasks_list.dart';
import '../repositories/tasks_repo.dart';

class DeleteClickupListUseCase
    implements UseCase<Unit, DeleteClickupListParams> {
  final TasksRepo repo;

  DeleteClickupListUseCase(this.repo);
  @override
  Future<Either<Failure, Unit>?> call(DeleteClickupListParams params) async {
    final result = await repo.deleteList(params);
    await result?.fold(
            (l) async =>await serviceLocator<Analytics>()
            .logEvent(AnalyticsEvents.deleteList.name, parameters: {
          AnalyticsEventParameter.status.name: false,
          AnalyticsEventParameter.error.name: l.toString(),
        }),
            (r) async =>await  serviceLocator<Analytics>()
            .logEvent(AnalyticsEvents.deleteList.name, parameters: {
          AnalyticsEventParameter.status.name: true,
        }));
    return result;
  }
}

class DeleteClickupListParams {
  final TasksList list;
  final ClickupAccessToken clickupAccessToken;
  DeleteClickupListParams({required this.list,required this.clickupAccessToken, });

  String get listId => list.id ?? "";
}
