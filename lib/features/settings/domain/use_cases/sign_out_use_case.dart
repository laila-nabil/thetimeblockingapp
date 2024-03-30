import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/auth/domain/repositories/auth_repo.dart';

class SignOutUseCase implements UseCase<Unit, NoParams> {
  final AuthRepo authRepo;

  SignOutUseCase(this.authRepo);

  @override
  Future<Either<Failure, Unit>?> call(NoParams params) {
    return authRepo.signOut();
  }
}
