import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/clickup_user.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/auth/domain/repositories/auth_repo.dart';

import '../../../../core/analytics/analytics.dart';
import '../../../../core/injection_container.dart';
import '../entities/clickup_access_token.dart';

class GetClickupUserUseCase
    implements UseCase<ClickupUser, GetClickupUserParams> {
  final AuthRepo repo;

  GetClickupUserUseCase(this.repo);

  @override
  Future<Either<Failure, ClickupUser>?> call(
      GetClickupUserParams params) async {
    final result = await repo.getClickupUser(params: params);
    if (result.isRight()) {
      late ClickupUser user;
      result.fold((l) => null, (r) => user = r);
      serviceLocator<Analytics>().setUserId(user.id.toString());
    }
    return result;
  }
}

class GetClickupUserParams extends Equatable {
  final ClickupAccessToken clickupAccessToken;

  const GetClickupUserParams(this.clickupAccessToken);

  @override
  List<Object?> get props => [clickupAccessToken];
}
