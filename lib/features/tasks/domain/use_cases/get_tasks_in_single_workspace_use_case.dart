import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/tasks_list.dart';
import 'package:thetimeblockingapp/common/enums/backend_mode.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/common/entities/access_token.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';

import '../../../../common/entities/tag.dart';
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
  final int workspaceId;
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
  final TasksList? filterByList;
  final List<String>? filterByStatuses;
  final Tag? filterByTag;
  final int? filterByDueDateLessThanUnixTimeMilliseconds;
  final int? filterByDueDateGreaterThanUnixTimeMilliseconds;
  final int? filterByCreatedDateLessThanUnixTimeMilliseconds;
  final int? filterByCreatedDateGreaterThanUnixTimeMilliseconds;
  final int? filterByDateUpdatedLessThanUnixTimeMilliseconds;
  final int? filterByDateUpdatedGreaterThanUnixTimeMilliseconds;
  final int? filterByDateDoneLessThanUnixTimeMilliseconds;
  final int? filterByDateDoneGreaterThanUnixTimeMilliseconds;

  const GetTasksInWorkspaceFiltersParams({
    this.page,
    this.tasksOrderBy,
    this.filterByList,
    this.filterByStatuses,
    this.filterByTag,
    this.filterByDueDateLessThanUnixTimeMilliseconds,
    this.filterByDueDateGreaterThanUnixTimeMilliseconds,
    this.filterByCreatedDateLessThanUnixTimeMilliseconds,
    this.filterByCreatedDateGreaterThanUnixTimeMilliseconds,
    this.filterByDateUpdatedLessThanUnixTimeMilliseconds,
    this.filterByDateUpdatedGreaterThanUnixTimeMilliseconds,
    this.filterByDateDoneLessThanUnixTimeMilliseconds,
    this.filterByDateDoneGreaterThanUnixTimeMilliseconds,
  });

  //https://postgrest.org/en/v12/references/api/tables_views.html#read
   @override
  String toString(){
     String result = '';
     if(filterByList != null){
      result +=  "&list_id=eq.${filterByList?.id}";
     }
     if(filterByTag != null){
       result +=  "&tags_ids=ov.{${filterByTag?.id}}";
     }
     return result;
    }


  @override
  List<Object?> get props => [
        page,
        tasksOrderBy,
        filterByList,
        filterByStatuses,
        filterByTag,
        filterByDueDateLessThanUnixTimeMilliseconds,
        filterByDueDateGreaterThanUnixTimeMilliseconds,
        filterByCreatedDateLessThanUnixTimeMilliseconds,
        filterByCreatedDateGreaterThanUnixTimeMilliseconds,
        filterByDateUpdatedLessThanUnixTimeMilliseconds,
        filterByDateUpdatedGreaterThanUnixTimeMilliseconds,
        filterByDateDoneLessThanUnixTimeMilliseconds,
        filterByDateDoneGreaterThanUnixTimeMilliseconds,
      ];

  GetTasksInWorkspaceFiltersParams copyWith({
    int? page,
    TasksOrderBy? tasksOrderBy,
    TasksList? filterByList,
    List<String>? filterByStatuses,
    Tag? filterByTag,
    int? filterByDueDateLessThanUnixTimeMilliseconds,
    int? filterByDueDateGreaterThanUnixTimeMilliseconds,
    int? filterByCreatedDateLessThanUnixTimeMilliseconds,
    int? filterByCreatedDateGreaterThanUnixTimeMilliseconds,
    int? filterByDateUpdatedLessThanUnixTimeMilliseconds,
    int? filterByDateUpdatedGreaterThanUnixTimeMilliseconds,
    int? filterByDateDoneLessThanUnixTimeMilliseconds,
    int? filterByDateDoneGreaterThanUnixTimeMilliseconds,
    AccessToken? accessToken,
  }) {
    return GetTasksInWorkspaceFiltersParams(
      page: page ?? this.page,
      tasksOrderBy: tasksOrderBy ?? this.tasksOrderBy,
      filterByList: filterByList ?? this.filterByList,
      filterByStatuses: filterByStatuses ?? this.filterByStatuses,
      filterByTag: filterByTag ?? this.filterByTag,
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
    );
  }
}
