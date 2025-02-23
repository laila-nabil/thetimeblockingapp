import 'dart:async';

import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/common/entities/tag.dart';
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';



class DeleteTagUseCase
    implements UseCase<dartz.Unit, DeleteTagParams> {

  final TasksRepo repo;

  DeleteTagUseCase(this.repo);
  @override
  Future<dartz.Either<Failure, dartz.Unit>?> call(
      DeleteTagParams params) async {
    final result = await repo.deleteTag(params);
    await result?.fold(
            (l) async =>unawaited(serviceLocator<Analytics>()
            .logEvent(AnalyticsEvents.deleteTag.name, parameters: {
          AnalyticsEventParameter.status.name: false,
          AnalyticsEventParameter.error.name: l.toString(),
        })),
            (r) async =>unawaited(serviceLocator<Analytics>()
            .logEvent(AnalyticsEvents.deleteTag.name, parameters: {
          AnalyticsEventParameter.status.name: true,
        })));
    return result;
  }
}

class DeleteTagParams {
  final Workspace workspace;
  final Tag tag;


  DeleteTagParams(
      {required this.workspace,
        required this.tag,});
}
