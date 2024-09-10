part of 'lists_page_bloc.dart';

enum ListsPageStatus {
  initial,
  isLoading,
  getListDetailsSuccess,
  getListDetailsFailed,
  getTasksSuccess,
  getTasksFailed,
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
  final bool triedGetData;
  final ListsPageStatus listsPageStatus;
  final TasksList? navigateList;
  final TasksList? currentList;
  final Folder? navigateFolder;
  final List<Task>? currentListTasks;
  final FailuresList? getTasksFailure;
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
    required this.triedGetData,
    required this.listsPageStatus,
    this.navigateList,
    this.currentList,
    this.navigateFolder,
    this.currentListTasks,
    this.getTasksFailure,
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

  bool canGetData(bool isGlobalStateLoading) =>
      listsPageStatus == ListsPageStatus.initial &&
      triedGetData == false &&
      isGlobalStateLoading == false;

  bool get isLoading => listsPageStatus == ListsPageStatus.isLoading;

  bool get needUpdateAllInWorkspace =>
      listsPageStatus == ListsPageStatus.createFolderSuccess ||
      listsPageStatus == ListsPageStatus.createListInFolderSuccess ||
      listsPageStatus == ListsPageStatus.createListInSpaceSuccess ||
      listsPageStatus == ListsPageStatus.deleteFolderSuccess ||
      listsPageStatus == ListsPageStatus.deleteListSuccess ||
      listsPageStatus == ListsPageStatus.getTasksSuccess;

  GetTasksInWorkspaceFiltersParams
      defaultTasksInWorkspaceFiltersParams(AccessToken accessToken , User? user) {
    List<String>? filterBySpaceIds;
    // if (serviceLocator<bool>(instanceName:ServiceLocatorName.isWorkspaceAndSpaceAppWide.name) && BlocProvider.of<GlobalBloc>(context).state.selectedSpace?.id != null) {
    //   filterBySpaceIds = [BlocProvider.of<GlobalBloc>(context).state.selectedSpace?.id ?? ""];
    // }
    return GetTasksInWorkspaceFiltersParams(
      filterBySpaceIds: filterBySpaceIds,
      accessToken: accessToken,
      filterByAssignees: [user?.id.toString() ?? ""],
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
        triedGetData,
        listsPageStatus,
        navigateList,
        currentList,
        navigateFolder,
        currentListTasks,
        getTasksFailure,
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
    bool? triedGetData,
    required ListsPageStatus listsPageStatus,
    TasksList? navigateList,
    TasksList? currentList,
    Folder? navigateFolder,
    List<Task>? currentListTasks,
    Failure? getTasksFailure,
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
        triedGetData: triedGetData ?? this.triedGetData,
      listsPageStatus: listsPageStatus,
      navigateList: navigateList,
      currentList: currentList,
      navigateFolder: navigateFolder,
      currentListTasks: currentListTasks ?? this.currentListTasks,
      getTasksFailure:
          getTasksFailure ?? this.getTasksFailure,
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
