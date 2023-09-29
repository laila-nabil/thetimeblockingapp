import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'get_clickup_tasks_in_single_workspace_use_case.dart';

class GetClickUpTasksInAllWorkspacesUseCase {
  final GetClickUpTasksInSingleWorkspaceUseCase getClickUpTasksInSingleWorkspaceUseCase;
  GetClickUpTasksInAllWorkspacesUseCase(this.getClickUpTasksInSingleWorkspaceUseCase);

  Future<Map<String, Either<Failure, List<ClickupTask>>?>> call(
      GetClickUpTasksInAllWorkspacesParams params) async {
    Map<String,Either<Failure,List<ClickupTask>>?> result = {};
    for (var element in params.workspacesIds) {
      result[element] = await getClickUpTasksInSingleWorkspaceUseCase(
          GetClickUpTasksInWorkspaceParams(
              workspaceId: element, filtersParams: params.filtersParams));
    }
    return result;
  }
}

class GetClickUpTasksInAllWorkspacesParams extends Equatable {
  final List<String> workspacesIds;
  final GetClickUpTasksInWorkspaceFiltersParams filtersParams;

  const GetClickUpTasksInAllWorkspacesParams({
    required this.workspacesIds,
    required this.filtersParams,
  });

  @override
  List<Object?> get props => [workspacesIds, filtersParams];
}
