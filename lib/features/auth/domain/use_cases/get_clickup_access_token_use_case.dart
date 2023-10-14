import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/auth/domain/entities/clickup_access_token.dart';

import '../repositories/auth_repo.dart';

class GetClickupAccessTokenUseCase
    implements UseCase<ClickupAccessToken, GetClickupAccessTokenParams> {
  final AuthRepo repo;

  GetClickupAccessTokenUseCase(this.repo);
  @override
  Future<Either<Failure, ClickupAccessToken>?> call(
      GetClickupAccessTokenParams params) {
    return repo.getClickupAccessToken(params: params);
  }
}

class GetClickupAccessTokenParams extends Equatable {
  final String code;

  const GetClickupAccessTokenParams(this.code);

  @override
  List<Object?> get props => [code];
}
