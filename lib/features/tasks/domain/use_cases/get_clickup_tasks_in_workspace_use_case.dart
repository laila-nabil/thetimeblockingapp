import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';

import '../entities/tasks_order_by.dart';

class GetClickUpTasksInWorkspaceUseCase
    implements UseCase<List<ClickupTask>, GetClickUpTasksInWorkspaceParams> {
  @override
  Future<Either<Failure, List<ClickupTask>>?> call(
      GetClickUpTasksInWorkspaceParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class GetClickUpTasksInWorkspaceParams extends Equatable {
  final String workspaceId;
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

  const GetClickUpTasksInWorkspaceParams({
    required this.workspaceId,
    this.page,
    this.tasksOrderBy,
    this.reverse,
    this.includeSubtasks,
    this.filterBySpaceIds,
    this.filterByListsIds,
    this.filterByProjectIds,
    this.filterByStatuses,
    this.includeClosed,
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
  });

  String get toUrlString {
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

    ///TODO custom fields

    if (customTaskIds != null) {
      result += "custom_task_ids=$customTaskIds&";
    }
    if (customTaskIds != null) {
      result += "custom_task_ids=$customTaskIds&";
    }

    return result;
  }

  @override
  List<Object?> get props => [
        workspaceId,
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
      ];
}
