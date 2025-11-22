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

class GetThemeModeUseCase
    implements UseCase<ThemeMode?, NoParams> {
  final SettingsRepo repo;

  GetThemeModeUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, ThemeMode?>> call(NoParams) async {
    final result = await repo.getThemeMode();
    await result.fold(
        (l) async => unawaited(serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.getThemeMode.name, parameters: {
              AnalyticsEventParameter.status.name: false,
              AnalyticsEventParameter.error.name: l.toString()
            })), (r) async {
      unawaited(serviceLocator<Analytics>().logEvent(
          AnalyticsEvents.getThemeMode.name, parameters: {
        AnalyticsEventParameter.status.name: true,
        AnalyticsEventParameter.data.name: r?.name ?? ""
      }));
    });
    return result;
  }
}

class GetThemeModeParams {
  final String issueDetails;
  final User user;

  GetThemeModeParams(this.user, {required this.issueDetails});

  Map<String, String> toJson() {
    return {"issue": issueDetails, "user_id": user.id ?? ""};
  }
}
