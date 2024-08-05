import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/common/entities/access_token.dart';
import 'package:thetimeblockingapp/common/entities/tasks_list.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_list_use_case.dart';

import '../../../../core/globals.dart';
import '../../../../common/entities/task.dart';
import 'get_tasks_in_single_workspace_use_case.dart';

class GetListAndItsTasksUseCase {
  final TasksRepo repo;

  GetListAndItsTasksUseCase(this.repo);

  GetTasksInWorkspaceFiltersParams
      get defaultTasksInWorkspaceFiltersParams {
    List<String>? filterBySpaceIds;
    if (Globals.isSpaceAppWide && Globals.selectedSpaceId != null) {
      filterBySpaceIds = [Globals.selectedSpace?.id ?? ""];
    }
    return GetTasksInWorkspaceFiltersParams(
      filterBySpaceIds: filterBySpaceIds,
      accessToken: Globals.accessToken,
      filterByAssignees: [Globals.user?.id.toString() ?? ""],
    );
  }

  Future<GetClickupListAndItsTasksResult?> call(
      GetListAndItsTasksParams params) async {
    final listResult = await repo.getList(GetListParams(
        listId: params.listId, clickupAccessToken: params.accessToken));
    await listResult?.fold(
        (l) async => await serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.getData.name, parameters: {
              AnalyticsEventParameter.data.name: "lists",
              AnalyticsEventParameter.status.name: false,
              AnalyticsEventParameter.error.name: l.toString(),
            }),
        (r) async => await serviceLocator<Analytics>()
                .logEvent(AnalyticsEvents.getData.name, parameters: {
              AnalyticsEventParameter.data.name: "lists",
              AnalyticsEventParameter.status.name: true,
            }));
    final tasksResult = await repo.getTasksInWorkspace(
        params: GetTasksInWorkspaceParams(
            workspaceId: Globals.selectedWorkspace?.id ?? "",
            filtersParams: defaultTasksInWorkspaceFiltersParams
                .copyWith(filterByListsIds: [params.listId]),
            backendMode: Globals.backendMode));

    await tasksResult.fold(
            (l) async => await serviceLocator<Analytics>()
            .logEvent(AnalyticsEvents.getData.name, parameters: {
          AnalyticsEventParameter.data.name: "tasks",
          AnalyticsEventParameter.status.name: false,
          AnalyticsEventParameter.error.name: l.toString(),
        }),
            (r) async => await serviceLocator<Analytics>()
            .logEvent(AnalyticsEvents.getData.name, parameters: {
          AnalyticsEventParameter.data.name: "tasks",
          AnalyticsEventParameter.status.name: true,
        }));

    return GetClickupListAndItsTasksResult(
        listResult: listResult, tasksResult: tasksResult);
  }
}

class GetListAndItsTasksParams extends Equatable {
  final String listId;
  final AccessToken accessToken;

  const GetListAndItsTasksParams(
      {required this.listId, required this.accessToken});

  @override
  List<Object?> get props => [listId, accessToken];
}

class GetClickupListAndItsTasksResult extends Equatable {
  final dartz.Either<Failure, TasksList>? listResult;
  final dartz.Either<Failure, List<Task>> tasksResult;

  const GetClickupListAndItsTasksResult(
      {required this.listResult, required this.tasksResult});

  @override
  List<Object?> get props => [listResult, tasksResult];
}
