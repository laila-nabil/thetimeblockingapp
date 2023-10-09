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
