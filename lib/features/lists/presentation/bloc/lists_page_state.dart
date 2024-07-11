part of 'lists_page_bloc.dart';

enum ListsPageStatus {
  initial,
  isLoading,
  getListDetailsSuccess,
  getListDetailsFailed,
  getSpacesAndListsAndFoldersSuccess,
  getSpacesAndListsAndFoldersFailed,
  getListDetailsAndTasksSuccess,
  getListDetailsAndTasksWentWrong,
  moveListTry,
  createListInFolderTry,
  createListInFolderSuccess,
  createListInFolderFailed,
  createListInFolderCanceled,
  createListInSpaceTry,
  createListInSpaceSuccess,
  createListInSpaceFailed,
  createListInSpaceCanceled,
  createFolderSuccess,
  createFolderTry,
  createFolderFailed,
  createFolderCanceled,
  createTaskSuccess,
  createTaskFailed,
  updateTaskSuccess,
  updateTaskFailed,
  deleteListSuccess,
  deleteListFailed,
  deleteListCanceled,
  deleteListTry,
  deleteFolderSuccess,
  deleteFolderFailed,
  deleteTaskTry,
  deleteTaskSuccess,
  deleteTaskFailed,
  navigateList,
  navigateFolder,
  moveTaskBetweenListsTry,
  moveTaskBetweenListsSuccess,
  moveTaskBetweenListsFailed, deleteFolderTry,
}

class ListsPageState extends Equatable {
  final ListsPageStatus listsPageStatus;
  final ClickupList? navigateList;
  final ClickupList? currentList;
  final Folder? navigateFolder;
  final List<Space>? getSpacesListsFoldersResult;
  final List<Map<String, Failure>>? getSpacesListsFoldersFailure;
  final List<ClickupTask>? currentListTasks;
  final FailuresList? getListDetailsAndTasksFailure;
  final List<ClickupList>? addListResult;
  final Failure? createListFailure;
  final List<Folder>? createFolderResult;
  final Failure? createFolderFailure;
  final List<ClickupTask>? createTaskResult;
  final Failure? createTaskFailure;
  final Failure? updateTaskFailure;
  final List<ClickupTask>? deleteListResult;
  final Failure? deleteListFailure;
  final List<Folder>? deleteFolderResult;
  final Failure? deleteFolderFailure;
  final List<ClickupTask>? deleteTaskResult;
  final Failure? deleteTaskFailure;
  final ClickupWorkspace? clickupWorkspace;
  final Space? clickupSpace;
  final CreateClickupListInFolderParams? createClickupListInFolderParams;
  final CreateFolderlessListClickupParams? createFolderlessListClickupParams;
  final MoveClickupTaskBetweenListsParams? moveClickupTaskBetweenListsParams;
  final CreateClickupFolderInSpaceParams? createClickupFolderInSpaceParams;
  final DeleteClickupFolderParams? deleteClickupFolderParams;
  final DeleteClickupListParams? deleteClickupListParams;
  final Unit? moveTaskBetweenListsResult;
  final Failure? moveTaskBetweenListsFailure;
  final Folder? folderToCreateListIn;
  final ClickupList? toDeleteList;
  final Folder? toDeleteFolder;
  const ListsPageState({
    required this.listsPageStatus,
    this.navigateList,
    this.currentList,
    this.navigateFolder,
    this.getSpacesListsFoldersResult,
    this.getSpacesListsFoldersFailure,
    this.currentListTasks,
    this.getListDetailsAndTasksFailure,
    this.addListResult,
    this.createListFailure,
    this.createFolderResult,
    this.createFolderFailure,
    this.createTaskResult,
    this.createTaskFailure,
    this.updateTaskFailure,
    this.deleteListResult,
    this.deleteListFailure,
    this.deleteFolderResult,
    this.deleteFolderFailure,
    this.deleteTaskResult,
    this.deleteTaskFailure,
    this.clickupWorkspace,
    this.clickupSpace,
    this.createClickupListInFolderParams,
    this.createFolderlessListClickupParams,
    this.moveClickupTaskBetweenListsParams,
    this.createClickupFolderInSpaceParams,
    this.deleteClickupFolderParams,
    this.deleteClickupListParams,
    this.moveTaskBetweenListsResult,
    this.moveTaskBetweenListsFailure,
    this.folderToCreateListIn,
    this.toDeleteList,
    this.toDeleteFolder
  });

  bool get isInit => listsPageStatus == ListsPageStatus.initial;

  bool get isLoading => listsPageStatus == ListsPageStatus.isLoading;

  GetClickupTasksInWorkspaceFiltersParams
      get defaultTasksInWorkspaceFiltersParams {
    List<String>? filterBySpaceIds;
    if (Globals.isSpaceAppWide && Globals.selectedSpaceId != null) {
      filterBySpaceIds = [Globals.selectedSpace?.id ?? ""];
    }
    return GetClickupTasksInWorkspaceFiltersParams(
      filterBySpaceIds: filterBySpaceIds,
      clickupAccessToken: Globals.clickupAuthAccessToken,
      filterByAssignees: [Globals.clickupUser?.id.toString() ?? ""],
    );
  }

  List<ClickupTask> get getCurrentListTasksOverdue =>
      currentListTasks?.where((element) => element.isOverdue).toList() ?? [];
  List<ClickupTask> get getCurrentListTasksUpcoming =>
      currentListTasks?.where((element) => element.isUpcoming).toList() ?? [];
  List<ClickupTask> get getCurrentListTasksUnscheduled =>
      currentListTasks?.where((element) => element.isUnscheduled).toList() ?? [];

