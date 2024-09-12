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
  final List<Task>? tasks;
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
    this.tasks,
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

  @override
  String toString() {
    return 'ScheduleState{persistingScheduleStates: $persistingScheduleStates, nonPersistingScheduleState: $nonPersistingScheduleState, tasks: $tasks, getTasksSingleWorkspaceFailure: $getTasksSingleWorkspaceFailure, createTaskFailure: $createTaskFailure, updateTaskFailure: $updateTaskFailure, deleteTaskFailure: $deleteTaskFailure, tasksDueDateEarliestDate: $tasksDueDateEarliestDate, tasksDueDateLatestDate: $tasksDueDateLatestDate, getTasksForSingleWorkspaceScheduleEventId: $getTasksForSingleWorkspaceScheduleEventId, showTaskPopup: $showTaskPopup, taskPopupParams: $taskPopupParams}';
  }

  static DateTime defaultTasksEarliestDate =
      DateTime.now().subtract(const Duration(days: 15));
  static DateTime defaultTasksLatestDate =
      DateTime.now().add(const Duration(days: 15));

  @override
  List<Object?> get props => [
        persistingScheduleStates,
        nonPersistingScheduleState,
        tasks,
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
    List<Task>? tasks,
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
      tasks: tasks ?? this.tasks,
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
      defaultTasksInWorkspaceFiltersParams (
      {required AccessToken accessToken, required User? user}){
    List<String>? filterBySpaceIds;
    // if (serviceLocator<bool>(instanceName:ServiceLocatorName.isWorkspaceAndSpaceAppWide.name) &&
    //     BlocProvider.of<GlobalBloc>(context).state.selectedSpace?.id != null) {
    //   filterBySpaceIds = [
    //     BlocProvider.of<GlobalBloc>(context).state.selectedSpace?.id ?? ""
    //   ];
    // }
    return GetTasksInWorkspaceFiltersParams(
            filterBySpaceIds: filterBySpaceIds,
            accessToken: accessToken,
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

}
