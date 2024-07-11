import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/auth/domain/entities/clickup_access_token.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/list.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';

class GetClickupListUseCase
    implements UseCase<ClickupList, GetClickupListParams> {
  final TasksRepo repo;

  GetClickupListUseCase(this.repo);

  @override
  Future<Either<Failure, ClickupList>?> call(GetClickupListParams params) {
    return repo.getClickupList(params);
  }
}

class GetClickupListParams {
  final String listId;
  final ClickupAccessToken clickupAccessToken;

  GetClickupListParams(
      {required this.listId, required this.clickupAccessToken});
}
