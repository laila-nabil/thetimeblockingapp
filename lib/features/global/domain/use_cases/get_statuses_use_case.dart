import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/common/entities/status.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/global/domain/repositories/global_repo.dart';


class GetStatusesUseCase implements UseCase<List<TaskStatus>,GetStatusesParams>{
  final GlobalRepo repo;

  GetStatusesUseCase(this.repo);
  @override
  Future<Either<Failure, List<TaskStatus>>> call(GetStatusesParams params) {
    return repo.getStatuses(params);
  }

}

class GetStatusesParams{
final LanguagesEnum languagesEnum;

  GetStatusesParams(this.languagesEnum);
}