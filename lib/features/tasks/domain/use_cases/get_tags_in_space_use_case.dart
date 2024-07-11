import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import '../../../../common/entities/access_token.dart';
import '../../../../common/entities/space.dart';
import '../../../../common/entities/tag.dart';

class GetTagsInSpaceUseCase
    implements UseCase<List<Tag>, GetTagsInSpaceParams> {
  final TasksRepo repo;

  GetTagsInSpaceUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, List<Tag>>?> call(
      GetTagsInSpaceParams params) async {
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

class GetTagsInSpaceParams extends Equatable {
  final AccessToken accessToken;
  final Space space;
  final bool? archived;

  const GetTagsInSpaceParams({
    required this.accessToken,
    required this.space,
    this.archived,
  });

  @override
  List<Object?> get props => [accessToken, space,archived];
}
