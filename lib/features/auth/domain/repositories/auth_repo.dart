import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/common/entities/user.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/sign_up_anonymously_use_case.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/update_user_use_case.dart';

import '../../../../core/error/failures.dart';
import '../entities/sign_in_result.dart';
import '../entities/sign_up_anonymously_result.dart';
import '../entities/sign_up_result.dart';
import '../use_cases/delete_account_use_case.dart';

abstract class AuthRepo {

  Future<dartz.Either<Failure, dartz.Unit>> signOut();

  Future<dartz.Either<Failure, SignInResult>> signIn(
      {required SignInParams params});

  Future<dartz.Either<Failure, SignUpResult>> signUp(
      {required SignUpParams params});

  Future<dartz.Either<Failure, dartz.Unit>> deleteAccount(DeleteAccountParams params);

  Future<dartz.Either<Failure, SignUpAnonymouslyResult>> signUpAnonymously(
      {required SignUpAnonymouslyParams params});

  Future<dartz.Either<Failure, User>> updateUser({required UpdateUserParams params});
}
