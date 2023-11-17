part of 'lists_page_bloc.dart';

abstract class ListsPageEvent extends Equatable {
  const ListsPageEvent();
}

// ignore: must_be_immutable
class GetListAndFoldersInListsPageEvent extends ListsPageEvent {
  final ClickupAccessToken clickupAccessToken;
  final ClickupWorkspace clickupWorkspace;
  ClickupSpace? clickupSpace;

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
  final ClickupList list;

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
  final ClickupWorkspace clickupWorkspace;
  final ClickupSpace? clickupSpace;
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
  ClickupWorkspace? clickupWorkspace;
  ClickupSpace? clickupSpace;
  bool? tryEvent;

  CreateListInFolderEvent.tryCreate(){
    tryEvent = true;
  }
  CreateListInFolderEvent.cancelCreate(){
    tryEvent = false;
  }
  CreateListInFolderEvent.submit({
    required CreateClickupListInFolderParams this.createClickupListInFolderParams,
    required ClickupWorkspace this.clickupWorkspace,
    required ClickupSpace this.clickupSpace,
  }){
    tryEvent = false;
  }

  @override
  List<Object?> get props => [
        createClickupListInFolderParams,
      ];
}

class CreateFolderlessListEvent extends ListsPageEvent {
  final CreateFolderlessListClickupParams createFolderlessListClickupParams;
  final ClickupWorkspace clickupWorkspace;
  final ClickupSpace? clickupSpace;
  final bool tryEvent;

  const CreateFolderlessListEvent({
    required this.createFolderlessListClickupParams,
    required this.clickupWorkspace,
    this.clickupSpace,
    this.tryEvent = false,
  });

  @override
  List<Object?> get props =>
      [createFolderlessListClickupParams, clickupWorkspace, clickupSpace, tryEvent];
}

class MoveClickupTaskBetweenListsEvent extends ListsPageEvent {
  final MoveClickupTaskBetweenListsParams moveClickupTaskBetweenListsParams;
  final ClickupWorkspace clickupWorkspace;
  final ClickupSpace? clickupSpace;
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
  final CreateClickupFolderInSpaceParams createClickupFolderInSpaceParams;
  final ClickupWorkspace clickupWorkspace;
  final ClickupSpace? clickupSpace;
  final bool tryEvent;

  const CreateClickupFolderInSpaceEvent({
    required this.createClickupFolderInSpaceParams,
    required this.clickupWorkspace,
    this.clickupSpace,
    this.tryEvent = false,
  });

  @override
  List<Object?> get props => [
        createClickupFolderInSpaceParams,
        clickupWorkspace,
        clickupSpace,
        tryEvent
      ];
}

class DeleteClickupFolderEvent extends ListsPageEvent {
  final DeleteClickupFolderParams deleteClickupFolderParams;
  final ClickupWorkspace clickupWorkspace;
  final ClickupSpace? clickupSpace;
  final bool tryEvent;

  const DeleteClickupFolderEvent({
    required this.deleteClickupFolderParams,
    required this.clickupWorkspace,
    this.clickupSpace,
    this.tryEvent = false,
  });

  @override
  List<Object?> get props => [
        deleteClickupFolderParams,
      ];
}

class DeleteClickupListEvent extends ListsPageEvent {
  final DeleteClickupListParams deleteClickupListParams;
  final ClickupWorkspace clickupWorkspace;
  final ClickupSpace? clickupSpace;
  final bool tryEvent;

  const DeleteClickupListEvent({
    required this.deleteClickupListParams,
    required this.clickupWorkspace,
    this.clickupSpace,
    this.tryEvent = false,
  });

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