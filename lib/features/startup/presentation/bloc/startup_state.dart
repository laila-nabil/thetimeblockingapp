part of 'startup_bloc.dart';

enum StartupStateEnum {
  loading,
  getAllInWorkspaceSuccess,
  getAllInWorkspaceFailed,
  getStatusesSuccess,
  getStatusesFailed,
  getPrioritiesSuccess,
  getPrioritiesFailed,
  getAllInSpaceSuccess,
  getAllInSpaceFailed,
}

class StartupState extends Equatable {
  final StartupStateEnum? startupStateEnum;
  final bool drawerLargerScreenOpen;
  final Workspace? selectedWorkspace;
  final Failure? getAllInWorkspaceFailure;
  final List<TaskStatus>? statuses;
  final Failure? getStatusesFailure;
  final List<TaskPriority>? priorities;
  final Failure? getPrioritiesFailure;

  const StartupState({
    required this.drawerLargerScreenOpen,
    this.selectedWorkspace,
    this.startupStateEnum,
    this.getAllInWorkspaceFailure,
    this.statuses, this.getStatusesFailure, this.priorities, this.getPrioritiesFailure,
  });

  bool get isLoading => startupStateEnum == StartupStateEnum.loading;

  bool  reSelectWorkspace(bool triedGetSelectedWorkspacesSpace) =>
      isLoading == false &&
          Globals.accessToken.accessToken.isNotEmpty == true &&
          getAllInWorkspaceFailure == null && triedGetSelectedWorkspacesSpace;

  @override
  String toString() {
    return 'StartupState{startupStateEnum: $startupStateEnum, drawerLargerScreenOpen: $drawerLargerScreenOpen, selectedWorkspace: $selectedWorkspace, getAllInWorkspaceFailure: $getAllInWorkspaceFailure}';
  }

  @override
  List<Object?> get props => [
    startupStateEnum,
    drawerLargerScreenOpen,
    selectedWorkspace,
    getAllInWorkspaceFailure,this.statuses, this.getStatusesFailure, this.priorities, this.getPrioritiesFailure,
  ];

  StartupState copyWith({
    StartupStateEnum? startupStateEnum,
    bool? drawerLargerScreenOpen,
    Workspace? selectedWorkspace,
    Failure? getAllInWorkspaceFailure,
    List<TaskStatus>? statuses,
    Failure? getStatusesFailure,
    List<TaskPriority>? priorities,
    Failure? getPrioritiesFailure,
  }) {
    return StartupState(
      startupStateEnum: startupStateEnum ?? this.startupStateEnum,
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
