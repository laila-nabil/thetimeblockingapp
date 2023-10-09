part of 'startup_bloc.dart';

enum StartupStateEnum {
  loading,
  getFoldersSuccess,
  getFoldersFailed,
  getListsInFoldersSuccess,
  getListsInFoldersFailed,
  getFolderlessListsSuccess,
  getFolderlessListsFailed,
}

class StartupState extends Equatable {
  final StartupStateEnum? startupStateEnum;
  final bool drawerLargerScreenOpen;
  final ClickupWorkspace? selectedClickupWorkspace;
  final Failure? getFoldersFailure;
  final Failure? getListsInFoldersFailure;
  final Failure? getFolderlessListsFailure;
  final List<ClickupFolder>? clickupFolders;
  final List<ClickupList>? clickupFolderlessListsFolders;
  final Map<ClickupFolder, List<ClickupList>>? clickupListsInFolders;

  const StartupState({required this.drawerLargerScreenOpen,
    this.selectedClickupWorkspace,
    this.getFoldersFailure,
    this.clickupFolders,
    this.getListsInFoldersFailure,
    this.getFolderlessListsFailure,
    this.clickupFolderlessListsFolders,
    this.clickupListsInFolders,
    this.startupStateEnum});

  @override
  List<Object?> get props =>
      [
        drawerLargerScreenOpen,
        selectedClickupWorkspace,
        getFoldersFailure,
        clickupFolders,
        getListsInFoldersFailure,
        getFolderlessListsFailure,
        clickupFolderlessListsFolders,
        clickupListsInFolders,
        startupStateEnum
      ];

  StartupState copyWith({
    StartupStateEnum? startupStateEnum,
    bool? drawerLargerScreenOpen,
    ClickupWorkspace? selectedClickupWorkspace,
    Failure? getFoldersFailure,
    Failure? getListsInFoldersFailure,
    Failure? getFolderlessListsFailure,
    List<ClickupFolder>? clickupFolders,
    List<ClickupList>? clickupFolderlessListsFolders,
    Map<ClickupFolder, List<ClickupList>>? clickupListsInFolders,
  }) {
    return StartupState(
      startupStateEnum: startupStateEnum ?? this.startupStateEnum,
      drawerLargerScreenOpen:
          drawerLargerScreenOpen ?? this.drawerLargerScreenOpen,
      selectedClickupWorkspace:
          selectedClickupWorkspace ?? this.selectedClickupWorkspace,
      getFoldersFailure: getFoldersFailure ?? this.getFoldersFailure,
      getListsInFoldersFailure:
          getListsInFoldersFailure ?? this.getListsInFoldersFailure,
      getFolderlessListsFailure:
          getFolderlessListsFailure ?? this.getFolderlessListsFailure,
      clickupFolders: clickupFolders ?? this.clickupFolders,
      clickupFolderlessListsFolders:
          clickupFolderlessListsFolders ?? this.clickupFolderlessListsFolders,
      clickupListsInFolders:
          clickupListsInFolders ?? this.clickupListsInFolders,
    );
  }
}
