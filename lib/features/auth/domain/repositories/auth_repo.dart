import 'package:dartz/dartz.dart';

import '../../../../common/entities/clickup_user.dart';
import '../../../../core/error/failures.dart';
import '../entities/clickup_access_token.dart';
import '../use_cases/get_clickup_access_token_use_case.dart';
import '../use_cases/get_clickup_user_use_case.dart';

abstract class AuthRepo {
  Future<Either<Failure, ClickUpAccessToken>> getClickUpAccessToken(
      {required GetClickUpAccessTokenParams params});

  Future<Either<Failure, ClickupUser>> getClickUpUser(
      {required GetClickUpUserParams params});

}
