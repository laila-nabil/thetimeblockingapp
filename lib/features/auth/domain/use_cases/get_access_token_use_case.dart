import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/common/entities/access_token.dart';

import '../repositories/auth_repo.dart';

class GetAccessTokenUseCase
    implements UseCase<AccessToken, GetAccessTokenParams> {
  final AuthRepo repo;

  GetAccessTokenUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, AccessToken>?> call(
      GetAccessTokenParams params) async {
    final result = await repo.getAccessToken(params: params);
    await result.fold(
        (l) async => await serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.getData.name, parameters: {
              AnalyticsEventParameter.data.name: "accessToken",
              AnalyticsEventParameter.status.name: false,
              AnalyticsEventParameter.error.name: l.toString(),
            }),
        (r) async => await serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.getData.name, parameters: {
              AnalyticsEventParameter.data.name: "accessToken",
              AnalyticsEventParameter.status.name: true,
            }));
    return result;
  }
}

class GetAccessTokenParams extends Equatable {
  final String code;

  const GetAccessTokenParams(this.code);

  @override
  List<Object?> get props => [code];
}
