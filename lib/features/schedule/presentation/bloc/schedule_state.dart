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
  final DateTime tasksEarliestDate;
  final DateTime tasksLatestDate;

  const ScheduleState._({
    required this.scheduleStates,
    this.clickUpTasks,
    this.getTasksSingleWorkspaceFailure,
    required this.tasksEarliestDate,
    required this.tasksLatestDate,
  });

  static DateTime defaultTasksEarliestDate = DateTime.now();
  static DateTime defaultTasksLatestDate =
      DateTime.now().add(const Duration(days: 60));

  @override
  List<Object?> get props => [
        scheduleStates,
        clickUpTasks,
        getTasksSingleWorkspaceFailure,
        tasksEarliestDate,
        tasksLatestDate,
      ];


  ScheduleState copyWith({
    required  Either<ScheduleStateEnum, ScheduleStateEnum> stateAddRemove,
    List<ClickupTask>? clickUpTasks,
    Failure? getTasksSingleWorkspaceFailure,
    DateTime? tasksEarliestDate,
    DateTime? tasksLatestDate,
  }) {
    return ScheduleState._(
      scheduleStates: updateEnumStates(stateAddRemove),
      clickUpTasks: clickUpTasks ?? this.clickUpTasks,
      getTasksSingleWorkspaceFailure:
          getTasksSingleWorkspaceFailure ?? this.getTasksSingleWorkspaceFailure,
      tasksEarliestDate: tasksEarliestDate ??
          this.tasksEarliestDate,
      tasksLatestDate:
          tasksLatestDate ?? this.tasksLatestDate,
    );
  }

  bool get isInitial => scheduleStates.isEmpty;

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
