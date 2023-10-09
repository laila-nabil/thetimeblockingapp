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
  final List<ClickupFolder>? clickupFolders;
  final List<ClickupList>? clickupList;

  const StartupState(
      {required this.drawerLargerScreenOpen,
      this.selectedClickupWorkspace,
      this.getFoldersFailure,
      this.clickupFolders,
      this.getListsFailure,
      this.clickupList,
      this.startupStateEnum});

  @override
  List<Object?> get props => [
        drawerLargerScreenOpen,
        selectedClickupWorkspace,
        getFoldersFailure,
        clickupFolders,
        getListsFailure,
        clickupList,
        startupStateEnum
      ];

  StartupState copyWith({
    StartupStateEnum? startupStateEnum,
    bool? drawerLargerScreenOpen,
    ClickupWorkspace? selectedClickupWorkspace,
    Failure? getFoldersFailure,
    Failure? getListsFailure,
    List<ClickupFolder>? clickupFolders,
    List<ClickupList>? clickupList,
  }) {
    return StartupState(
      startupStateEnum: startupStateEnum ?? this.startupStateEnum,
      drawerLargerScreenOpen:
          drawerLargerScreenOpen ?? this.drawerLargerScreenOpen,
      selectedClickupWorkspace:
          selectedClickupWorkspace ?? this.selectedClickupWorkspace,
      getFoldersFailure: getFoldersFailure ?? this.getFoldersFailure,
      getListsFailure: getListsFailure ?? this.getListsFailure,
      clickupFolders: clickupFolders ?? this.clickupFolders,
      clickupList: clickupList ?? this.clickupList,
    );
  }
}
