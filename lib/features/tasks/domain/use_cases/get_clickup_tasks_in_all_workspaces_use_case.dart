import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'get_clickup_tasks_in_single_workspace_use_case.dart';

class GetClickupTasksInAllWorkspacesUseCase {
  final GetClickupTasksInSingleWorkspaceUseCase getClickupTasksInSingleWorkspaceUseCase;
  GetClickupTasksInAllWorkspacesUseCase(this.getClickupTasksInSingleWorkspaceUseCase);

  Future<Map<String, Either<Failure, List<ClickupTask>>?>> call(
      GetClickupTasksInAllWorkspacesParams params) async {
    Map<String,Either<Failure,List<ClickupTask>>?> result = {};
    for (var element in params.workspacesIds) {
      result[element] = await getClickupTasksInSingleWorkspaceUseCase(
          GetClickupTasksInWorkspaceParams(
              workspaceId: element, filtersParams: params.filtersParams));
    }
    return result;
  }
}

class GetClickupTasksInAllWorkspacesParams extends Equatable {
  final List<String> workspacesIds;
  final GetClickupTasksInWorkspaceFiltersParams filtersParams;

  const GetClickupTasksInAllWorkspacesParams({
    required this.workspacesIds,
    required this.filtersParams,
  });

  @override
  List<Object?> get props => [workspacesIds, filtersParams];
}
