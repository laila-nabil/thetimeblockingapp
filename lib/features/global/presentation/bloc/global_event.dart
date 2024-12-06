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

  final User user;
  const GetAllInWorkspaceEvent(
      {required this.workspace, required this.user});

  @override
  List<Object?> get props => [workspace,user];
}

class GetAllWorkspacesEvent extends GlobalEvent {
  final GetWorkspacesParams params;
  const GetAllWorkspacesEvent(
      { required this.params});

  @override
  List<Object?> get props => [params];
}


class GetStatusesEvent extends GlobalEvent {
  @override
  List<Object?> get props => [];
}

class GetPrioritiesEvent extends GlobalEvent {
  final GetPrioritiesParams getPrioritiesParams;

  GetPrioritiesEvent(this.getPrioritiesParams);
  @override
  List<Object?> get props => [getPrioritiesParams];
}

class ClearUserDataEvent extends GlobalEvent {

  @override
  List<Object?> get props => [];
}
