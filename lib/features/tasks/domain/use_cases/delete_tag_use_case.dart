import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/common/entities/tag.dart';
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';

import '../../../../common/entities/access_token.dart';


class DeleteTagUseCase
    implements UseCase<dartz.Unit, DeleteTagParams> {

  final TasksRepo repo;

  DeleteTagUseCase(this.repo);
  @override
  Future<dartz.Either<Failure, dartz.Unit>?> call(
      DeleteTagParams params) async {
    final result = await repo.deleteTag(params);
    await result?.fold(
            (l) async =>await serviceLocator<Analytics>()
            .logEvent(AnalyticsEvents.deleteTag.name, parameters: {
          AnalyticsEventParameter.status.name: false,
          AnalyticsEventParameter.error.name: l.toString(),
        }),
            (r) async =>await  serviceLocator<Analytics>()
            .logEvent(AnalyticsEvents.deleteTag.name, parameters: {
          AnalyticsEventParameter.status.name: true,
        }));
    return result;
  }
}

class DeleteTagParams {
  final Workspace workspace;
  final Tag tag;
  final AccessToken accessToken;

  DeleteTagParams(
      {required this.workspace,
        required this.tag,
        required this.accessToken});
}
