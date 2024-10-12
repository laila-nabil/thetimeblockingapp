import 'dart:async';

import 'package:dartz/dartz.dart' as dartz;
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/user.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/auth/domain/repositories/auth_repo.dart';
import 'package:thetimeblockingapp/features/settings/domain/repositories/settings_repo.dart';

import '../../../../core/analytics/analytics.dart';
import '../../../../core/injection_container.dart';

class DeleteAccountUseCase implements UseCase<dartz.Unit, DeleteAccountParams> {
  final AuthRepo repo;

  DeleteAccountUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, dartz.Unit>> call(DeleteAccountParams params) async {
    final result = await repo.deleteAccount(params);
    await result.fold(
        (l) async => unawaited(serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.deleteAccount.name, parameters: {
              AnalyticsEventParameter.status.name: false,
              AnalyticsEventParameter.error.name: l.toString()
            })), (r) async {
      unawaited(serviceLocator<Analytics>().logEvent(
          AnalyticsEvents.deleteAccount.name,
          parameters: {AnalyticsEventParameter.status.name: true}));
      unawaited(serviceLocator<Analytics>().resetUser());
    });
    return result;
  }
}

class DeleteAccountParams extends Equatable {
  final User user;

  DeleteAccountParams(this.user);

  @override
  List<Object?> get props => [user];
}
