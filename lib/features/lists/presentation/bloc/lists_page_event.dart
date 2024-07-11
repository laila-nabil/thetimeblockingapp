// ignore_for_file: must_be_immutable

part of 'lists_page_bloc.dart';

abstract class ListsPageEvent extends Equatable {
  const ListsPageEvent();
}

class GetListAndFoldersInListsPageEvent extends ListsPageEvent {
  final AccessToken accessToken;
  final Workspace workspace;
  Space? space;

  GetListAndFoldersInListsPageEvent.inSpace(
      {required this.accessToken,
      required this.workspace,
      required this.space});

  GetListAndFoldersInListsPageEvent.inWorkSpace({
    required this.accessToken,
    required this.workspace,
  }) {
    space = null;
  }

  @override
  List<Object?> get props =>
      [accessToken, workspace, space];
}

class NavigateToListPageEvent extends ListsPageEvent {
  final TasksList list;

  const NavigateToListPageEvent(this.list);

  @override
  List<Object?> get props => [list];
}

class GetListDetailsAndTasksInListEvent extends ListsPageEvent {
  final GetListAndItsTasksParams getListAndItsTasksParams;

  const GetListDetailsAndTasksInListEvent(
      {required this.getListAndItsTasksParams});

  @override
  List<Object?> get props => [
        getListAndItsTasksParams,
      ];
}

class StartCreateListInFolderEvent extends ListsPageEvent {
  final CreateListInFolderParams createListInFolderParams;
  final Workspace workspace;
  final Space? space;
  final bool tryEvent;

  const StartCreateListInFolderEvent({
    required this.createListInFolderParams,
    required this.workspace,
    this.space,
    this.tryEvent = false,
  });

  @override
  List<Object?> get props => [
    createListInFolderParams,
  ];
}

class CreateListInFolderEvent extends ListsPageEvent {
  CreateListInFolderParams? createListInFolderParams;
  Workspace? workspace;
  Space? space;
  Folder? folderToCreateListIn;
  bool? tryEvent;

  CreateListInFolderEvent.tryCreate({required Folder this.folderToCreateListIn}){
    tryEvent = true;
  }
  CreateListInFolderEvent.cancelCreate(){
    tryEvent = false;
  }
  CreateListInFolderEvent.submit({
    required CreateListInFolderParams this.createListInFolderParams,
    required Workspace this.workspace,
    required Space this.space,
  }){
    tryEvent = false;
  }

  @override
  List<Object?> get props => [
        createListInFolderParams,
        workspace,
        space,
        tryEvent,
      ];
}

class CreateFolderlessListEvent extends ListsPageEvent {
  CreateFolderlessListParams? createFolderlessListParams;
  Workspace? workspace;
  Space? space;
  bool? tryEvent;

  CreateFolderlessListEvent.tryCreate(){
    tryEvent = true;
  }
  CreateFolderlessListEvent.cancelCreate(){
    tryEvent = false;
  }
  CreateFolderlessListEvent.submit({
    required CreateFolderlessListParams this.createFolderlessListParams,
    required Workspace this.workspace,
    required Space this.space,
  }){
    tryEvent = false;
  }
  @override
  List<Object?> get props =>
      [createFolderlessListParams, workspace, space, tryEvent];
}

class MoveTaskBetweenListsEvent extends ListsPageEvent {
  final MoveTaskBetweenListsParams moveTaskBetweenListsParams;
  final Workspace workspace;
  final Space? space;
  final bool tryEvent;

  const MoveTaskBetweenListsEvent({
    required this.moveTaskBetweenListsParams,
    required this.workspace,
    this.space,
    this.tryEvent = false,
  });

  @override
  List<Object?> get props => [
        moveTaskBetweenListsParams,
        workspace,
        space,
        tryEvent
      ];
}

class CreateFolderInSpaceEvent extends ListsPageEvent {
  CreateFolderInSpaceParams? createFolderInSpaceParams;
  Workspace? workspace;
  Space? space;
  bool? tryEvent;

  CreateFolderInSpaceEvent.tryCreate(){
    tryEvent = true;
  }
  CreateFolderInSpaceEvent.cancelCreate(){
    tryEvent = false;
  }
  CreateFolderInSpaceEvent.submit({
    required CreateFolderInSpaceParams this.createFolderInSpaceParams,
    required Workspace this.workspace,
    required Space this.space,
  }){
    tryEvent = false;
  }

  @override
  List<Object?> get props => [
        createFolderInSpaceParams,
        workspace,
        space,
        tryEvent
      ];
}

class DeleteFolderEvent extends ListsPageEvent {
  DeleteFolderParams? deleteFolderParams;
  Workspace? workspace;
  Space? space;
  Folder? toDeleteFolder;
  bool? tryEvent;

  DeleteFolderEvent.tryDelete(Folder this.toDeleteFolder){
    tryEvent = true;
  }
  DeleteFolderEvent.cancelDelete(){
    tryEvent = false;
  }
  DeleteFolderEvent.submit({
    required DeleteFolderParams this.deleteFolderParams,
    required Workspace this.workspace,
    required Space this.space,
  }){
    tryEvent = false;
  }

  @override
  List<Object?> get props => [
        deleteFolderParams,
      ];
}

class DeleteListEvent extends ListsPageEvent {
  DeleteListParams? deleteListParams;
  Workspace? workspace;
  Space? space;
  TasksList? toDeleteList;
  bool? tryEvent;

  DeleteListEvent.tryDelete(TasksList this.toDeleteList){
    tryEvent = true;
  }
  DeleteListEvent.cancelDelete(){
    tryEvent = false;
  }
  DeleteListEvent.submit({
    required DeleteListParams this.deleteListParams,
    required Workspace this.workspace,
    required Space this.space,
  }){
    tryEvent = false;
  }

  @override
  List<Object?> get props =>
      [deleteListParams, workspace, space, tryEvent];
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