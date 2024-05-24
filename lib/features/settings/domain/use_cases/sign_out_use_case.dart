import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/auth/domain/repositories/auth_repo.dart';

import '../../../../core/analytics/analytics.dart';
import '../../../../core/injection_container.dart';

class SignOutUseCase implements UseCase<Unit, NoParams> {
  final AuthRepo authRepo;

  SignOutUseCase(this.authRepo);

  @override
  Future<Either<Failure, Unit>?> call(NoParams params) async{
    final result = await authRepo.signOut();
    if (result.isRight()) {
      serviceLocator<Analytics>().resetUser();
    }
    return result;
  }
}
