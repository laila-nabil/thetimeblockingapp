import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';

import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/clickup_list.dart';
import '../repositories/tasks_repo.dart';

class DeleteClickupListUseCase
    implements UseCase<Unit, DeleteClickupListParams> {
  final TasksRepo repo;

  DeleteClickupListUseCase(this.repo);
  @override
  Future<Either<Failure, Unit>?> call(DeleteClickupListParams params) {
    return repo.deleteList(params);
  }
}

class DeleteClickupListParams {
  final ClickupList list;
  final ClickupAccessToken clickupAccessToken;
  DeleteClickupListParams({required this.list,required this.clickupAccessToken, });

  String get listId => list.id ?? "";
}
