import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/user.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/auth/domain/repositories/auth_repo.dart';

import '../../../../core/analytics/analytics.dart';
import '../../../../core/injection_container.dart';
import '../../../../common/entities/access_token.dart';

class GetUserUseCase
    implements UseCase<User, GetClickupUserParams> {
  final AuthRepo repo;

  GetUserUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, User>?> call(
      GetClickupUserParams params) async {
    final result = await repo.getUser(params: params);
    await result.fold(
        (l) async => await serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.getData.name, parameters: {
              AnalyticsEventParameter.data.name: "user",
              AnalyticsEventParameter.status.name: false,
              AnalyticsEventParameter.error.name: l.toString(),
            }), (r) async {
      await serviceLocator<Analytics>()
          .logEvent(AnalyticsEvents.getData.name, parameters: {
        AnalyticsEventParameter.data.name: "user",
        AnalyticsEventParameter.status.name: true,
      });
      await serviceLocator<Analytics>().setUserId(r.id.toString());
    });
    return result;
  }
}

class GetClickupUserParams extends Equatable {
  final AccessToken clickupAccessToken;

  const GetClickupUserParams(this.clickupAccessToken);

  @override
  List<Object?> get props => [clickupAccessToken];
}