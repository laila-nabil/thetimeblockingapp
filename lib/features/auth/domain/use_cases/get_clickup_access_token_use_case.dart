import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/auth/domain/entities/clickup_access_token.dart';

class GetClickUpAccessTokenUseCase
    implements UseCase<ClickUpAccessToken, GetClickUpAccessTokenParams> {
  @override
  Future<Either<Failure, ClickUpAccessToken>?> call(
      GetClickUpAccessTokenParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class GetClickUpAccessTokenParams extends Equatable {
  final String code;

  const GetClickUpAccessTokenParams(this.code);

  @override
  List<Object?> get props => [code];
}
