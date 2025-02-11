// ignore_for_file: must_be_immutable

part of 'lists_page_bloc.dart';

abstract class ListsPageEvent extends Equatable {
  const ListsPageEvent();
}

class TryGetDataEvent extends ListsPageEvent {
  @override
  List<Object?> get props => [];
}
class NavigateToListPageEvent extends ListsPageEvent {
  final TasksList list;

  const NavigateToListPageEvent(this.list);

  @override
  List<Object?> get props => [list];
}

class StartCreateListInFolderEvent extends ListsPageEvent {
  final CreateListInFolderParams createListInFolderParams;
  final Workspace workspace;
  final bool tryEvent;

  const StartCreateListInFolderEvent({
    required this.createListInFolderParams,
    required this.workspace,
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
  Folder? folderToCreateListIn;
  bool? tryEvent;
  final Function() onSuccess;
  CreateListInFolderEvent.tryCreate({required Folder this.folderToCreateListIn,required this.onSuccess}){
    tryEvent = true;
  }
  CreateListInFolderEvent.cancelCreate({required this.onSuccess}){
    tryEvent = false;
  }
  CreateListInFolderEvent.submit({
    required CreateListInFolderParams this.createListInFolderParams,
    required Workspace this.workspace, required this.onSuccess
  }){
    tryEvent = false;
  }

  @override
  List<Object?> get props => [
        createListInFolderParams,
        workspace,
        tryEvent,
      ];
}

class CreateFolderlessListEvent extends ListsPageEvent {
  CreateFolderlessListParams? createFolderlessListParams;
  Workspace? workspace;
  bool? tryEvent;
  final Function() onSuccess;
  CreateFolderlessListEvent.tryCreate({required this.onSuccess}){
    tryEvent = true;
  }
  CreateFolderlessListEvent.cancelCreate({required this.onSuccess}){
    tryEvent = false;
  }
  CreateFolderlessListEvent.submit({
    required CreateFolderlessListParams this.createFolderlessListParams,
    required Workspace this.workspace,
    required this.onSuccess
  }){
    tryEvent = false;
  }
  @override
  List<Object?> get props =>
      [createFolderlessListParams, workspace, tryEvent];
}

class CreateFolderInSpaceEvent extends ListsPageEvent {
  CreateFolderInSpaceParams? createFolderInSpaceParams;
  Workspace? workspace;
  bool? tryEvent;
  final Function() onSuccess;

  CreateFolderInSpaceEvent.tryCreate({required this.onSuccess}){
    tryEvent = true;
  }
  CreateFolderInSpaceEvent.cancelCreate({required this.onSuccess}){
    tryEvent = false;
  }
  CreateFolderInSpaceEvent.submit({
    required CreateFolderInSpaceParams this.createFolderInSpaceParams,
    required Workspace this.workspace,
    required this.onSuccess
  }){
    tryEvent = false;
  }

  @override
  List<Object?> get props => [
        createFolderInSpaceParams,
        workspace,
        tryEvent
      ];
}

class DeleteFolderEvent extends ListsPageEvent {
  DeleteFolderParams? deleteFolderParams;
  Workspace? workspace;
  Folder? toDeleteFolder;
  bool? tryEvent;
  final Function() onSuccess;

  DeleteFolderEvent.tryDelete(Folder this.toDeleteFolder,{required this.onSuccess}){
    tryEvent = true;
  }
  DeleteFolderEvent.cancelDelete({required this.onSuccess}){
    tryEvent = false;
  }
  DeleteFolderEvent.submit({
    required DeleteFolderParams this.deleteFolderParams,
    required Workspace this.workspace,
    required this.onSuccess
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
  TasksList? toDeleteList;
  bool? tryEvent;
  final Function() onSuccess;

  DeleteListEvent.tryDelete(TasksList this.toDeleteList,{required this.onSuccess}){
    tryEvent = true;
  }
  DeleteListEvent.cancelDelete({required this.onSuccess}){
    tryEvent = false;
  }
  DeleteListEvent.submit({
    required DeleteListParams this.deleteListParams,
    required Workspace this.workspace,
    required this.onSuccess
  }){
    tryEvent = false;
  }

  @override
  List<Object?> get props =>
      [deleteListParams, workspace, tryEvent];
}

class CreateTaskEvent extends ListsPageEvent {
  final CreateTaskParams params;
  final int workspaceId;
  final Function() onSuccess;

  const CreateTaskEvent(
      {required this.params,
      required this.workspaceId,
      required this.onSuccess});

  @override
  List<Object?> get props => [params,workspaceId];
}
class DuplicateTaskEvent extends ListsPageEvent {
  final DuplicateTaskParams params;
  final Workspace workspace;
  final Function() onSuccess;
  const DuplicateTaskEvent({
    required this.params,
    required this.workspace,
    required this.onSuccess,
  });

  @override
  List<Object?> get props => [params, workspace];
}

class UpdateTaskEvent extends ListsPageEvent {
  final CreateTaskParams params;
  final Function() onSuccess;
  const UpdateTaskEvent({required this.params, required this.onSuccess});

  @override
  List<Object?> get props => [params];
}

class DeleteTaskEvent extends ListsPageEvent {
  final DeleteTaskParams params;
  final Function() onSuccess;

  const DeleteTaskEvent({required this.params, required this.onSuccess});


  @override
  List<Object?> get props => [params];

}

class GetTasksInListEvent extends ListsPageEvent {
  final GetTasksInWorkspaceParams params;
  final TasksList list;
  const GetTasksInListEvent({required this.params,required this.list});

  @override
  List<Object?> get props => [params,list];
}