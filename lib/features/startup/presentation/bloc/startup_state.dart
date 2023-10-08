part of 'startup_bloc.dart';

enum StartupStateEnum {
  loading,
  getFoldersSuccess,
  getFoldersFailed,
  getListsSuccess,
  getListsFailed,
}

class StartupState extends Equatable {
  final StartupStateEnum? startupStateEnum;
  final bool drawerLargerScreenOpen;
  final ClickupWorkspace? selectedClickupWorkspace;
  final Failure? getFoldersFailure;
  final Failure? getListsFailure;
  final List<ClickupFolder>? clickUpFolders;
  final List<ClickupList>? clickUpList;

  const StartupState(
      {required this.drawerLargerScreenOpen,
      this.selectedClickupWorkspace,
      this.getFoldersFailure,
      this.clickUpFolders,
      this.getListsFailure,
      this.clickUpList,
      this.startupStateEnum});

  @override
  List<Object?> get props => [
        drawerLargerScreenOpen,
        selectedClickupWorkspace,
        getFoldersFailure,
        clickUpFolders,
        getListsFailure,
        clickUpList,
        startupStateEnum
      ];

  StartupState copyWith({
    StartupStateEnum? startupStateEnum,
    bool? drawerLargerScreenOpen,
    ClickupWorkspace? selectedClickupWorkspace,
    Failure? getFoldersFailure,
    Failure? getListsFailure,
    List<ClickupFolder>? clickUpFolders,
    List<ClickupList>? clickUpList,
  }) {
    return StartupState(
      startupStateEnum: startupStateEnum ?? this.startupStateEnum,
      drawerLargerScreenOpen:
          drawerLargerScreenOpen ?? this.drawerLargerScreenOpen,
      selectedClickupWorkspace:
          selectedClickupWorkspace ?? this.selectedClickupWorkspace,
      getFoldersFailure: getFoldersFailure ?? this.getFoldersFailure,
      getListsFailure: getListsFailure ?? this.getListsFailure,
      clickUpFolders: clickUpFolders ?? this.clickUpFolders,
      clickUpList: clickUpList ?? this.clickUpList,
    );
  }
}
