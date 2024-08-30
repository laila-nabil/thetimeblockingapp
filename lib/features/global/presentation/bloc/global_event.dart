part of 'global_bloc.dart';

abstract class GlobalEvent extends Equatable {
  const GlobalEvent();
}

class ControlDrawerLargerScreen extends GlobalEvent {
  final bool drawerLargerScreenOpen;

  const ControlDrawerLargerScreen(this.drawerLargerScreenOpen);

  @override
  List<Object?> get props => [drawerLargerScreenOpen];
}

class GetAllInWorkspaceEvent extends GlobalEvent {
  final Workspace workspace;
  final AccessToken accessToken;
  const GetAllInWorkspaceEvent(
      {required this.workspace, required this.accessToken});

  @override
  List<Object?> get props => [workspace,accessToken];
}

class SelectSpace extends GlobalEvent {
  final Space space;
  final AccessToken accessToken;
  const SelectSpace(
      {required this.space, required this.accessToken});

  @override
  List<Object?> get props => [space,accessToken];
}

