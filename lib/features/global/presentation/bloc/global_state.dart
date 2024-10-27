part of 'global_bloc.dart';

class GlobalState extends Equatable {
  final bool isLoading;
  final bool drawerLargerScreenOpen;
  final List<Workspace>? workspaces;
  final Workspace? selectedWorkspace;
  final Failure? getWorkspacesFailure;
  final Failure? getAllInWorkspaceFailure;
  final List<TaskStatus>? statuses;
  final Failure? getStatusesFailure;
  final List<TaskPriority>? priorities;
  final Failure? getPrioritiesFailure;

  const GlobalState(
      {required this.isLoading,
      required this.drawerLargerScreenOpen,
      this.workspaces,
      this.selectedWorkspace,
      this.getWorkspacesFailure,
      this.getAllInWorkspaceFailure,
      this.statuses,
      this.getStatusesFailure,
      this.priorities,
      this.getPrioritiesFailure});

  bool reSelectWorkspace(bool triedGetSelectedWorkspacesSpace,AccessToken? accessToken) =>
      isLoading == false &&
      accessToken?.accessToken.isNotEmpty == true &&
      getAllInWorkspaceFailure == null &&
      triedGetSelectedWorkspacesSpace;


  @override
  String toString() {
    return 'GlobalState{isLoading: $isLoading, drawerLargerScreenOpen: $drawerLargerScreenOpen, workspaces: $workspaces, selectedWorkspace: $selectedWorkspace, getWorkspacesFailure: $getWorkspacesFailure, getAllInWorkspaceFailure: $getAllInWorkspaceFailure, statuses: $statuses, getStatusesFailure: $getStatusesFailure, priorities: $priorities, getPrioritiesFailure: $getPrioritiesFailure}';
  }

  @override
  List<Object?> get props => [
        drawerLargerScreenOpen,
        workspaces,
        selectedWorkspace,
        isLoading,
        getAllInWorkspaceFailure,
        statuses,
        getStatusesFailure,
        priorities,
        getPrioritiesFailure,
        getWorkspacesFailure,
      ];

  GlobalState copyWith({
    bool isLoading = false,
    bool? drawerLargerScreenOpen,
    List<Workspace>? workspaces,
    Workspace? selectedWorkspace,
    Failure? getWorkspacesFailure,
    Failure? getAllInWorkspaceFailure,
    List<TaskStatus>? statuses,
    Failure? getStatusesFailure,
    List<TaskPriority>? priorities,
    Failure? getPrioritiesFailure,
  }) {
    return GlobalState(
      isLoading: isLoading,
      drawerLargerScreenOpen:
          drawerLargerScreenOpen ?? this.drawerLargerScreenOpen,
      workspaces: workspaces ?? this.workspaces,
      selectedWorkspace: selectedWorkspace ?? this.selectedWorkspace,
      getWorkspacesFailure: getWorkspacesFailure ?? this.getWorkspacesFailure,
      getAllInWorkspaceFailure:
          getAllInWorkspaceFailure ?? this.getAllInWorkspaceFailure,
      statuses: statuses ?? this.statuses,
      getStatusesFailure: getStatusesFailure ?? this.getStatusesFailure,
      priorities: priorities ?? this.priorities,
      getPrioritiesFailure: getPrioritiesFailure ?? this.getPrioritiesFailure,
    );
  }

  GlobalState clearUserData() {
    return GlobalState(
      isLoading: isLoading,
      drawerLargerScreenOpen: false ,
      statuses: statuses ,
      getStatusesFailure: getStatusesFailure,
      priorities: priorities ,
      getPrioritiesFailure: getPrioritiesFailure,
    );
  }
}
