part of 'schedule_bloc.dart';

enum ScheduleStateEnum {
  loading,
  getTasksSingleWorkspaceSuccess,
  getTasksSingleWorkspaceFailed,
  createTaskSuccess,
  createTaskFailed,
  updateTaskSuccess,
  updateTaskFailed,
  deleteTaskSuccess,
  deleteTaskFailed,
}

class ScheduleState extends Equatable {
  final Set<ScheduleStateEnum> persistingScheduleStates;
  final ScheduleStateEnum? nonPersistingScheduleState;
  final List<Task>? clickupTasks;
  final Failure? getTasksSingleWorkspaceFailure;
  final Failure? createTaskFailure;
  final Failure? updateTaskFailure;
  final Failure? deleteTaskFailure;
  final DateTime tasksDueDateEarliestDate;
  final DateTime tasksDueDateLatestDate;
  final String? getTasksForSingleWorkspaceScheduleEventId;
  final bool? showTaskPopup;
  final TaskPopupParams? taskPopupParams;
  const ScheduleState._({
    required this.persistingScheduleStates,
    this.nonPersistingScheduleState,
    this.clickupTasks,
    this.getTasksForSingleWorkspaceScheduleEventId,
    this.getTasksSingleWorkspaceFailure,
    this.createTaskFailure,
    this.updateTaskFailure,
    this.deleteTaskFailure,
    this.showTaskPopup,
    this.taskPopupParams,
    required this.tasksDueDateEarliestDate,
    required this.tasksDueDateLatestDate,
  });

  static DateTime defaultTasksEarliestDate =
      DateTime.now().subtract(const Duration(days: 15));
  static DateTime defaultTasksLatestDate =
      DateTime.now().add(const Duration(days: 15));

  bool startGetTasks(
          {required bool? startGetTasks, required bool waitForStartGetTasks}) =>
      waitForStartGetTasks
          ? (startGetTasks ?? false)
          : (clickupTasks == null || clickupTasks == []);
  @override
  List<Object?> get props => [
        persistingScheduleStates,
        nonPersistingScheduleState,
        clickupTasks,
        getTasksSingleWorkspaceFailure,
        tasksDueDateEarliestDate,
        tasksDueDateLatestDate,
        getTasksForSingleWorkspaceScheduleEventId,
        createTaskFailure,
        updateTaskFailure,
        deleteTaskFailure,
        showTaskPopup,
        taskPopupParams,
      ];

  ///setting [persistingScheduleStateAddRemove] to right in stateAddRemove adds a state
  ///setting [persistingScheduleStateAddRemove] to left in stateAddRemove removes a state
  ///[forceGetTasksForSingleWorkspaceScheduleEvent] does not persist
  ScheduleState copyWith({
    dartz.Either<ScheduleStateEnum, ScheduleStateEnum>? persistingScheduleStateAddRemove,
    ScheduleStateEnum? nonPersistingScheduleState,
    List<Task>? clickupTasks,
    Failure? getTasksSingleWorkspaceFailure,
    Failure? createTaskFailure,
    Failure? updateTaskFailure,
    Failure? deleteTaskFailure,
    DateTime? tasksDueDateEarliestDate,
    DateTime? tasksDueDateLatestDate,
    String? getTasksForSingleWorkspaceScheduleEventId,
    bool? showTaskPopup,
    TaskPopupParams? taskPopupParams,
  }) {
    return ScheduleState._(
      persistingScheduleStates: persistingScheduleStateAddRemove != null?
          updateEnumStates(persistingScheduleStateAddRemove) :
              persistingScheduleStates,
      nonPersistingScheduleState: nonPersistingScheduleState,
      clickupTasks: clickupTasks ?? this.clickupTasks,
      getTasksSingleWorkspaceFailure:
          getTasksSingleWorkspaceFailure ?? this.getTasksSingleWorkspaceFailure,
      tasksDueDateEarliestDate: tasksDueDateEarliestDate ??
          this.tasksDueDateEarliestDate,
      tasksDueDateLatestDate:
          tasksDueDateLatestDate ?? this.tasksDueDateLatestDate,
        getTasksForSingleWorkspaceScheduleEventId:
            getTasksForSingleWorkspaceScheduleEventId ??
                this.getTasksForSingleWorkspaceScheduleEventId,
        createTaskFailure: createTaskFailure??this.createTaskFailure,
      updateTaskFailure:updateTaskFailure??this.updateTaskFailure,
      deleteTaskFailure: deleteTaskFailure??this.deleteTaskFailure,
      showTaskPopup: showTaskPopup??this.showTaskPopup,
      taskPopupParams: taskPopupParams
    );
  }

  bool get isInitial => persistingScheduleStates.isEmpty;
  bool get isLoading => persistingScheduleStates.contains(ScheduleStateEnum.loading);

  GetTasksInWorkspaceFiltersParams
      get defaultTasksInWorkspaceFiltersParams {
    List<String>? filterBySpaceIds;
    if(Globals.isSpaceAppWide && Globals.selectedSpaceId!=null){
      filterBySpaceIds = [Globals.selectedSpace?.id??""];
    }
    return GetTasksInWorkspaceFiltersParams(
            filterBySpaceIds: filterBySpaceIds,
            accessToken: Globals.AccessToken,
            filterByAssignees: [Globals.clickupUser?.id.toString() ?? ""],
            filterByDueDateGreaterThanUnixTimeMilliseconds:
                tasksDueDateEarliestDate.millisecondsSinceEpoch,
            filterByDueDateLessThanUnixTimeMilliseconds:
                tasksDueDateLatestDate.millisecondsSinceEpoch,
          );
  }

  bool get changedTaskSuccessfully => nonPersistingScheduleState ==
      ScheduleStateEnum.createTaskSuccess ||
      nonPersistingScheduleState ==
          ScheduleStateEnum.updateTaskSuccess ||
      nonPersistingScheduleState ==
          ScheduleStateEnum.deleteTaskSuccess;

  Set<ScheduleStateEnum> updateEnumStates(
      dartz.Either<ScheduleStateEnum, ScheduleStateEnum> stateAddRemove) {
    Set<ScheduleStateEnum> updatedStates = Set.from(persistingScheduleStates);
    ScheduleStateEnum? toRemoveState;
    ScheduleStateEnum? toAddState;
    stateAddRemove.fold((l) => toRemoveState = l, (r) => toAddState = r);
    if (stateAddRemove.isLeft() && persistingScheduleStates.contains(toRemoveState)) {
      updatedStates.remove(toRemoveState);
    } else if (stateAddRemove.isRight() && toAddState != null) {
      updatedStates.add(toAddState!);
    }
    return updatedStates;
  }

  bool canShowTaskPopup({required StartupStateEnum? startupStateEnum}) =>
      showTaskPopup == true &&
      ((startupStateEnum == StartupStateEnum.getSpacesSuccess &&
              Globals.isSpaceAppWide == false) ||
          (startupStateEnum == StartupStateEnum.getAllInSpaceSuccess &&
              Globals.isSpaceAppWide == true));
}
