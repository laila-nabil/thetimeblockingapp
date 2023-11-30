part of 'all_tasks_bloc.dart';

abstract class AllTasksEvent extends Equatable {
  const AllTasksEvent();
}

class GetClickupTasksInSpaceEvent extends AllTasksEvent {
  final ClickupAccessToken clickupAccessToken;
  final ClickupSpace space;
  final ClickupWorkspace workspace;

  const GetClickupTasksInSpaceEvent(
      {required this.clickupAccessToken,
        required this.workspace,
        required this.space});

  @override
  List<Object?> get props => [clickupAccessToken, space];
}

class CreateClickupTaskEvent extends AllTasksEvent {
  final ClickupTaskParams params;
  final ClickupWorkspace workspace;

  const CreateClickupTaskEvent({
    required this.params,
    required this.workspace,
  });

  @override
  List<Object?> get props => [params, workspace];
}

class UpdateClickupTaskEvent extends AllTasksEvent {
  final ClickupTaskParams params;
  final ClickupWorkspace workspace;

  const UpdateClickupTaskEvent({
    required this.params,
    required this.workspace,
  });

  @override
  List<Object?> get props => [params,workspace];
}

class DeleteClickupTaskEvent extends AllTasksEvent {
  final DeleteClickupTaskParams params;
  final ClickupWorkspace workspace;

  const DeleteClickupTaskEvent({
    required this.params,
    required this.workspace,
  });

  @override
  List<Object?> get props => [params,workspace];
}