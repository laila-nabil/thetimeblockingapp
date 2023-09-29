import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/clickup_user.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/auth/domain/repositories/auth_repo.dart';

import '../entities/clickup_access_token.dart';

class GetClickUpUserUseCase
    implements UseCase<ClickupUser, GetClickUpUserParams> {
  final AuthRepo repo;

  GetClickUpUserUseCase(this.repo);
  @override
  Future<Either<Failure, ClickupUser>?> call(GetClickUpUserParams params) {
    return repo.getClickUpUser(params: params);
  }

}

class GetClickUpUserParams extends Equatable {
  final ClickUpAccessToken clickUpAccessToken;

  const GetClickUpUserParams(this.clickUpAccessToken);

  @override
  List<Object?> get props => [clickUpAccessToken];
}
