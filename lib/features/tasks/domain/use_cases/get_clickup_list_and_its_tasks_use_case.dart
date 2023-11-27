import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/features/auth/domain/entities/clickup_access_token.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_list.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_clickup_list_use_case.dart';

import '../../../../core/globals.dart';
import '../entities/clickup_task.dart';
import 'get_clickup_tasks_in_single_workspace_use_case.dart';

class GetClickupListAndItsTasksUseCase {
  final TasksRepo repo;

  GetClickupListAndItsTasksUseCase(this.repo);

  GetClickupTasksInWorkspaceFiltersParams
      get defaultTasksInWorkspaceFiltersParams {
    List<String>? filterBySpaceIds;
    if (Globals.isSpaceAppWide && Globals.selectedSpaceId != null) {
      filterBySpaceIds = [Globals.selectedSpace?.id ?? ""];
    }
    return GetClickupTasksInWorkspaceFiltersParams(
      filterBySpaceIds: filterBySpaceIds,
      clickupAccessToken: Globals.clickupAuthAccessToken,
      filterByAssignees: [Globals.clickupUser?.id.toString() ?? ""],
    );
  }

  Future<GetClickupListAndItsTasksResult?> call(
      GetClickupListAndItsTasksParams params) async {
    final listResult = await repo.getClickupList(GetClickupListParams(
        listId: params.listId, clickupAccessToken: params.clickupAccessToken));
    final tasksResult = await repo.getTasksInWorkspace(
        params: GetClickupTasksInWorkspaceParams(
            workspaceId: Globals.selectedWorkspace?.id ?? "",
            filtersParams: defaultTasksInWorkspaceFiltersParams
                .copyWith(filterByListsIds: [params.listId])));

    return GetClickupListAndItsTasksResult(
        listResult: listResult, tasksResult: tasksResult);
  }
}

class GetClickupListAndItsTasksParams extends Equatable{
  final String listId;
  final ClickupAccessToken clickupAccessToken;

  const GetClickupListAndItsTasksParams(
      {required this.listId, required this.clickupAccessToken});

  @override
  List<Object?> get props => [listId,clickupAccessToken];

}

class GetClickupListAndItsTasksResult extends Equatable {
  final Either<Failure, ClickupList>? listResult;
  final Either<Failure, List<ClickupTask>> tasksResult;

  const GetClickupListAndItsTasksResult(
      {required this.listResult, required this.tasksResult});

  @override
  List<Object?> get props => [listResult, tasksResult];
}
