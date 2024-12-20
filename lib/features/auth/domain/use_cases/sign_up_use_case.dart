import 'dart:async';

import 'package:dartz/dartz.dart' as dartz;
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/access_token.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/auth/domain/entities/sign_up_result.dart';

import '../repositories/auth_repo.dart';

class SignUpUseCase implements UseCase<SignUpResult, SignUpParams> {
  final AuthRepo repo;

  SignUpUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, SignUpResult>?> call(SignUpParams params) async {
    final result = await repo.signUp(params: params);
    await result.fold(
        (l) async => unawaited(serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.signUp.name, parameters: {
              AnalyticsEventParameter.status.name: false,
              AnalyticsEventParameter.error.name: l.toString(),
            })),
        (r) async => unawaited(serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.signUp.name, parameters: {
              AnalyticsEventParameter.status.name: true,
            })));
    return result;
  }
}

class SignUpParams extends Equatable {
  final String email;
  final String password;
  final AccessToken accessToken;
  const SignUpParams({
    required this.email,
    required this.password,
    required this.accessToken,
  });

  @override
  List<Object?> get props => [email, password,accessToken];
}