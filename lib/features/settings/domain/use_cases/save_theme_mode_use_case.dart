import 'dart:async';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import '../../../../common/entities/user.dart';
import '../../../../core/analytics/analytics.dart';
import '../../../../core/injection_container.dart';
import '../repositories/settings_repo.dart';

class SaveThemeModeUseCase
    implements UseCase<dartz.Unit, ThemeMode> {
  final SettingsRepo repo;

  SaveThemeModeUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, dartz.Unit>> call(ThemeMode themeMode) async {
    final result = await repo.saveThemeMode(themeMode);
    await result.fold(
        (l) async => unawaited(serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.saveThemeMode.name, parameters: {
              AnalyticsEventParameter.status.name: false,
              AnalyticsEventParameter.error.name: l.toString()
            })), (r) async {
      unawaited(serviceLocator<Analytics>().logEvent(
          AnalyticsEvents.saveThemeMode.name, parameters: {
        AnalyticsEventParameter.status.name: true,
        AnalyticsEventParameter.data.name: themeMode.name,
      }));
    });
    return result;
  }
}
