import 'package:dartz/dartz.dart' as dartz;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/auth/domain/repositories/auth_repo.dart';

import '../../../../core/analytics/analytics.dart';
import '../../../../core/injection_container.dart';

///TODO A move to auth feature
class SignOutUseCase implements UseCase<dartz.Unit, NoParams> {
  final AuthRepo authRepo;

  SignOutUseCase(this.authRepo);

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> call(NoParams) async {
    final result = await authRepo.signOut();
    await result.fold(
        (l) async => await serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.signOut.name, parameters: {
              AnalyticsEventParameter.status.name: false,
              AnalyticsEventParameter.error.name: l.toString()
            }), (r) async {
      Sentry.configureScope(
            (scope) =>
            scope.setUser(null),
      );
      await serviceLocator<Analytics>().logEvent(AnalyticsEvents.signOut.name,
          parameters: {AnalyticsEventParameter.status.name: true});
      await serviceLocator<Analytics>().resetUser();
    });
    return result;
  }
}
