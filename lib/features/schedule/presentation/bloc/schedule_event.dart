part of 'schedule_bloc.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();
}

class GetTasksForAllWorkspacesScheduleEvent extends ScheduleEvent {
  final GetClickupTasksInAllWorkspacesParams
      getClickupTasksInAllWorkspacesParams;

  const GetTasksForAllWorkspacesScheduleEvent(
      this.getClickupTasksInAllWorkspacesParams);

  @override
  List<Object?> get props => [getClickupTasksInAllWorkspacesParams];
}


class GetTasksForSingleWorkspaceScheduleEvent extends ScheduleEvent {
  final String? id;
  final GetClickupTasksInWorkspaceParams params;

  const GetTasksForSingleWorkspaceScheduleEvent(this.params, {this.id});

  @override
  List<Object?> get props => [params,id];
}

class CreateTaskEvent extends ScheduleEvent {
  final ClickupTaskParams params;

  const CreateTaskEvent({required this.params});

  @override
  List<Object?> get props => [params];
}

class DuplicateTaskEvent extends ScheduleEvent {
  final ClickupTaskParams params;

  const DuplicateTaskEvent({required this.params});

  @override
  List<Object?> get props => [params];
}

class UpdateTaskEvent extends ScheduleEvent {
  final ClickupTaskParams params;

  const UpdateTaskEvent({required this.params});

  @override
  List<Object?> get props => [params];
}

class DeleteTaskEvent extends ScheduleEvent {
  final DeleteClickupTaskParams params;

  const DeleteTaskEvent({required this.params});

  @override
  List<Object?> get props => [params];
}

class ShowTaskPopupEvent extends ScheduleEvent {
  final bool showTaskPopup;
  final TaskPopupParams? taskPopupParams;

  const ShowTaskPopupEvent(
      {required this.showTaskPopup, this.taskPopupParams});

  @override
  List<Object?> get props => [showTaskPopup, taskPopupParams];
}
