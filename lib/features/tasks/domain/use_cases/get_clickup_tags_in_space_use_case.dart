import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/space.dart';

class GetClickupTagsInSpaceUseCase
    implements UseCase<List<Tag>, GetClickupTagsInSpaceParams> {
  final TasksRepo repo;

  GetClickupTagsInSpaceUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, List<Tag>>?> call(
      GetClickupTagsInSpaceParams params) async {
    final result = await repo.getClickupTags(params: params);
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

class GetClickupTagsInSpaceParams extends Equatable {
  final ClickupAccessToken clickupAccessToken;
  final Space clickupSpace;
  final bool? archived;

  const GetClickupTagsInSpaceParams({
    required this.clickupAccessToken,
    required this.clickupSpace,
    this.archived,
  });

  @override
  List<Object?> get props => [clickupAccessToken, clickupSpace,archived];
}
