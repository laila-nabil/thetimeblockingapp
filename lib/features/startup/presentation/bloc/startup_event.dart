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

class SelectClickupWorkspace extends StartupEvent {
  final ClickupWorkspace clickupWorkspace;
  final ClickupAccessToken clickupAccessToken;
  const SelectClickupWorkspace(
      {required this.clickupWorkspace, required this.clickupAccessToken});

  @override
  List<Object?> get props => [clickupWorkspace,clickupAccessToken];
}

class SelectClickupSpace extends StartupEvent {
  final ClickupSpace clickupSpace;
  final ClickupAccessToken clickupAccessToken;
  const SelectClickupSpace(
      {required this.clickupSpace, required this.clickupAccessToken});

  @override
  List<Object?> get props => [clickupSpace,clickupAccessToken];
}

///TODO move to schedule
class GetTasksEvent extends StartupEvent {
  final bool getTasks;
  const GetTasksEvent(
      {required this.getTasks,});

  @override
  List<Object?> get props => [getTasks];
}
