part of 'startup_bloc.dart';

enum StartupStateEnum {
  loading,
  getSpacesSuccess,
  getSpacesFailed,
}

class StartupState extends Equatable {
  final StartupStateEnum? startupStateEnum;
  final bool drawerLargerScreenOpen;
  final ClickupWorkspace? selectedClickupWorkspace;
  final List<Map<String, Failure>>? getSpacesFailure;
  final List<ClickupSpace>? clickupSpaces;

  const StartupState({
    required this.drawerLargerScreenOpen,
    this.selectedClickupWorkspace,
    this.startupStateEnum,
    this.getSpacesFailure,
    this.clickupSpaces,
  });

  bool get isLoading => startupStateEnum == StartupStateEnum.loading;

  bool get selectInitialWorkspace =>
      isLoading == false &&
      Globals.selectedWorkspace != null &&
      Globals.clickupAuthAccessToken.accessToken.isNotEmpty == true &&
      Globals.clickupSpaces == null &&
      getSpacesFailure == null &&
      clickupSpaces == null;

  @override
  List<Object?> get props => [
        startupStateEnum,
        drawerLargerScreenOpen,
        selectedClickupWorkspace,
        getSpacesFailure,
        clickupSpaces,
        selectInitialWorkspace,
      ];

  StartupState copyWith({
    StartupStateEnum? startupStateEnum,
    bool? drawerLargerScreenOpen,
    ClickupWorkspace? selectedClickupWorkspace,
    List<Map<String, Failure>>? getSpacesFailure,
    List<ClickupSpace>? clickupSpaces,
  }) {
    return StartupState(
      startupStateEnum: startupStateEnum ?? this.startupStateEnum,
      drawerLargerScreenOpen:
          drawerLargerScreenOpen ?? this.drawerLargerScreenOpen,
      selectedClickupWorkspace:
          selectedClickupWorkspace ?? this.selectedClickupWorkspace,
      getSpacesFailure: getSpacesFailure ?? this.getSpacesFailure,
      clickupSpaces: clickupSpaces ?? this.clickupSpaces,
    );
  }
}
