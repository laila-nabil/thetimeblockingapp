import 'package:dartz/dartz.dart' as dartz; 
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';

import '../../../../common/entities/access_token.dart';
import '../../../../common/entities/tasks_list.dart';
import '../repositories/tasks_repo.dart';

class DeleteListUseCase
    implements UseCase<dartz.Unit, DeleteListParams> {
  final TasksRepo repo;

  DeleteListUseCase(this.repo);
  @override
  Future<dartz.Either<Failure, dartz.Unit>?> call(DeleteListParams params) async {
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

class DeleteListParams {
  final TasksList list;
  final AccessToken accessToken;
  DeleteListParams({required this.list,required this.accessToken, });

  String get listId => list.id ?? "";
}
