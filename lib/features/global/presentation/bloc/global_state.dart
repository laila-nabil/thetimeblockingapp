part of 'global_bloc.dart';

class GlobalState extends Equatable {
  final bool isLoading;
  final bool drawerLargerScreenOpen;
  final Workspace? selectedWorkspace;
  final Failure? getAllInWorkspaceFailure;
  final List<TaskStatus>? statuses;
  final Failure? getStatusesFailure;
  final List<TaskPriority>? priorities;
  final Failure? getPrioritiesFailure;

  const GlobalState({
    required this.drawerLargerScreenOpen,
    this.selectedWorkspace,
    this.isLoading = false,
    this.getAllInWorkspaceFailure,
    this.statuses,
    this.getStatusesFailure,
    this.priorities,
    this.getPrioritiesFailure,
  });

  bool reSelectWorkspace(bool triedGetSelectedWorkspacesSpace) =>
      isLoading == false &&
      Globals.accessToken.accessToken.isNotEmpty == true &&
      getAllInWorkspaceFailure == null &&
      triedGetSelectedWorkspacesSpace;

  @override
  String toString() {
    return 'GlobalState{isLoading: $isLoading, drawerLargerScreenOpen: $drawerLargerScreenOpen, selectedWorkspace: $selectedWorkspace, getAllInWorkspaceFailure: $getAllInWorkspaceFailure, statuses: $statuses, getStatusesFailure: $getStatusesFailure, priorities: $priorities, getPrioritiesFailure: $getPrioritiesFailure}';
  }

  @override
  List<Object?> get props => [
        drawerLargerScreenOpen,
        selectedWorkspace,
        isLoading,
        getAllInWorkspaceFailure,
        statuses,
        getStatusesFailure,
        priorities,
        getPrioritiesFailure,
      ];

  GlobalState copyWith({
    bool isLoading = false,
    bool? drawerLargerScreenOpen,
    Workspace? selectedWorkspace,
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
      selectedWorkspace: selectedWorkspace ?? this.selectedWorkspace,
      getAllInWorkspaceFailure:
          getAllInWorkspaceFailure ?? this.getAllInWorkspaceFailure,
      statuses: statuses ?? this.statuses,
      getStatusesFailure: getStatusesFailure ?? this.getStatusesFailure,
      priorities: priorities ?? this.priorities,
      getPrioritiesFailure: getPrioritiesFailure ?? this.getPrioritiesFailure,
    );
  }
}
