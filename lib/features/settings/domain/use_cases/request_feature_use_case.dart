import 'dart:async';

import 'package:dartz/dartz.dart' as dartz;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/auth/domain/repositories/auth_repo.dart';
import 'package:thetimeblockingapp/features/settings/domain/repositories/settings_repo.dart';

import '../../../../common/entities/user.dart';
import '../../../../core/analytics/analytics.dart';
import '../../../../core/injection_container.dart';

class RequestFeatureUseCase
    implements UseCase<dartz.Unit, RequestFeatureParams> {
  final SettingsRepo repo;

  RequestFeatureUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, dartz.Unit>> call(
      RequestFeatureParams params) async {
    final result = await repo.requestFeature(params);
    await result.fold(
        (l) async => unawaited(serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.requestFeature.name, parameters: {
              AnalyticsEventParameter.status.name: false,
              AnalyticsEventParameter.error.name: l.toString()
            })), (r) async {
      Sentry.configureScope(
        (scope) => scope.setUser(null),
      );
      unawaited(serviceLocator<Analytics>().logEvent(
          AnalyticsEvents.requestFeature.name,
          parameters: {AnalyticsEventParameter.status.name: true}));
      unawaited(serviceLocator<Analytics>().resetUser());
    });
    return result;
  }
}

class RequestFeatureParams {
  final String featureDetails;
  final User user;

  RequestFeatureParams(this.user, {required this.featureDetails});

  Map<String, String> toJson() {
    return {"feature": featureDetails, "user_id": user.id ?? ""};
  }
}
