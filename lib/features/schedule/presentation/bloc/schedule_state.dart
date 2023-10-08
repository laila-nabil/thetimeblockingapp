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
  final List<ClickupTask>? clickUpTasks;
  final Failure? getTasksSingleWorkspaceFailure;
  final Failure? createTaskFailure;
  final Failure? updateTaskFailure;
  final Failure? deleteTaskFailure;
  final DateTime tasksDueDateEarliestDate;
  final DateTime tasksDueDateLatestDate;
  final String? getTasksForSingleWorkspaceScheduleEventId;
  const ScheduleState._({
    required this.persistingScheduleStates,
    this.nonPersistingScheduleState,
    this.clickUpTasks,
    this.getTasksForSingleWorkspaceScheduleEventId,
    this.getTasksSingleWorkspaceFailure,
    this.createTaskFailure,
    this.updateTaskFailure,
    this.deleteTaskFailure,
    required this.tasksDueDateEarliestDate,
    required this.tasksDueDateLatestDate,
  });

  static DateTime defaultTasksEarliestDate =
      DateTime.now().subtract(const Duration(days: 15));
  static DateTime defaultTasksLatestDate =
      DateTime.now().add(const Duration(days: 15));

  @override
  List<Object?> get props => [
        persistingScheduleStates,
        nonPersistingScheduleState,
        clickUpTasks,
        getTasksSingleWorkspaceFailure,
        tasksDueDateEarliestDate,
        tasksDueDateLatestDate,
        getTasksForSingleWorkspaceScheduleEventId,
        createTaskFailure,
        updateTaskFailure,
        deleteTaskFailure,
      ];

  ///setting [persistingScheduleStateAddRemove] to right in stateAddRemove adds a state
  ///setting [persistingScheduleStateAddRemove] to left in stateAddRemove removes a state
  ///[forceGetTasksForSingleWorkspaceScheduleEvent] does not persist
  ScheduleState copyWith({
    Either<ScheduleStateEnum, ScheduleStateEnum>? persistingScheduleStateAddRemove,
    ScheduleStateEnum? nonPersistingScheduleState,
    List<ClickupTask>? clickUpTasks,
    Failure? getTasksSingleWorkspaceFailure,
    Failure? createTaskFailure,
    Failure? updateTaskFailure,
    Failure? deleteTaskFailure,
    DateTime? tasksDueDateEarliestDate,
    DateTime? tasksDueDateLatestDate,
    String? getTasksForSingleWorkspaceScheduleEventId,
  }) {
    return ScheduleState._(
      persistingScheduleStates: persistingScheduleStateAddRemove != null?
          updateEnumStates(persistingScheduleStateAddRemove) :
              persistingScheduleStates,
      nonPersistingScheduleState: nonPersistingScheduleState,
      clickUpTasks: clickUpTasks ?? this.clickUpTasks,
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
      deleteTaskFailure: deleteTaskFailure??this.deleteTaskFailure,);
  }

  bool get isInitial => persistingScheduleStates.isEmpty;
  bool get isLoading => persistingScheduleStates.contains(ScheduleStateEnum.loading);

  Set<ScheduleStateEnum> updateEnumStates(
      Either<ScheduleStateEnum, ScheduleStateEnum> stateAddRemove) {
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
