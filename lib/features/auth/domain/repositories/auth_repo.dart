import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/features/auth/domain/use_cases/sign_in_use_case.dart';

import '../../../../common/entities/user.dart';
import '../../../../core/error/failures.dart';
import '../../../../common/entities/access_token.dart';
import '../entities/sign_in_result.dart';
import '../use_cases/get_access_token_use_case.dart';
import '../use_cases/get_user_use_case.dart';

abstract class AuthRepo {
  Future<dartz.Either<Failure, AccessToken>> getAccessToken(
      {required GetAccessTokenParams params});

  Future<dartz.Either<Failure, User>> getUser(
      {required GetClickupUserParams params});

  Future<dartz.Either<Failure, dartz.Unit>> signOut();

  Future<dartz.Either<Failure, SignInResult>> signIn(
      {required SignInParams params});
}
