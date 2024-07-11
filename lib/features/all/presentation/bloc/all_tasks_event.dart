part of 'all_tasks_bloc.dart';

abstract class AllTasksEvent extends Equatable {
  const AllTasksEvent();
}

class GetClickupTasksInSpaceEvent extends AllTasksEvent {
  final ClickupAccessToken clickupAccessToken;
  final Space space;
  final Workspace workspace;

  const GetClickupTasksInSpaceEvent(
      {required this.clickupAccessToken,
        required this.workspace,
        required this.space});

  @override
  List<Object?> get props => [clickupAccessToken, space];
}

class CreateClickupTaskEvent extends AllTasksEvent {
  final ClickupTaskParams params;
  final Workspace workspace;

  const CreateClickupTaskEvent({
    required this.params,
    required this.workspace,
  });

  @override
  List<Object?> get props => [params, workspace];
}

class DuplicateClickupTaskEvent extends AllTasksEvent {
  final ClickupTaskParams params;
  final Workspace workspace;

  const DuplicateClickupTaskEvent({
    required this.params,
    required this.workspace,
  });

  @override
  List<Object?> get props => [params, workspace];
}

class UpdateClickupTaskEvent extends AllTasksEvent {
  final ClickupTaskParams params;
  final Workspace workspace;

  const UpdateClickupTaskEvent({
    required this.params,
    required this.workspace,
  });

  @override
  List<Object?> get props => [params,workspace];
}

class DeleteClickupTaskEvent extends AllTasksEvent {
  final DeleteClickupTaskParams params;
  final Workspace workspace;

  const DeleteClickupTaskEvent({
    required this.params,
    required this.workspace,
  });

  @override
  List<Object?> get props => [params,workspace];
}