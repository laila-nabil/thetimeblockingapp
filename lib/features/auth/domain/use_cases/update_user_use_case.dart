import 'dart:async';

import 'package:dartz/dartz.dart' as dartz;
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/access_token.dart';
import 'package:thetimeblockingapp/common/entities/user.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/auth/domain/entities/sign_up_anonymously_result.dart';

import '../repositories/auth_repo.dart';

class UpdateUserUseCase implements UseCase<User, UpdateUserParams> {
  final AuthRepo repo;

  UpdateUserUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, User>?> call(UpdateUserParams params) async {
    final result = await repo.updateUser(params: params);
    result.fold(
        (l) => unawaited(serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.updateUser.name, parameters: {
              AnalyticsEventParameter.status.name: false,
              AnalyticsEventParameter.error.name: l.toString(),
            })), (r) => unawaited(serviceLocator<Analytics>()
          .logEvent(AnalyticsEvents.updateUser.name, parameters: {
        AnalyticsEventParameter.status.name: true,
      })));
    return result;
  }
}

class UpdateUserParams extends Equatable {
  final String? email;
  final String? password;
  final AccessToken accessToken;
  UpdateUserParams({required this.email, required this.password,required this.accessToken});

  @override
  List<Object?> get props => [email, password,accessToken];

  Map<String, dynamic> toMap() {
    return {
     if(email!=null) 'email': this.email,
    if(password!=null) 'password': this.password,
    };
  }
}
