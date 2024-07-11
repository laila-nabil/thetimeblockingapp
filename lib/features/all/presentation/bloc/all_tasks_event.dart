part of 'all_tasks_bloc.dart';

abstract class AllTasksEvent extends Equatable {
  const AllTasksEvent();
}

class GetTasksInSpaceEvent extends AllTasksEvent {
  final AccessToken accessToken;
  final Space space;
  final Workspace workspace;

  const GetTasksInSpaceEvent(
      {required this.accessToken,
        required this.workspace,
        required this.space});

  @override
  List<Object?> get props => [accessToken, space];
}

class CreateTaskEvent extends AllTasksEvent {
  final CreateTaskParams params;
  final Workspace workspace;

  const CreateTaskEvent({
    required this.params,
    required this.workspace,
  });

  @override
  List<Object?> get props => [params, workspace];
}

class DuplicateTaskEvent extends AllTasksEvent {
  final CreateTaskParams params;
  final Workspace workspace;

  const DuplicateTaskEvent({
    required this.params,
    required this.workspace,
  });

  @override
  List<Object?> get props => [params, workspace];
}

class UpdateTaskEvent extends AllTasksEvent {
  final CreateTaskParams params;
  final Workspace workspace;

  const UpdateTaskEvent({
    required this.params,
    required this.workspace,
  });

  @override
  List<Object?> get props => [params,workspace];
}

class DeleteTaskEvent extends AllTasksEvent {
  final DeleteTaskParams params;
  final Workspace workspace;

  const DeleteTaskEvent({
    required this.params,
    required this.workspace,
  });

  @override
  List<Object?> get props => [params,workspace];
}