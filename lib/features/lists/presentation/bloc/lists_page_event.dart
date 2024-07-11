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
  final CreateClickupListInFolderParams createClickupListInFolderParams;
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
  CreateClickupListInFolderParams? createClickupListInFolderParams;
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
    required CreateClickupListInFolderParams this.createClickupListInFolderParams,
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

class MoveClickupTaskBetweenListsEvent extends ListsPageEvent {
  final MoveClickupTaskBetweenListsParams moveClickupTaskBetweenListsParams;
  final Workspace clickupWorkspace;
  final Space? clickupSpace;
  final bool tryEvent;

  const MoveClickupTaskBetweenListsEvent({
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

class CreateClickupFolderInSpaceEvent extends ListsPageEvent {
  CreateClickupFolderInSpaceParams? createClickupFolderInSpaceParams;
  Workspace? clickupWorkspace;
  Space? clickupSpace;
  bool? tryEvent;

  CreateClickupFolderInSpaceEvent.tryCreate(){
    tryEvent = true;
  }
  CreateClickupFolderInSpaceEvent.cancelCreate(){
    tryEvent = false;
  }
  CreateClickupFolderInSpaceEvent.submit({
    required CreateClickupFolderInSpaceParams this.createClickupFolderInSpaceParams,
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

class DeleteClickupFolderEvent extends ListsPageEvent {
  DeleteClickupFolderParams? deleteClickupFolderParams;
  Workspace? clickupWorkspace;
  Space? clickupSpace;
  Folder? toDeleteFolder;
  bool? tryEvent;

  DeleteClickupFolderEvent.tryDelete(Folder this.toDeleteFolder){
    tryEvent = true;
  }
  DeleteClickupFolderEvent.cancelDelete(){
    tryEvent = false;
  }
  DeleteClickupFolderEvent.submit({
    required DeleteClickupFolderParams this.deleteClickupFolderParams,
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

class DeleteClickupListEvent extends ListsPageEvent {
  DeleteClickupListParams? deleteClickupListParams;
  Workspace? clickupWorkspace;
  Space? clickupSpace;
  TasksList? toDeleteList;
  bool? tryEvent;

  DeleteClickupListEvent.tryDelete(TasksList this.toDeleteList){
    tryEvent = true;
  }
  DeleteClickupListEvent.cancelDelete(){
    tryEvent = false;
  }
  DeleteClickupListEvent.submit({
    required DeleteClickupListParams this.deleteClickupListParams,
    required Workspace this.clickupWorkspace,
    required Space this.clickupSpace,
  }){
    tryEvent = false;
  }

  @override
  List<Object?> get props =>
      [deleteClickupListParams, clickupWorkspace, clickupSpace, tryEvent];
}

class CreateClickupTaskEvent extends ListsPageEvent {
  final ClickupTaskParams params;

  const CreateClickupTaskEvent({required this.params});

  @override
  List<Object?> get props => [params];
}
class DuplicateClickupTaskEvent extends ListsPageEvent {
  final ClickupTaskParams params;

  const DuplicateClickupTaskEvent({required this.params});

  @override
  List<Object?> get props => [params];
}

class UpdateClickupTaskEvent extends ListsPageEvent {
  final ClickupTaskParams params;

  const UpdateClickupTaskEvent({required this.params});

  @override
  List<Object?> get props => [params];
}

class DeleteClickupTaskEvent extends ListsPageEvent {
  final DeleteClickupTaskParams params;

  const DeleteClickupTaskEvent({required this.params});

  @override
  List<Object?> get props => [params];
}