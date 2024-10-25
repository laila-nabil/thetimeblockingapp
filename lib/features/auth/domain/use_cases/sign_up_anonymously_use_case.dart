import 'dart:async';

import 'package:dartz/dartz.dart' as dartz;
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/auth/domain/entities/sign_up_anonymously_result.dart';

import '../repositories/auth_repo.dart';

class SignUpAnonymouslyUseCase
    implements UseCase<SignUpAnonymouslyResult, SignUpAnonymouslyParams> {
  final AuthRepo repo;

  SignUpAnonymouslyUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, SignUpAnonymouslyResult>?> call(
      SignUpAnonymouslyParams params) async {
    final result = await repo.signUpAnonymously(params: params);
    await result.fold(
        (l) async => unawaited(serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.signUpAnonymously.name, parameters: {
              AnalyticsEventParameter.status.name: false,
              AnalyticsEventParameter.error.name: l.toString(),
            })), (r) async {
      unawaited(serviceLocator<Analytics>()
          .logEvent(AnalyticsEvents.signUpAnonymously.name, parameters: {
        AnalyticsEventParameter.status.name: true,
      }));
      if (r.user != null) {
        unawaited(serviceLocator<Analytics>().setUserId(r.user!));
      }
    });
    return result;
  }
}

class SignUpAnonymouslyParams extends Equatable {
  final String? captchaToken;

  const SignUpAnonymouslyParams({required this.captchaToken});

  @override
  List<Object?> get props => [
        captchaToken,
      ];
}
