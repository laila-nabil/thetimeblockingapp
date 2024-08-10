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
  final Workspace? selectedWorkspace;
  final Space? selectedSpace;
  final List<Map<String, Failure>>? getSpacesFailure;
  final List<Map<String, Failure>>? getAllInSpaceFailure;
  final List<Space>? spaces;
  final bool? startGetTasks;

  const StartupState({
    required this.drawerLargerScreenOpen,
    this.selectedWorkspace,
    this.selectedSpace,
    this.startupStateEnum,
    this.getSpacesFailure,
    this.getAllInSpaceFailure,
    this.spaces,
    this.startGetTasks,
  });

  bool get isLoading => startupStateEnum == StartupStateEnum.loading;

  bool  reSelectWorkspace(bool triedGetSelectedWorkspacesSpace) =>
      isLoading == false &&
          Globals.accessToken.accessToken.isNotEmpty == true &&
          Globals.spaces == null &&
          getSpacesFailure == null &&
          spaces == null && triedGetSelectedWorkspacesSpace;

  @override
  List<Object?> get props => [
    startupStateEnum,
    drawerLargerScreenOpen,
    selectedWorkspace,
    selectedSpace,
    getSpacesFailure,
    spaces,
    startGetTasks,
  ];

  StartupState copyWith({
    StartupStateEnum? startupStateEnum,
    bool? drawerLargerScreenOpen,
    Workspace? selectedWorkspace,
    Space? selectedSpace,
    List<Map<String, Failure>>? getSpacesFailure,
    List<Map<String, Failure>>? getAllInSpaceFailure,
    List<Space>? spaces,
    bool? startGetTasks,
  }) {
    return StartupState(
      startupStateEnum: startupStateEnum ?? this.startupStateEnum,
      drawerLargerScreenOpen:
      drawerLargerScreenOpen ?? this.drawerLargerScreenOpen,
      selectedWorkspace:
      selectedWorkspace ?? selectedWorkspace,
      getSpacesFailure: getSpacesFailure ?? this.getSpacesFailure,
      spaces: spaces ?? this.spaces,
      selectedSpace: selectedSpace ?? this.selectedSpace,
      getAllInSpaceFailure: getAllInSpaceFailure ?? this.getAllInSpaceFailure,
      startGetTasks: startGetTasks,
    );
  }
}
