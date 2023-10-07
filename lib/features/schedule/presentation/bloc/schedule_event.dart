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
  final String? id;
  final GetClickUpTasksInWorkspaceParams params;

  const GetTasksForSingleWorkspaceScheduleEvent(this.params, {this.id});

  @override
  List<Object?> get props => [params,id];
}

class CreateClickUpTaskEvent extends ScheduleEvent {
  final ClickUpTaskParams params;

  const CreateClickUpTaskEvent({required this.params});

  @override
  List<Object?> get props => [params];
}

class UpdateClickUpTaskEvent extends ScheduleEvent {
  final ClickUpTaskParams params;

  const UpdateClickUpTaskEvent({required this.params});

  @override
  List<Object?> get props => [params];
}

class DeleteClickUpTaskEvent extends ScheduleEvent {
  final DeleteClickUpTaskParams params;

  const DeleteClickUpTaskEvent({required this.params});

  @override
  List<Object?> get props => [params];
}
