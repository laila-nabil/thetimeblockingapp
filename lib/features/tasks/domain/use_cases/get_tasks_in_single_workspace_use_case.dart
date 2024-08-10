import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/enums/backend_mode.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/common/entities/access_token.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';

import '../entities/tasks_order_by.dart';

class GetTasksInSingleWorkspaceUseCase
    implements UseCase<List<Task>, GetTasksInWorkspaceParams> {
  final TasksRepo repo;

  GetTasksInSingleWorkspaceUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, List<Task>>?> call(
      GetTasksInWorkspaceParams params) {
    return repo.getTasksInWorkspace(params: params);
  }
}

class GetTasksInWorkspaceParams extends Equatable {
  final String workspaceId;
  final GetTasksInWorkspaceFiltersParams filtersParams;
  final BackendMode backendMode;
  const GetTasksInWorkspaceParams( {
    required this.workspaceId,
    required this.filtersParams,
    required this.backendMode,
  });

  @override
  List<Object?> get props => [workspaceId, filtersParams,backendMode];
}

class GetTasksInWorkspaceFiltersParams extends Equatable {
  final int? page;
  final TasksOrderBy? tasksOrderBy;
  final bool? reverse;
  final bool? includeSubtasks;
  final List<String>? filterBySpaceIds;
  final List<String>? filterByProjectIds;
  final List<String>? filterByListsIds;
  final List<String>? filterByStatuses;
  final bool? includeClosed;
  final List<String>? filterByAssignees;
  final List<String>? filterByTags;
  final int? filterByDueDateLessThanUnixTimeMilliseconds;
  final int? filterByDueDateGreaterThanUnixTimeMilliseconds;
  final int? filterByCreatedDateLessThanUnixTimeMilliseconds;
  final int? filterByCreatedDateGreaterThanUnixTimeMilliseconds;
  final int? filterByDateUpdatedLessThanUnixTimeMilliseconds;
  final int? filterByDateUpdatedGreaterThanUnixTimeMilliseconds;
  final int? filterByDateDoneLessThanUnixTimeMilliseconds;
  final int? filterByDateDoneGreaterThanUnixTimeMilliseconds;
  final List<String>? customFields;
  final bool? customTaskIds;
  final bool? includeParentTaskId;
  final AccessToken accessToken;

  const GetTasksInWorkspaceFiltersParams({
    this.page,
    this.tasksOrderBy,
    this.reverse,
    this.includeSubtasks,
    this.filterBySpaceIds,
    this.filterByListsIds,
    this.filterByProjectIds,
    this.filterByStatuses,
    this.includeClosed = true,
    this.filterByAssignees,
    this.filterByTags,
    this.filterByDueDateLessThanUnixTimeMilliseconds,
    this.filterByDueDateGreaterThanUnixTimeMilliseconds,
    this.filterByCreatedDateLessThanUnixTimeMilliseconds,
    this.filterByCreatedDateGreaterThanUnixTimeMilliseconds,
    this.filterByDateUpdatedLessThanUnixTimeMilliseconds,
    this.filterByDateUpdatedGreaterThanUnixTimeMilliseconds,
    this.filterByDateDoneLessThanUnixTimeMilliseconds,
    this.filterByDateDoneGreaterThanUnixTimeMilliseconds,
    this.customFields,
    this.customTaskIds,
    this.includeParentTaskId,
    required this.accessToken,
  });