  List<ClickupTask> get getCurrentListTasksCompleted =>
      currentListTasks?.where((element) => element.isCompleted).toList() ?? [];
  @override
  List<Object?> get props => [
        listsPageStatus,
        navigateList,
        currentList,
        navigateFolder,
        getSpacesListsFoldersResult,
        getSpacesListsFoldersFailure,
        currentListTasks,
        getListDetailsAndTasksFailure,
        addListResult,
        createListFailure,
        createFolderResult,
        createFolderFailure,
        createTaskResult,
        createTaskFailure,
        updateTaskFailure,
        deleteListResult,
        deleteListFailure,
        deleteFolderResult,
        deleteFolderFailure,
        deleteTaskResult,
        deleteTaskFailure,
        clickupWorkspace,
        clickupSpace,
        createClickupListInFolderParams,
        createFolderlessListClickupParams,
        moveClickupTaskBetweenListsParams,
        createClickupFolderInSpaceParams,
        deleteClickupFolderParams,
        deleteClickupListParams,
        moveTaskBetweenListsResult,
        moveTaskBetweenListsFailure,
        folderToCreateListIn,
        toDeleteList,
        toDeleteFolder
      ];

  bool tryCreateListInFolder(Folder folder) =>
      listsPageStatus == ListsPageStatus.createListInFolderTry &&
      folderToCreateListIn == folder;

  bool get tryCreateListInSpace =>
      listsPageStatus == ListsPageStatus.createListInSpaceTry ;

  bool get tryCreateFolderInSpace =>
      listsPageStatus == ListsPageStatus.createFolderTry ;

  ListsPageState copyWith({
    required ListsPageStatus listsPageStatus,
    ClickupList? navigateList,
    ClickupList? currentList,
    Folder? navigateFolder,
    List<Space>? getSpacesListsFoldersResult,
    List<Map<String, Failure>>? getSpacesListsFoldersFailure,
    List<ClickupTask>? currentListTasks,
    FailuresList? getListDetailsAndTasksFailure,
    List<ClickupList>? addListResult,
    Failure? createListFailure,
    List<Folder>? createFolderResult,
    Failure? createFolderFailure,
    List<ClickupTask>? createTaskResult,
    Failure? createTaskFailure,
    List<ClickupTask>? deleteListResult,
    Failure? deleteListFailure,
    List<Folder>? deleteFolderResult,
    Failure? deleteFolderFailure,
    List<ClickupTask>? deleteTaskResult,
    Failure? deleteTaskFailure,
    ClickupWorkspace? clickupWorkspace,
    Space? clickupSpace,
    CreateClickupListInFolderParams? createClickupListInFolderParams,
    CreateFolderlessListClickupParams? createFolderlessListClickupParams,
    MoveClickupTaskBetweenListsParams? moveClickupTaskBetweenListsParams,
    CreateClickupFolderInSpaceParams? createClickupFolderInSpaceParams,
    DeleteClickupFolderParams? deleteClickupFolderParams,
    DeleteClickupListParams? deleteClickupListParams,
    Unit? moveTaskBetweenListsResult,
    Failure? moveTaskBetweenListsFailure,
    Failure? updateTaskFailure,
    Folder? folderToCreateListIn,
    ClickupList? toDeleteList,
    Folder? toDeleteFolder,
  }) {
    return ListsPageState(
      listsPageStatus: listsPageStatus,
      navigateList: navigateList,
      currentList: currentList,
      navigateFolder: navigateFolder,
      getSpacesListsFoldersResult:
          getSpacesListsFoldersResult ?? this.getSpacesListsFoldersResult,
      getSpacesListsFoldersFailure:
          getSpacesListsFoldersFailure ?? this.getSpacesListsFoldersFailure,
      currentListTasks: currentListTasks ?? this.currentListTasks,
      getListDetailsAndTasksFailure:
          getListDetailsAndTasksFailure ?? this.getListDetailsAndTasksFailure,
      addListResult: addListResult ?? this.addListResult,
      createListFailure: createListFailure ?? this.createListFailure,
      createFolderResult: createFolderResult ?? this.createFolderResult,
      createFolderFailure: createFolderFailure ?? this.createFolderFailure,
      createTaskResult: createTaskResult ?? this.createTaskResult,
      createTaskFailure: createTaskFailure ?? this.createTaskFailure,
      deleteListResult: deleteListResult ?? this.deleteListResult,
      deleteListFailure: deleteListFailure ?? this.deleteListFailure,
      deleteFolderResult: deleteFolderResult ?? this.deleteFolderResult,
      deleteFolderFailure: deleteFolderFailure ?? this.deleteFolderFailure,
      deleteTaskResult: deleteTaskResult ?? this.deleteTaskResult,
      deleteTaskFailure: deleteTaskFailure ?? this.deleteTaskFailure,
      clickupWorkspace: clickupWorkspace ?? this.clickupWorkspace,
      clickupSpace: clickupSpace ?? this.clickupSpace,
      moveTaskBetweenListsResult:
          moveTaskBetweenListsResult ?? this.moveTaskBetweenListsResult,
      moveTaskBetweenListsFailure:
          moveTaskBetweenListsFailure ?? this.moveTaskBetweenListsFailure,
      updateTaskFailure: updateTaskFailure??this.updateTaskFailure,
      createClickupListInFolderParams: createClickupListInFolderParams,
      createFolderlessListClickupParams: createFolderlessListClickupParams,
      moveClickupTaskBetweenListsParams: moveClickupTaskBetweenListsParams,
      createClickupFolderInSpaceParams: createClickupFolderInSpaceParams,
      deleteClickupFolderParams: deleteClickupFolderParams,
      deleteClickupListParams: deleteClickupListParams,
      folderToCreateListIn: folderToCreateListIn,
      toDeleteList: toDeleteList,
      toDeleteFolder: toDeleteFolder
    );
  }
}
