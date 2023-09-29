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

  const ScheduleState._({
    required this.scheduleStates,
    this.clickUpTasks,
    this.getTasksSingleWorkspaceFailure,
  });

  @override
  List<Object?> get props =>
      [scheduleStates, clickUpTasks, getTasksSingleWorkspaceFailure];

  ScheduleState copyWith(
      {required Either<ScheduleStateEnum, ScheduleStateEnum> stateAddRemove,
      List<ClickupTask>? clickUpTasks,
      Failure? getTasksSingleWorkspaceFailure}) {
    Set<ScheduleStateEnum> updatedStates = updateEnumStates(stateAddRemove);
    return ScheduleState._(
      scheduleStates: updatedStates,
      clickUpTasks: clickUpTasks ?? this.clickUpTasks,
      getTasksSingleWorkspaceFailure:
          getTasksSingleWorkspaceFailure ?? this.getTasksSingleWorkspaceFailure,
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
