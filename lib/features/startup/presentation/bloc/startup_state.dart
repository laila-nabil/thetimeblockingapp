part of 'startup_bloc.dart';

enum StartupStateEnum {
  loading,
  getSpacesSuccess,
  getSpacesFailed,
  getAllInSpaceSuccess,
  getAllInSpaceFailed,
}

class StartupState extends Equatable {
  final StartupStateEnum? startupStateEnum;
  final bool drawerLargerScreenOpen;
  final Workspace? selectedClickupWorkspace;
  final Space? selectedClickupSpace;
  final List<Map<String, Failure>>? getSpacesFailure;
  final List<Map<String, Failure>>? getAllInSpaceFailure;
  final List<Space>? clickupSpaces;
  final bool? startGetTasks;

  const StartupState({
    required this.drawerLargerScreenOpen,
    this.selectedClickupWorkspace,
    this.selectedClickupSpace,
    this.startupStateEnum,
    this.getSpacesFailure,
    this.getAllInSpaceFailure,
    this.clickupSpaces,
    this.startGetTasks,
  });

  bool get isLoading => startupStateEnum == StartupStateEnum.loading;

  bool  reSelectWorkspace(bool triedGetSelectedWorkspacesSpace) =>
      isLoading == false &&
          Globals.clickupAuthAccessToken.accessToken.isNotEmpty == true &&
          Globals.clickupSpaces == null &&
          getSpacesFailure == null &&
          clickupSpaces == null && triedGetSelectedWorkspacesSpace;

  @override
  List<Object?> get props => [
    startupStateEnum,
    drawerLargerScreenOpen,
    selectedClickupWorkspace,
    selectedClickupSpace,
    getSpacesFailure,
    clickupSpaces,
    reSelectWorkspace,
    startGetTasks,
  ];

  StartupState copyWith({
    StartupStateEnum? startupStateEnum,
    bool? drawerLargerScreenOpen,
    Workspace? selectedClickupWorkspace,
    Space? selectedClickupSpace,
    List<Map<String, Failure>>? getSpacesFailure,
    List<Map<String, Failure>>? getAllInSpaceFailure,
    List<Space>? clickupSpaces,
    bool? startGetTasks,
  }) {
    return StartupState(
      startupStateEnum: startupStateEnum ?? this.startupStateEnum,
      drawerLargerScreenOpen:
      drawerLargerScreenOpen ?? this.drawerLargerScreenOpen,
      selectedClickupWorkspace:
      selectedClickupWorkspace ?? this.selectedClickupWorkspace,
      getSpacesFailure: getSpacesFailure ?? this.getSpacesFailure,
      clickupSpaces: clickupSpaces ?? this.clickupSpaces,
      selectedClickupSpace: selectedClickupSpace ?? this.selectedClickupSpace,
      getAllInSpaceFailure: getAllInSpaceFailure ?? this.getAllInSpaceFailure,
      startGetTasks: startGetTasks,
    );
  }
}
