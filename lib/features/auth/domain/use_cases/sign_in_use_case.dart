import 'package:dartz/dartz.dart' as dartz;
import 'package:equatable/equatable.dart';
import 'package:sentry/sentry.dart';
import 'package:thetimeblockingapp/common/entities/access_token.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';

import '../entities/sign_in_result.dart';
import '../repositories/auth_repo.dart';

class SignInUseCase implements UseCase<SignInResult, SignInParams> {
  final AuthRepo repo;

  SignInUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, SignInResult>?> call(SignInParams params) async {
    final result = await repo.signIn(params: params);
    await result.fold(
        (l) async {
          if (l is! EmptyCacheFailure) {
        await serviceLocator<Analytics>()
            .logEvent(AnalyticsEvents.signIn.name, parameters: {
          AnalyticsEventParameter.status.name: false,
          AnalyticsEventParameter.error.name: l.toString(),
        });
      }
    },
        (r) async {
          Sentry.configureScope(
        (scope) =>
            scope.setUser(SentryUser(id: r.user.id, email: r.user.email)),
      );
          await serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.signIn.name, parameters: {
              AnalyticsEventParameter.status.name: true,
            });
        });
    return result;
  }
}

class SignInParams extends Equatable {
  final String email;
  final String password;
  final AccessToken accessToken;

  const SignInParams({
    required this.email,
    required this.password,
    required this.accessToken,
  });

  @override
  List<Object?> get props => [email, password,accessToken];
}