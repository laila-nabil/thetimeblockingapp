part of 'startup_bloc.dart';

enum StartupStateEnum {
  loading,
  getAllInWorkspaceSuccess,
  getAllInWorkspaceFailed,
  getAllInSpaceSuccess,
  getAllInSpaceFailed,
}

class StartupState extends Equatable {
  final StartupStateEnum? startupStateEnum;
  final bool drawerLargerScreenOpen;
  final Workspace? selectedWorkspace;
  final Failure? getAllInWorkspaceFailure;

  const StartupState({
    required this.drawerLargerScreenOpen,
    this.selectedWorkspace,
    this.startupStateEnum,
    this.getAllInWorkspaceFailure,
  });

  bool get isLoading => startupStateEnum == StartupStateEnum.loading;

  bool  reSelectWorkspace(bool triedGetSelectedWorkspacesSpace) =>
      isLoading == false &&
          Globals.accessToken.accessToken.isNotEmpty == true &&
          getAllInWorkspaceFailure == null && triedGetSelectedWorkspacesSpace;

  @override
  List<Object?> get props => [
    startupStateEnum,
    drawerLargerScreenOpen,
    selectedWorkspace,
    getAllInWorkspaceFailure,
  ];

  StartupState copyWith({
    StartupStateEnum? startupStateEnum,
    bool? drawerLargerScreenOpen,
    Workspace? selectedWorkspace,
    Failure? getAllInWorkspaceFailure,
  }) {
    return StartupState(
      startupStateEnum: startupStateEnum ?? this.startupStateEnum,
      drawerLargerScreenOpen:
      drawerLargerScreenOpen ?? this.drawerLargerScreenOpen,
      selectedWorkspace:
      selectedWorkspace ?? selectedWorkspace,
      getAllInWorkspaceFailure: getAllInWorkspaceFailure ?? this.getAllInWorkspaceFailure,
    );
  }
}