  /*String get toUrlString {
    String result = '';
    if (props.length > 1) {
      result += "?";
    }
    if (page != null) {
      result += "page=$page&";
    }
    if (tasksOrderBy != null) {
      result += "order_by=${tasksOrderBy?.name}&";
    }
    if (reverse != null) {
      result += "reverse=$reverse&";
    }
    if (includeSubtasks != null) {
      result += "subtasks=$includeSubtasks&";
    }
    if (includeSubtasks != null) {
      result += "subtasks=$includeSubtasks&";
    }
    if (filterBySpaceIds != null) {
      result += "?";
      int index = 0;
      for (var element in filterBySpaceIds!) {
        result += "space_ids[]=$element";

        if (index + 1 == filterBySpaceIds?.length) {
          result += "&";
        }
        index++;
      }
    }
    if (filterByProjectIds != null) {
      result += "?";
      int index = 0;
      for (var element in filterByProjectIds!) {
        result += "project_ids[]=$element";

        if (index + 1 == filterByProjectIds?.length) {
          result += "&";
        }
        index++;
      }
    }
    if (filterByListsIds != null) {
      result += "?";
      int index = 0;
      for (var element in filterByListsIds!) {
        result += "list_ids[]=$element";

        if (index + 1 == filterByListsIds?.length) {
          result += "&";
        }
        index++;
      }
    }
    if (filterByStatuses != null) {
      result += "?";
      int index = 0;
      for (String element in filterByStatuses!) {
        result += "statuses[]=${element.replaceAll(" ", "%20")}";

        if (index + 1 == filterByStatuses?.length) {
          result += "&";
        }
        index++;
      }
    }
    if (includeClosed != null) {
      result += "include_closed=$includeClosed&";
    }
    if (filterByAssignees != null) {
      result += "?";
      int index = 0;
      for (var element in filterByAssignees!) {
        result += "assignees[]=$element";

        if (index + 1 == filterByAssignees?.length) {
          result += "&";
        }
        index++;
      }
    }
    if (filterByTags != null) {
      result += "?";
      int index = 0;
      for (String element in filterByTags!) {
        result += "tags[]=${element.replaceAll(" ", "%20")}";
        if (index + 1 == filterByTags?.length) {
          result += "&";
        }
        index++;
      }
    }
    if (filterByDueDateGreaterThanUnixTimeMilliseconds != null) {
      result += "due_date_gt=$filterByDueDateGreaterThanUnixTimeMilliseconds&";
    }
    if (filterByDueDateLessThanUnixTimeMilliseconds != null) {
      result += "due_date_lt=$filterByDueDateLessThanUnixTimeMilliseconds&";
    }
    if (filterByCreatedDateGreaterThanUnixTimeMilliseconds != null) {
      result +=
          "date_created_gt=$filterByCreatedDateGreaterThanUnixTimeMilliseconds&";
    }
    if (filterByCreatedDateLessThanUnixTimeMilliseconds != null) {
      result +=
          "date_created_lt=$filterByCreatedDateLessThanUnixTimeMilliseconds&";
    }
    if (filterByDateUpdatedGreaterThanUnixTimeMilliseconds != null) {
      result +=
          "date_updated_gt=$filterByDateUpdatedGreaterThanUnixTimeMilliseconds&";
    }
    if (filterByDateUpdatedLessThanUnixTimeMilliseconds != null) {
      result +=
          "date_updated_lt=$filterByDateUpdatedLessThanUnixTimeMilliseconds&";
    }
    if (filterByDateDoneGreaterThanUnixTimeMilliseconds != null) {
      result +=
          "date_done_gt=$filterByDateDoneGreaterThanUnixTimeMilliseconds&";
    }
    if (filterByDateDoneLessThanUnixTimeMilliseconds != null) {
      result += "date_done_lt=$filterByDateDoneLessThanUnixTimeMilliseconds&";
    }


    if (customTaskIds != null) {
      result += "custom_task_ids=$customTaskIds&";
    }
    if (customTaskIds != null) {
      result += "custom_task_ids=$customTaskIds&";
    }

    return result;
  }*/

