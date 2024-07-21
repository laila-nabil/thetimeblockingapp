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
  final TasksList? navigateList;
  final TasksList? currentList;
  final Folder? navigateFolder;
  final List<Space>? getSpacesListsFoldersResult;
  final List<Map<String, Failure>>? getSpacesListsFoldersFailure;
  final List<Task>? currentListTasks;
  final FailuresList? getListDetailsAndTasksFailure;
  final List<TasksList>? addListResult;
  final Failure? createListFailure;
  final List<Folder>? createFolderResult;
  final Failure? createFolderFailure;
  final List<Task>? createTaskResult;
  final Failure? createTaskFailure;
  final Failure? updateTaskFailure;
  final List<Task>? deleteListResult;
  final Failure? deleteListFailure;
  final List<Folder>? deleteFolderResult;
  final Failure? deleteFolderFailure;
  final List<Task>? deleteTaskResult;
  final Failure? deleteTaskFailure;
  final Workspace? workspace;
  final Space? space;
  final CreateListInFolderParams? createListInFolderParams;
  final CreateFolderlessListParams? createFolderlessListParams;
  final MoveTaskBetweenListsParams? moveTaskBetweenListsParams;
  final CreateFolderInSpaceParams? createFolderInSpaceParams;
  final DeleteFolderParams? deleteFolderParams;
  final DeleteListParams? deleteListParams;
  final dartz.Unit? moveTaskBetweenListsResult;
  final Failure? moveTaskBetweenListsFailure;
  final Folder? folderToCreateListIn;
  final TasksList? toDeleteList;
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
    this.workspace,
    this.space,
    this.createListInFolderParams,
    this.createFolderlessListParams,
    this.moveTaskBetweenListsParams,
    this.createFolderInSpaceParams,
    this.deleteFolderParams,
    this.deleteListParams,
    this.moveTaskBetweenListsResult,
    this.moveTaskBetweenListsFailure,
    this.folderToCreateListIn,
    this.toDeleteList,
    this.toDeleteFolder
  });

  bool get isInit => listsPageStatus == ListsPageStatus.initial;

  bool get isLoading => listsPageStatus == ListsPageStatus.isLoading;

  GetTasksInWorkspaceFiltersParams
      get defaultTasksInWorkspaceFiltersParams {
    List<String>? filterBySpaceIds;
    if (Globals.isSpaceAppWide && Globals.selectedSpaceId != null) {
      filterBySpaceIds = [Globals.selectedSpace?.id ?? ""];
    }
    return GetTasksInWorkspaceFiltersParams(
      filterBySpaceIds: filterBySpaceIds,
      accessToken: Globals.accessToken,
      filterByAssignees: [Globals.user?.id.toString() ?? ""],
    );
  }

  List<Task> get getCurrentListTasksOverdue =>
      currentListTasks?.where((element) => element.isOverdue).toList() ?? [];
  List<Task> get getCurrentListTasksUpcoming =>
      currentListTasks?.where((element) => element.isUpcoming).toList() ?? [];
  List<Task> get getCurrentListTasksUnscheduled =>
      currentListTasks?.where((element) => element.isUnscheduled).toList() ?? [];

  List<Task> get getCurrentListTasksCompleted =>
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
        workspace,
        space,
        createListInFolderParams,
        createFolderlessListParams,
        moveTaskBetweenListsParams,
        createFolderInSpaceParams,
        deleteFolderParams,
        deleteListParams,
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
    TasksList? navigateList,
    TasksList? currentList,
    Folder? navigateFolder,
    List<Space>? getSpacesListsFoldersResult,
    List<Map<String, Failure>>? getSpacesListsFoldersFailure,
    List<Task>? currentListTasks,
    FailuresList? getListDetailsAndTasksFailure,
    List<TasksList>? addListResult,
    Failure? createListFailure,
    List<Folder>? createFolderResult,
    Failure? createFolderFailure,
    List<Task>? createTaskResult,
    Failure? createTaskFailure,
    List<Task>? deleteListResult,
    Failure? deleteListFailure,
    List<Folder>? deleteFolderResult,
    Failure? deleteFolderFailure,
    List<Task>? deleteTaskResult,
    Failure? deleteTaskFailure,
    Workspace? workspace,
    Space? space,
    CreateListInFolderParams? createListInFolderParams,
    CreateFolderlessListParams? createFolderlessListParams,
    MoveTaskBetweenListsParams? moveTaskBetweenListsParams,
    CreateFolderInSpaceParams? createFolderInSpaceParams,
    DeleteFolderParams? deleteFolderParams,
    DeleteListParams? deleteListParams,
    dartz.Unit? moveTaskBetweenListsResult,
    Failure? moveTaskBetweenListsFailure,
    Failure? updateTaskFailure,
    Folder? folderToCreateListIn,
    TasksList? toDeleteList,
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
      workspace: workspace ?? this.workspace,
      space: space ?? this.space,
      moveTaskBetweenListsResult:
          moveTaskBetweenListsResult ?? this.moveTaskBetweenListsResult,
      moveTaskBetweenListsFailure:
          moveTaskBetweenListsFailure ?? this.moveTaskBetweenListsFailure,
      updateTaskFailure: updateTaskFailure??this.updateTaskFailure,
      createListInFolderParams: createListInFolderParams,
      createFolderlessListParams: createFolderlessListParams,
      moveTaskBetweenListsParams: moveTaskBetweenListsParams,
      createFolderInSpaceParams: createFolderInSpaceParams,
      deleteFolderParams: deleteFolderParams,
      deleteListParams: deleteListParams,
      folderToCreateListIn: folderToCreateListIn,
      toDeleteList: toDeleteList,
      toDeleteFolder: toDeleteFolder
    );
  }
}
