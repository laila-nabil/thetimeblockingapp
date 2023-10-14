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

///FIXME A gets called a lot
class GetTasksForSingleWorkspaceScheduleEvent extends ScheduleEvent {
  final String? id;
  final GetClickupTasksInWorkspaceParams params;

  const GetTasksForSingleWorkspaceScheduleEvent(this.params, {this.id});

  @override
  List<Object?> get props => [params,id];
}

class CreateClickupTaskEvent extends ScheduleEvent {
  final ClickupTaskParams params;

  const CreateClickupTaskEvent({required this.params});

  @override
  List<Object?> get props => [params];
}

class UpdateClickupTaskEvent extends ScheduleEvent {
  final ClickupTaskParams params;

  const UpdateClickupTaskEvent({required this.params});

  @override
  List<Object?> get props => [params];
}

class DeleteClickupTaskEvent extends ScheduleEvent {
  final DeleteClickupTaskParams params;

  const DeleteClickupTaskEvent({required this.params});

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