  Map<String, dartz.Either<List<dynamic>, String>> get query {
    Map<String, dartz.Either<List<dynamic>, String>> result = {};
    if (page != null) {
      result["page"] = dartz.Right(page.toString());
    }
    if (tasksOrderBy?.name != null) {
      result["order_by"] = dartz.Right(tasksOrderBy?.name ?? "");
    }
    if (reverse != null) {
      result["reverse"] = dartz.Right(reverse.toString());
    }
    if (includeSubtasks != null) {
      result["subtasks"] = dartz.Right(includeSubtasks.toString());
    }
    if (filterBySpaceIds != null) {
      result["space_ids"] = dartz.Left(filterBySpaceIds ?? []);
    }
    if (filterByProjectIds != null) {
      result["project_ids"] = dartz.Left(filterByProjectIds ?? []);
    }
    if (filterByListsIds != null) {
      result["list_ids"] = dartz.Left(filterByListsIds ?? []);
    }
    if (filterByStatuses != null) {
      result["statuses"] = dartz.Left(filterByStatuses ?? []);
    }
    if (includeClosed != null) {
      result["include_closed"] = dartz.Right((includeClosed ?? false).toString());
    }
    if (filterByAssignees != null) {
      result["assignees"] = dartz.Left(filterByAssignees ?? []);
    }
    if (filterByTags != null) {
      result["tags"] = dartz.Left(filterByTags ?? []);
    }
    if (filterByDueDateGreaterThanUnixTimeMilliseconds != null) {
      result["due_date_gt"] = dartz.Right(filterByDueDateGreaterThanUnixTimeMilliseconds.toString());
    }
    if (filterByDueDateLessThanUnixTimeMilliseconds != null) {
      result["due_date_lt"] = dartz.Right(filterByDueDateLessThanUnixTimeMilliseconds.toString());
    }
    if (filterByCreatedDateGreaterThanUnixTimeMilliseconds != null) {
      result["date_created_gt"] =
          dartz.Right(filterByCreatedDateGreaterThanUnixTimeMilliseconds.toString());
    }
    if (filterByCreatedDateLessThanUnixTimeMilliseconds != null) {
      result["date_created_lt"] =
          dartz.Right(filterByCreatedDateLessThanUnixTimeMilliseconds.toString());
    }
    if (filterByDateUpdatedGreaterThanUnixTimeMilliseconds != null) {
      result["date_updated_gt"] =
          dartz.Right(filterByDateUpdatedGreaterThanUnixTimeMilliseconds.toString());
    }
    if (filterByDateUpdatedLessThanUnixTimeMilliseconds != null) {
      result["date_updated_lt"] =
          dartz.Right(filterByDateUpdatedLessThanUnixTimeMilliseconds.toString());
    }
    if (filterByDateDoneGreaterThanUnixTimeMilliseconds != null) {
      result["date_done_gt"] =dartz.Right( filterByDateDoneGreaterThanUnixTimeMilliseconds.toString());
    }
    if (filterByDateDoneLessThanUnixTimeMilliseconds != null) {
      result["date_done_lt"] = dartz.Right(filterByDateDoneLessThanUnixTimeMilliseconds.toString());
    }


    if (customTaskIds != null) {
      result["custom_task_ids"] = dartz.Right(customTaskIds.toString());
    }
    printDebug("query $result");
    return result;
  }

  /*Map<String,String> queryList<T>({required String key,required List<T> list}){
    Map<String,String> result = {};
    for (var element in list) {
      result["$key[]"] = "$element";
    }
    return result;
    
  }*/
  @override
  List<Object?> get props => [
        page,
        tasksOrderBy,
        reverse,
        includeSubtasks,
        filterBySpaceIds,
        filterByListsIds,
        filterByProjectIds,
        filterByStatuses,
        includeClosed,
        filterByAssignees,
        filterByTags,
        filterByDueDateLessThanUnixTimeMilliseconds,
        filterByDueDateGreaterThanUnixTimeMilliseconds,
        filterByCreatedDateLessThanUnixTimeMilliseconds,
        filterByCreatedDateGreaterThanUnixTimeMilliseconds,
        filterByDateUpdatedLessThanUnixTimeMilliseconds,
        filterByDateUpdatedGreaterThanUnixTimeMilliseconds,
        filterByDateDoneLessThanUnixTimeMilliseconds,
        filterByDateDoneGreaterThanUnixTimeMilliseconds,
        customFields,
        customTaskIds,
        includeParentTaskId,
        accessToken,
      ];

