part of 'schedule_bloc.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();
}


class GetTasksForSingleWorkspaceScheduleEvent extends ScheduleEvent {
  final String? id;
  final GetTasksInWorkspaceParams params;

  const GetTasksForSingleWorkspaceScheduleEvent(this.params, {this.id});

  @override
  List<Object?> get props => [params,id];
}

class CreateTaskEvent extends ScheduleEvent {
  final CreateTaskParams params;
  final int workspaceId;

  const CreateTaskEvent({required this.params,required this.workspaceId});

  @override
  List<Object?> get props => [params,workspaceId];
}

class DuplicateTaskEvent extends ScheduleEvent {
  final CreateTaskParams params;
  final int workspace;

  const DuplicateTaskEvent({
    required this.params,
    required this.workspace,
  });

  @override
  List<Object?> get props => [params, workspace];
}

class UpdateTaskEvent extends ScheduleEvent {
  final CreateTaskParams params;

  const UpdateTaskEvent({required this.params});

  @override
  List<Object?> get props => [params];
}

class DeleteTaskEvent extends ScheduleEvent {
  final DeleteTaskParams params;

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

class ChangeCalendarView extends ScheduleEvent {
  final int viewIndex;

  const ChangeCalendarView(
      {required this.viewIndex});

  @override
  List<Object?> get props => [viewIndex,];
}