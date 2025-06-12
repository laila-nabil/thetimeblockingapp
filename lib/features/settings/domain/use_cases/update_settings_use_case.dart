import 'dart:async';

import 'package:dartz/dartz.dart' as dartz;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:thetimeblockingapp/common/entities/access_token.dart';
import 'package:thetimeblockingapp/common/entities/settings.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/auth/domain/repositories/auth_repo.dart';
import 'package:thetimeblockingapp/features/settings/domain/repositories/settings_repo.dart';

import '../../../../common/entities/user.dart';
import '../../../../core/analytics/analytics.dart';
import '../../../../core/injection_container.dart';

class UpdateSettingsUseCase
    implements UseCase<dartz.Unit, CreateUpdateSettingsParams> {
  final SettingsRepo repo;

  UpdateSettingsUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, dartz.Unit>> call(
      CreateUpdateSettingsParams params) async {
    final result =
        await repo.createUpdateSettings(createUpdateSettingsParams: params);
    await result.fold(
        (l) async => unawaited(serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.updateSettings.name, parameters: {
              AnalyticsEventParameter.status.name: false,
              AnalyticsEventParameter.error.name: l.toString()
            })), (r) async {
      Sentry.configureScope(
        (scope) => scope.setUser(null),
      );
      unawaited(serviceLocator<Analytics>().logEvent(
          AnalyticsEvents.updateSettings.name,
          parameters: {AnalyticsEventParameter.status.name: true}));
      unawaited(serviceLocator<Analytics>().resetUser());
    });
    return result;
  }
}

class CreateUpdateSettingsParams {
  final Settings newSettings;
  final AccessToken accessToken;

  CreateUpdateSettingsParams(this.newSettings, this.accessToken);
}
