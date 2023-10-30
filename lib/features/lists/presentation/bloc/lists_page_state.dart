part of 'lists_page_bloc.dart';

enum ListsPageStatus {
  initial,
  isLoading,
  getListDetailsSuccess,
  getListDetailsFailed,
  getSpacesAndListsAndFoldersSuccess,
  getSpacesAndListsAndFoldersFailed,
  getTasksSuccess,
  getTasksFailed,
  addListSuccess,
  addListFailed,
  addFolderSuccess,
  addFolderFailed,
  addTaskSuccess,
  addTaskFailed,
  removeListSuccess,
  removeListFailed,
  removeFolderSuccess,
  removeFolderFailed,
  removeTaskSuccess,
  removeTaskFailed,
  navigateList,
  navigateFolder,
}

class ListsPageState extends Equatable {
  final ListsPageStatus listsPageStatus;
  final ClickupList? navigateList;
  final ClickupFolder? navigateFolder;
  final List<ClickupSpace>? getSpacesListsFoldersResult;
  final List<Map<String, Failure>>? getSpacesListsFoldersFailure;
  final List<ClickupTask>? getTasksResult;
  final Failure? getTasksFailure;
  final List<ClickupList>? addListResult;
  final Failure? addListFailure;
  final List<ClickupFolder>? addFolderResult;
  final Failure? addFolderFailure;
  final List<ClickupTask>? addTaskResult;
  final Failure? addTaskFailure;
  final List<ClickupTask>? removeListResult;
  final Failure? removeListFailure;
  final List<ClickupFolder>? removeFolderResult;
  final Failure? removeFolderFailure;
  final List<ClickupTask>? removeTaskResult;
  final Failure? removeTaskFailure;

  const ListsPageState({
    required this.listsPageStatus,
    this.navigateList,
    this.navigateFolder,
    this.getSpacesListsFoldersResult,
    this.getSpacesListsFoldersFailure,
    this.getTasksResult,
    this.getTasksFailure,
    this.addListResult,
    this.addListFailure,
    this.addFolderResult,
    this.addFolderFailure,
    this.addTaskResult,
    this.addTaskFailure,
    this.removeListResult,
    this.removeListFailure,
    this.removeFolderResult,
    this.removeFolderFailure,
    this.removeTaskResult,
    this.removeTaskFailure,
  });

  bool get isInit => listsPageStatus == ListsPageStatus.initial;
  bool get isLoading => listsPageStatus == ListsPageStatus.isLoading;

  GetClickupTasksInWorkspaceFiltersParams
  get defaultTasksInWorkspaceFiltersParams {
    List<String>? filterBySpaceIds;
    if(Globals.isSpaceAppWide && Globals.selectedSpaceId!=null){
      filterBySpaceIds = [Globals.selectedSpace?.id??""];
    }
    return GetClickupTasksInWorkspaceFiltersParams(
      filterBySpaceIds: filterBySpaceIds,
      clickupAccessToken: Globals.clickupAuthAccessToken,
      filterByAssignees: [Globals.clickupUser?.id.toString() ?? ""],
    );
  }

  @override
  List<Object?> get props => [ listsPageStatus,
    navigateList,
    navigateFolder,
    getSpacesListsFoldersResult,
    getSpacesListsFoldersFailure,
    getTasksResult,
    getTasksFailure,
    addListResult,
    addListFailure,
    addFolderResult,
    addFolderFailure,
    addTaskResult,
    addTaskFailure,
    removeListResult,
    removeListFailure,
    removeFolderResult,
    removeFolderFailure,
    removeTaskResult,
    removeTaskFailure,];

  ListsPageState copyWith({
    required ListsPageStatus listsPageStatus,
    ClickupList? navigateList,
    ClickupFolder? navigateFolder,
    List<ClickupSpace>? getSpacesListsFoldersResult,
    List<Map<String, Failure>>? getSpacesListsFoldersFailure,
    List<ClickupTask>? getTasksResult,
    Failure? getTasksFailure,
    List<ClickupList>? addListResult,
    Failure? addListFailure,
    List<ClickupFolder>? addFolderResult,
    Failure? addFolderFailure,
    List<ClickupTask>? addTaskResult,
    Failure? addTaskFailure,
    List<ClickupTask>? removeListResult,
    Failure? removeListFailure,
    List<ClickupFolder>? removeFolderResult,
    Failure? removeFolderFailure,
    List<ClickupTask>? removeTaskResult,
    Failure? removeTaskFailure,
  }) {
    return ListsPageState(
      listsPageStatus: listsPageStatus,
      navigateList: navigateList,
      navigateFolder: navigateFolder,
      getSpacesListsFoldersResult:
          getSpacesListsFoldersResult ?? this.getSpacesListsFoldersResult,
      getSpacesListsFoldersFailure:
          getSpacesListsFoldersFailure ?? this.getSpacesListsFoldersFailure,
      getTasksResult: getTasksResult ?? this.getTasksResult,
      getTasksFailure: getTasksFailure ?? this.getTasksFailure,
      addListResult: addListResult ?? this.addListResult,
      addListFailure: addListFailure ?? this.addListFailure,
      addFolderResult: addFolderResult ?? this.addFolderResult,
      addFolderFailure: addFolderFailure ?? this.addFolderFailure,
      addTaskResult: addTaskResult ?? this.addTaskResult,
      addTaskFailure: addTaskFailure ?? this.addTaskFailure,
      removeListResult: removeListResult ?? this.removeListResult,
      removeListFailure: removeListFailure ?? this.removeListFailure,
      removeFolderResult: removeFolderResult ?? this.removeFolderResult,
      removeFolderFailure: removeFolderFailure ?? this.removeFolderFailure,
      removeTaskResult: removeTaskResult ?? this.removeTaskResult,
      removeTaskFailure: removeTaskFailure ?? this.removeTaskFailure,
    );
  }
}
