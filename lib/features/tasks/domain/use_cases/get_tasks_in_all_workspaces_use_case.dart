import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';
import '../../../../core/print_debug.dart';
import 'get_tasks_in_single_workspace_use_case.dart';


class GetTasksInAllWorkspacesUseCase {
  final GetTasksInSingleWorkspaceUseCase getTasksInSingleWorkspaceUseCase;
  GetTasksInAllWorkspacesUseCase(this.getTasksInSingleWorkspaceUseCase);

  Future<Map<int, dartz.Either<Failure, List<Task>>?>> call(
      GetTasksInAllWorkspacesParams params) async {
    Map<int,dartz.Either<Failure,List<Task>>?> result = {};
    for (var element in params.workspacesIds) {
      result[element] = await getTasksInSingleWorkspaceUseCase(
          GetTasksInWorkspaceParams(
              workspaceId: element, filtersParams: params.filtersParams,
              backendMode: Globals.backendMode));
    }
    printDebug("result $result");
    return result;
  }
}

class GetTasksInAllWorkspacesParams extends Equatable {
  final List<int> workspacesIds;
  final GetTasksInWorkspaceFiltersParams filtersParams;

  const GetTasksInAllWorkspacesParams({
    required this.workspacesIds,
    required this.filtersParams,
  });

  @override
  List<Object?> get props => [workspacesIds, filtersParams];
}
