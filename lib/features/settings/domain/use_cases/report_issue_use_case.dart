import 'dart:async';
import 'package:dartz/dartz.dart' as dartz;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import '../../../../common/entities/user.dart';
import '../../../../core/analytics/analytics.dart';
import '../../../../core/injection_container.dart';
import '../repositories/settings_repo.dart';

class ReportIssueUseCase
    implements UseCase<dartz.Unit, ReportIssueParams> {
  final SettingsRepo repo;

  ReportIssueUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, dartz.Unit>> call(
      ReportIssueParams params) async {
    final result = await repo.reportIssue(params);
    await result.fold(
        (l) async => unawaited(serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.reportIssue.name, parameters: {
              AnalyticsEventParameter.status.name: false,
              AnalyticsEventParameter.error.name: l.toString()
            })), (r) async {
      Sentry.configureScope(
        (scope) => scope.setUser(null),
      );
      unawaited(serviceLocator<Analytics>().logEvent(
          AnalyticsEvents.reportIssue.name,
          parameters: {AnalyticsEventParameter.status.name: true}));
      unawaited(serviceLocator<Analytics>().resetUser());
    });
    return result;
  }
}

class ReportIssueParams {
  final String issueDetails;
  final User user;

  ReportIssueParams(this.user, {required this.issueDetails});

  Map<String, String> toJson() {
    return {"issue": issueDetails, "user_id": user.id ?? ""};
  }
}
