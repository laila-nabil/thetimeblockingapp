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
  final AccessToken accessToken;
  const SelectWorkspaceAndGetSpacesTagsLists(
      {required this.workspace, required this.accessToken});

  @override
  List<Object?> get props => [workspace,accessToken];
}

class SelectSpace extends StartupEvent {
  final Space space;
  final AccessToken accessToken;
  const SelectSpace(
      {required this.space, required this.accessToken});

  @override
  List<Object?> get props => [space,accessToken];
}
