part of 'schedule_bloc.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();
}

class GetTasksForAllWorkspacesScheduleEvent extends ScheduleEvent {
  final GetClickUpTasksInAllWorkspacesParams
      getClickUpTasksInAllWorkspacesParams;

  const GetTasksForAllWorkspacesScheduleEvent(
      this.getClickUpTasksInAllWorkspacesParams);

  @override
  List<Object?> get props => [getClickUpTasksInAllWorkspacesParams];
}

class GetTasksForSingleWorkspaceScheduleEvent extends ScheduleEvent {
  final GetClickUpTasksInWorkspaceParams params;

  const GetTasksForSingleWorkspaceScheduleEvent(this.params);

  @override
  List<Object?> get props => [params];
}
