import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/clickup_user.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/auth/domain/repositories/auth_repo.dart';

import '../entities/clickup_access_token.dart';

class GetClickupUserUseCase
    implements UseCase<ClickupUser, GetClickupUserParams> {
  final AuthRepo repo;

  GetClickupUserUseCase(this.repo);
  @override
  Future<Either<Failure, ClickupUser>?> call(GetClickupUserParams params) {
    return repo.getClickupUser(params: params);
  }

}

class GetClickupUserParams extends Equatable {
  final ClickupAccessToken clickupAccessToken;

  const GetClickupUserParams(this.clickupAccessToken);

  @override
  List<Object?> get props => [clickupAccessToken];
}
