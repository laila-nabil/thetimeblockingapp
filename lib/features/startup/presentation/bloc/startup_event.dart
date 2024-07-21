part of 'startup_bloc.dart';

abstract class StartupEvent extends Equatable {
  const StartupEvent();
}

class ControlDrawerLargerScreen extends StartupEvent {
  final bool drawerLargerScreenOpen;

  const ControlDrawerLargerScreen(this.drawerLargerScreenOpen);

  @override
  List<Object?> get props => [drawerLargerScreenOpen];
}

class SelectWorkspaceAndGetSpacesTagsLists extends StartupEvent {
  final Workspace workspace;
  final ClickupAccessToken accessToken;
  const SelectWorkspaceAndGetSpacesTagsLists(
      {required this.workspace, required this.accessToken});

  @override
  List<Object?> get props => [workspace,accessToken];
}

class SelectSpace extends StartupEvent {
  final Space clickupSpace;
  final ClickupAccessToken clickupAccessToken;
  const SelectSpace(
      {required this.clickupSpace, required this.clickupAccessToken});

  @override
  List<Object?> get props => [clickupSpace,clickupAccessToken];
}

class StartGetTasksEvent extends StartupEvent {
  final bool startGetTasks;
  const StartGetTasksEvent(
      {required this.startGetTasks,});

  @override
  List<Object?> get props => [startGetTasks];
}
