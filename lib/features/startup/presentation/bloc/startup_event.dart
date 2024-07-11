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
  final Workspace clickupWorkspace;
  final ClickupAccessToken clickupAccessToken;
  const SelectWorkspaceAndGetSpacesTagsLists(
      {required this.clickupWorkspace, required this.clickupAccessToken});

  @override
  List<Object?> get props => [clickupWorkspace,clickupAccessToken];
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
