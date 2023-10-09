part of 'startup_bloc.dart';

enum StartupStateEnum {
  loading,
  getFoldersSuccess,
  getFoldersFailed,
  getListsInFoldersSuccess,
  getListsInFoldersFailed,
}

class StartupState extends Equatable {
  final StartupStateEnum? startupStateEnum;
  final bool drawerLargerScreenOpen;
  final ClickupWorkspace? selectedClickupWorkspace;
  final Failure? getFoldersFailure;
  final Failure? getListsFailure;
  final List<ClickupFolder>? clickupFolders;
  final List<ClickupList>? clickupListNotInFolders;
  final Map<ClickupFolder, List<ClickupList>>? clickupListsInFolders;

  const StartupState(
      {required this.drawerLargerScreenOpen,
      this.selectedClickupWorkspace,
      this.getFoldersFailure,
      this.clickupFolders,
      this.getListsFailure,
      this.clickupListNotInFolders,
      this.clickupListsInFolders,
      this.startupStateEnum});

  @override
  List<Object?> get props => [
        drawerLargerScreenOpen,
        selectedClickupWorkspace,
        getFoldersFailure,
        clickupFolders,
        getListsFailure,
        clickupListNotInFolders,
        clickupListsInFolders,
        startupStateEnum
      ];

  StartupState copyWith({
    StartupStateEnum? startupStateEnum,
    bool? drawerLargerScreenOpen,
    ClickupWorkspace? selectedClickupWorkspace,
    Failure? getFoldersFailure,
    Failure? getListsFailure,
    List<ClickupFolder>? clickupFolders,
    List<ClickupList>? clickupListNotInFolders,
    Map<ClickupFolder, List<ClickupList>>? clickupListsInFolders,
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
      clickupListNotInFolders: clickupListNotInFolders ?? this.clickupListNotInFolders,
      clickupListsInFolders: clickupListsInFolders ?? this.clickupListsInFolders,
    );
  }
}
