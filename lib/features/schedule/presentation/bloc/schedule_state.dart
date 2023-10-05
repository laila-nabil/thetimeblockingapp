part of 'schedule_bloc.dart';

enum ScheduleStateEnum {
  loading,
  getTasksSingleWorkspaceSuccess,
  getTasksSingleWorkspaceFailed
}

class ScheduleState extends Equatable {
  final Set<ScheduleStateEnum> scheduleStates;
  final List<ClickupTask>? clickUpTasks;
  final Failure? getTasksSingleWorkspaceFailure;
  final DateTime tasksDueDateEarliestDate;
  final DateTime tasksDueDateLatestDate;
  final String? getTasksForSingleWorkspaceScheduleEventId;
  const ScheduleState._({
    required this.scheduleStates,
    this.clickUpTasks,
    this.getTasksForSingleWorkspaceScheduleEventId,
    this.getTasksSingleWorkspaceFailure,
    required this.tasksDueDateEarliestDate,
    required this.tasksDueDateLatestDate,
  });

  static DateTime defaultTasksEarliestDate =
      DateTime.now().subtract(const Duration(days: 15));
  static DateTime defaultTasksLatestDate =
      DateTime.now().add(const Duration(days: 15));

  @override
  List<Object?> get props => [
        scheduleStates,
        clickUpTasks,
        getTasksSingleWorkspaceFailure,
        tasksDueDateEarliestDate,
        tasksDueDateLatestDate,
        getTasksForSingleWorkspaceScheduleEventId,
      ];


  ScheduleState copyWith({
    required  Either<ScheduleStateEnum, ScheduleStateEnum> stateAddRemove,
    List<ClickupTask>? clickUpTasks,
    Failure? getTasksSingleWorkspaceFailure,
    DateTime? tasksDueDateEarliestDate,
    DateTime? tasksDueDateLatestDate,
    String? getTasksForSingleWorkspaceScheduleEventId,
  }) {
    return ScheduleState._(
      scheduleStates: updateEnumStates(stateAddRemove),
      clickUpTasks: clickUpTasks ?? this.clickUpTasks,
      getTasksSingleWorkspaceFailure:
          getTasksSingleWorkspaceFailure ?? this.getTasksSingleWorkspaceFailure,
      tasksDueDateEarliestDate: tasksDueDateEarliestDate ??
          this.tasksDueDateEarliestDate,
      tasksDueDateLatestDate:
          tasksDueDateLatestDate ?? this.tasksDueDateLatestDate,
        getTasksForSingleWorkspaceScheduleEventId:
            getTasksForSingleWorkspaceScheduleEventId ??
                this.getTasksForSingleWorkspaceScheduleEventId);
  }

  bool get isInitial => scheduleStates.isEmpty;
  bool get isLoading => scheduleStates.contains(ScheduleStateEnum.loading);

  Set<ScheduleStateEnum> updateEnumStates(
      Either<ScheduleStateEnum, ScheduleStateEnum> stateAddRemove) {
    Set<ScheduleStateEnum> updatedStates = Set.from(scheduleStates);
    ScheduleStateEnum? toRemoveState;
    ScheduleStateEnum? toAddState;
    stateAddRemove.fold((l) => toRemoveState = l, (r) => toAddState = r);
    if (stateAddRemove.isLeft() && scheduleStates.contains(toRemoveState)) {
      updatedStates.remove(toRemoveState);
    } else if (stateAddRemove.isRight() && toAddState != null) {
      updatedStates.add(toAddState!);
    }
    return updatedStates;
  }
}