  GetTasksInWorkspaceFiltersParams copyWith({
    int? page,
    TasksOrderBy? tasksOrderBy,
    bool? reverse,
    bool? includeSubtasks,
    List<String>? filterBySpaceIds,
    List<String>? filterByProjectIds,
    List<String>? filterByListsIds,
    List<String>? filterByStatuses,
    bool? includeClosed,
    List<String>? filterByAssignees,
    List<String>? filterByTags,
    int? filterByDueDateLessThanUnixTimeMilliseconds,
    int? filterByDueDateGreaterThanUnixTimeMilliseconds,
    int? filterByCreatedDateLessThanUnixTimeMilliseconds,
    int? filterByCreatedDateGreaterThanUnixTimeMilliseconds,
    int? filterByDateUpdatedLessThanUnixTimeMilliseconds,
    int? filterByDateUpdatedGreaterThanUnixTimeMilliseconds,
    int? filterByDateDoneLessThanUnixTimeMilliseconds,
    int? filterByDateDoneGreaterThanUnixTimeMilliseconds,
    List<String>? customFields,
    bool? customTaskIds,
    bool? includeParentTaskId,
    AccessToken? accessToken,
  }) {
    return GetTasksInWorkspaceFiltersParams(
      page: page ?? this.page,
      tasksOrderBy: tasksOrderBy ?? this.tasksOrderBy,
      reverse: reverse ?? this.reverse,
      includeSubtasks: includeSubtasks ?? this.includeSubtasks,
      filterBySpaceIds: filterBySpaceIds ?? this.filterBySpaceIds,
      filterByProjectIds: filterByProjectIds ?? this.filterByProjectIds,
      filterByListsIds: filterByListsIds ?? this.filterByListsIds,
      filterByStatuses: filterByStatuses ?? this.filterByStatuses,
      includeClosed: includeClosed ?? this.includeClosed,
      filterByAssignees: filterByAssignees ?? this.filterByAssignees,
      filterByTags: filterByTags ?? this.filterByTags,
      filterByDueDateLessThanUnixTimeMilliseconds:
          filterByDueDateLessThanUnixTimeMilliseconds ??
              this.filterByDueDateLessThanUnixTimeMilliseconds,
      filterByDueDateGreaterThanUnixTimeMilliseconds:
          filterByDueDateGreaterThanUnixTimeMilliseconds ??
              this.filterByDueDateGreaterThanUnixTimeMilliseconds,
      filterByCreatedDateLessThanUnixTimeMilliseconds:
          filterByCreatedDateLessThanUnixTimeMilliseconds ??
              this.filterByCreatedDateLessThanUnixTimeMilliseconds,
      filterByCreatedDateGreaterThanUnixTimeMilliseconds:
          filterByCreatedDateGreaterThanUnixTimeMilliseconds ??
              this.filterByCreatedDateGreaterThanUnixTimeMilliseconds,
      filterByDateUpdatedLessThanUnixTimeMilliseconds:
          filterByDateUpdatedLessThanUnixTimeMilliseconds ??
              this.filterByDateUpdatedLessThanUnixTimeMilliseconds,
      filterByDateUpdatedGreaterThanUnixTimeMilliseconds:
          filterByDateUpdatedGreaterThanUnixTimeMilliseconds ??
              this.filterByDateUpdatedGreaterThanUnixTimeMilliseconds,
      filterByDateDoneLessThanUnixTimeMilliseconds:
          filterByDateDoneLessThanUnixTimeMilliseconds ??
              this.filterByDateDoneLessThanUnixTimeMilliseconds,
      filterByDateDoneGreaterThanUnixTimeMilliseconds:
          filterByDateDoneGreaterThanUnixTimeMilliseconds ??
              this.filterByDateDoneGreaterThanUnixTimeMilliseconds,
      customFields: customFields ?? this.customFields,
      customTaskIds: customTaskIds ?? this.customTaskIds,
      includeParentTaskId: includeParentTaskId ?? this.includeParentTaskId,
      accessToken: accessToken ?? this.accessToken,
    );
  }
}
