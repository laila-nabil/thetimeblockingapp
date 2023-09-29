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

  const SelectClickupWorkspace(this.clickupWorkspace);

  @override
  List<Object?> get props => [clickupWorkspace];
}
