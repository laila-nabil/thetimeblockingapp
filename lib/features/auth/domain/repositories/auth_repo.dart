import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/common/entities/access_token.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/sign_in_use_case.dart';

import '../../../../core/error/failures.dart';
import '../entities/sign_in_result.dart';

abstract class AuthRepo {

  Future<dartz.Either<Failure, dartz.Unit>> signOut(AccessToken accessToken);

  Future<dartz.Either<Failure, SignInResult>> signIn(
      {required SignInParams params});
}
