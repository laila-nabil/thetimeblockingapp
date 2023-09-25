import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/common/entities/clickup_user.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/auth/domain/repositories/auth_repo.dart';

class GetClickUpUserUseCase
    implements UseCase<ClickupUser, NoParams> {
  final AuthRepo repo;

  GetClickUpUserUseCase(this.repo);
  @override
  Future<Either<Failure, ClickupUser>?> call(NoParams params) {
    return repo.getClickUpUser(params: params);
  }

}
