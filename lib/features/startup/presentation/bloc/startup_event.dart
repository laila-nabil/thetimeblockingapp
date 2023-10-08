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
  final GetClickUpFoldersParams getClickUpFoldersParams;
  const SelectClickupWorkspace(
      {required this.clickupWorkspace, required this.getClickUpFoldersParams});

  @override
  List<Object?> get props => [clickupWorkspace,getClickUpFoldersParams];
}
