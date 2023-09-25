import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/common/enums/clickup_user.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';

class GetClickUpUserUseCase
    implements UseCase<ClickupUser, NoParams> {
  @override
  Future<Either<Failure, ClickupUser>?> call(NoParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }

}
