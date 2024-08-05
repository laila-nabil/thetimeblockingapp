import 'package:dartz/dartz.dart' as dartz; 
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/common/entities/access_token.dart';
import 'package:thetimeblockingapp/common/entities/tasks_list.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';

class GetListUseCase
    implements UseCase<TasksList, GetListParams> {
  final TasksRepo repo;

  GetListUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, TasksList>?> call(GetListParams params) {
    return repo.getList(params);
  }
}

class GetListParams {
  final String listId;
  final AccessToken clickupAccessToken;

  GetListParams(
      {required this.listId, required this.clickupAccessToken});
}
