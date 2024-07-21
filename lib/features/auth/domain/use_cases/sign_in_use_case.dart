import 'package:dartz/dartz.dart' as dartz;
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/auth/domain/entities/access_token.dart';

import '../repositories/auth_repo.dart';

class SignInUseCase implements UseCase<AccessToken, SignInParams> {
  final AuthRepo repo;

  SignInUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, AccessToken>?> call(SignInParams params) async {
    final result = await repo.signIn(params: params);
    await result.fold(
        (l) async => await serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.signIn.name, parameters: {
              AnalyticsEventParameter.status.name: false,
              AnalyticsEventParameter.error.name: l.toString(),
            }),
        (r) async => await serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.signIn.name, parameters: {
              AnalyticsEventParameter.status.name: true,
            }));
    return result;
  }
}

class SignInParams extends Equatable {
  final String email;
  final String password;

  const SignInParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
