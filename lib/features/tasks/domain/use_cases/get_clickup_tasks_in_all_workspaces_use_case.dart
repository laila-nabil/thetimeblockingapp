import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task.dart';
import '../../../../core/print_debug.dart';
import 'get_clickup_tasks_in_single_workspace_use_case.dart';


class GetClickupTasksInAllWorkspacesUseCase {
  final GetClickupTasksInSingleWorkspaceUseCase getClickupTasksInSingleWorkspaceUseCase;
  GetClickupTasksInAllWorkspacesUseCase(this.getClickupTasksInSingleWorkspaceUseCase);

  Future<Map<String, dartz.Either<Failure, List<Task>>?>> call(
      GetClickupTasksInAllWorkspacesParams params) async {
    Map<String,dartz.Either<Failure,List<Task>>?> result = {};
    for (var element in params.workspacesIds) {
      result[element] = await getClickupTasksInSingleWorkspaceUseCase(
          GetClickupTasksInWorkspaceParams(
              workspaceId: element, filtersParams: params.filtersParams));
    }
    printDebug("result $result");
    return result;
  }
}

class GetClickupTasksInAllWorkspacesParams extends Equatable {
  final List<String> workspacesIds;
  final GetTasksInWorkspaceFiltersParams filtersParams;

  const GetClickupTasksInAllWorkspacesParams({
    required this.workspacesIds,
    required this.filtersParams,
  });

  @override
  List<Object?> get props => [workspacesIds, filtersParams];
}
