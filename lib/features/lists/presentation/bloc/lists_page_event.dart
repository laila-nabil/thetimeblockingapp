// ignore_for_file: must_be_immutable

part of 'lists_page_bloc.dart';

abstract class ListsPageEvent extends Equatable {
  const ListsPageEvent();
}

class GetListAndFoldersInListsPageEvent extends ListsPageEvent {
  final ClickupAccessToken clickupAccessToken;
  final Workspace clickupWorkspace;
  Space? clickupSpace;

  GetListAndFoldersInListsPageEvent.inSpace(
      {required this.clickupAccessToken,
      required this.clickupWorkspace,
      required this.clickupSpace});

  GetListAndFoldersInListsPageEvent.inWorkSpace({
    required this.clickupAccessToken,
    required this.clickupWorkspace,
  }) {
    clickupSpace = null;
  }

  @override
  List<Object?> get props =>
      [clickupAccessToken, clickupWorkspace, clickupSpace];
}

class NavigateToListPageEvent extends ListsPageEvent {
  final TasksList list;

  const NavigateToListPageEvent(this.list);

  @override
  List<Object?> get props => [list];
}

class GetListDetailsAndTasksInListEvent extends ListsPageEvent {
  final GetClickupListAndItsTasksParams getClickupListAndItsTasksParams;

  const GetListDetailsAndTasksInListEvent(
      {required this.getClickupListAndItsTasksParams});

  @override
  List<Object?> get props => [
        getClickupListAndItsTasksParams,
      ];
}

class StartCreateListInFolderEvent extends ListsPageEvent {
  final CreateListInFolderParams createClickupListInFolderParams;
  final Workspace clickupWorkspace;
  final Space? clickupSpace;
  final bool tryEvent;

  const StartCreateListInFolderEvent({
    required this.createClickupListInFolderParams,
    required this.clickupWorkspace,
    this.clickupSpace,
    this.tryEvent = false,
  });

  @override
  List<Object?> get props => [
    createClickupListInFolderParams,
  ];
}

class CreateListInFolderEvent extends ListsPageEvent {
  CreateListInFolderParams? createClickupListInFolderParams;
  Workspace? clickupWorkspace;
  Space? clickupSpace;
  Folder? folderToCreateListIn;
  bool? tryEvent;

  CreateListInFolderEvent.tryCreate({required Folder this.folderToCreateListIn}){
    tryEvent = true;
  }
  CreateListInFolderEvent.cancelCreate(){
    tryEvent = false;
  }
  CreateListInFolderEvent.submit({
    required CreateListInFolderParams this.createClickupListInFolderParams,
    required Workspace this.clickupWorkspace,
    required Space this.clickupSpace,
  }){
    tryEvent = false;
  }

  @override
  List<Object?> get props => [
        createClickupListInFolderParams,
        clickupWorkspace,
        clickupSpace,
        tryEvent,
      ];
}

class CreateFolderlessListEvent extends ListsPageEvent {
  CreateFolderlessListClickupParams? createFolderlessListClickupParams;
  Workspace? clickupWorkspace;
  Space? clickupSpace;
  bool? tryEvent;

  CreateFolderlessListEvent.tryCreate(){
    tryEvent = true;
  }
  CreateFolderlessListEvent.cancelCreate(){
    tryEvent = false;
  }
  CreateFolderlessListEvent.submit({
    required CreateFolderlessListClickupParams this.createFolderlessListClickupParams,
    required Workspace this.clickupWorkspace,
    required Space this.clickupSpace,
  }){
    tryEvent = false;
  }
  @override
  List<Object?> get props =>
      [createFolderlessListClickupParams, clickupWorkspace, clickupSpace, tryEvent];
}

class MoveTaskBetweenListsEvent extends ListsPageEvent {
  final MoveTaskBetweenListsParams moveClickupTaskBetweenListsParams;
  final Workspace clickupWorkspace;
  final Space? clickupSpace;
  final bool tryEvent;

  const MoveTaskBetweenListsEvent({
    required this.moveClickupTaskBetweenListsParams,
    required this.clickupWorkspace,
    this.clickupSpace,
    this.tryEvent = false,
  });

  @override
  List<Object?> get props => [
        moveClickupTaskBetweenListsParams,
        clickupWorkspace,
        clickupSpace,
        tryEvent
      ];
}

class CreateFolderInSpaceEvent extends ListsPageEvent {
  CreateFolderInSpaceParams? createClickupFolderInSpaceParams;
  Workspace? clickupWorkspace;
  Space? clickupSpace;
  bool? tryEvent;

  CreateFolderInSpaceEvent.tryCreate(){
    tryEvent = true;
  }
  CreateFolderInSpaceEvent.cancelCreate(){
    tryEvent = false;
  }
  CreateFolderInSpaceEvent.submit({
    required CreateFolderInSpaceParams this.createClickupFolderInSpaceParams,
    required Workspace this.clickupWorkspace,
    required Space this.clickupSpace,
  }){
    tryEvent = false;
  }

  @override
  List<Object?> get props => [
        createClickupFolderInSpaceParams,
        clickupWorkspace,
        clickupSpace,
        tryEvent
      ];
}

class DeleteFolderEvent extends ListsPageEvent {
  DeleteFolderParams? deleteClickupFolderParams;
  Workspace? clickupWorkspace;
  Space? clickupSpace;
  Folder? toDeleteFolder;
  bool? tryEvent;

  DeleteFolderEvent.tryDelete(Folder this.toDeleteFolder){
    tryEvent = true;
  }
  DeleteFolderEvent.cancelDelete(){
    tryEvent = false;
  }
  DeleteFolderEvent.submit({
    required DeleteFolderParams this.deleteClickupFolderParams,
    required Workspace this.clickupWorkspace,
    required Space this.clickupSpace,
  }){
    tryEvent = false;
  }

  @override
  List<Object?> get props => [
        deleteClickupFolderParams,
      ];
}

class DeleteListEvent extends ListsPageEvent {
  DeleteListParams? deleteClickupListParams;
  Workspace? clickupWorkspace;
  Space? clickupSpace;
  TasksList? toDeleteList;
  bool? tryEvent;

  DeleteListEvent.tryDelete(TasksList this.toDeleteList){
    tryEvent = true;
  }
  DeleteListEvent.cancelDelete(){
    tryEvent = false;
  }
  DeleteListEvent.submit({
    required DeleteListParams this.deleteClickupListParams,
    required Workspace this.clickupWorkspace,
    required Space this.clickupSpace,
  }){
    tryEvent = false;
  }

  @override
  List<Object?> get props =>
      [deleteClickupListParams, clickupWorkspace, clickupSpace, tryEvent];
}

class CreateTaskEvent extends ListsPageEvent {
  final CreateTaskParams params;

  const CreateTaskEvent({required this.params});

  @override
  List<Object?> get props => [params];
}
class DuplicateTaskEvent extends ListsPageEvent {
  final CreateTaskParams params;

  const DuplicateTaskEvent({required this.params});

  @override
  List<Object?> get props => [params];
}

class UpdateTaskEvent extends ListsPageEvent {
  final CreateTaskParams params;

  const UpdateTaskEvent({required this.params});

  @override
  List<Object?> get props => [params];
}

class DeleteTaskEvent extends ListsPageEvent {
  final DeleteTaskParams params;

  const DeleteTaskEvent({required this.params});

  @override
  List<Object?> get props => [params];
}