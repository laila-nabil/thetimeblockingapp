import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import '../../../../common/entities/access_token.dart';

import '../../../../common/entities/tag.dart';

class GetTagsInWorkspaceUseCase
    implements UseCase<List<Tag>, GetTagsInWorkspaceParams> {
  final TasksRepo repo;

  GetTagsInWorkspaceUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, List<Tag>>?> call(
      GetTagsInWorkspaceParams params) async {
    final result = await repo.getTags(params: params);
    await result.fold(
            (l) async => await serviceLocator<Analytics>()
            .logEvent(AnalyticsEvents.getData.name, parameters: {
          AnalyticsEventParameter.data.name: "tags",
          AnalyticsEventParameter.status.name: false,
          AnalyticsEventParameter.error.name: l.toString(),
        }),
            (r) async => await serviceLocator<Analytics>()
            .logEvent(AnalyticsEvents.getData.name, parameters: {
          AnalyticsEventParameter.data.name: "tags",
          AnalyticsEventParameter.status.name: true,
        }));
    return result;
  }
}

class GetTagsInWorkspaceParams extends Equatable {
  final Workspace workspace;
  final bool? archived;

  const GetTagsInWorkspaceParams({
    required this.workspace,
    this.archived,
  });

  @override
  List<Object?> get props => [ workspace,archived];
}
