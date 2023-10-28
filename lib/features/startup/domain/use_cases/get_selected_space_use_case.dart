import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/startup/domain/repositories/startup_repo.dart';

import '../../../tasks/domain/entities/clickup_space.dart';

///TODO use the use case
class GetSelectedSpaceUseCase
    implements UseCase<ClickupSpace, NoParams> {
  final StartUpRepo repo;

  GetSelectedSpaceUseCase(this.repo);

  @override
  Future<Either<Failure, ClickupSpace>?> call(
      NoParams params) async {
    var selectedSpace = await repo.getSelectedSpace(params);
    selectedSpace?.fold((l) => null, (r) => Globals.selectedSpace = r);
    return selectedSpace;
  }
}
