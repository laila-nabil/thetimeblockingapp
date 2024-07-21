import 'package:dartz/dartz.dart' as dartz; 

import '../../../../common/entities/user.dart';
import '../../../../core/error/failures.dart';
import '../entities/access_token.dart';
import '../use_cases/get_clickup_access_token_use_case.dart';
import '../use_cases/get_clickup_user_use_case.dart';

abstract class AuthRepo {
  Future<dartz.Either<Failure, AccessToken>> getClickupAccessToken(
      {required GetClickupAccessTokenParams params});

  Future<dartz.Either<Failure, User>> getClickupUser(
      {required GetClickupUserParams params});

  Future<dartz.Either<Failure, dartz.Unit>> signOut();

}
