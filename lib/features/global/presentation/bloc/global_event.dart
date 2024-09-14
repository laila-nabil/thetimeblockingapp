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

  final User user;
  const GetAllInWorkspaceEvent(
      {required this.workspace, required this.accessToken,required this.user});

  @override
  List<Object?> get props => [workspace,accessToken];
}

class GetAllWorkspacesEvent extends GlobalEvent {
  final GetWorkspacesParams params;
  const GetAllWorkspacesEvent(
      { required this.params});

  @override
  List<Object?> get props => [params];
}


class GetStatusesEvent extends GlobalEvent {
  final AccessToken accessToken;
  const GetStatusesEvent(
      { required this.accessToken});

  @override
  List<Object?> get props => [accessToken];
}

class GetPrioritiesEvent extends GlobalEvent {
  final AccessToken accessToken;
  const GetPrioritiesEvent(
      { required this.accessToken});

  @override
  List<Object?> get props => [accessToken];
}
