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

class NavigateToFolderPageEvent extends ListsPageEvent {
  final ClickupFolder folder;

  const NavigateToFolderPageEvent(this.folder);

  @override
  List<Object?> get props => [folder];
}

class GetTasksInListEvent extends ListsPageEvent {
  final ClickupList list;
  final ClickupAccessToken clickupAccessToken;

  const GetTasksInListEvent(
      {required this.list, required this.clickupAccessToken});

  @override
  List<Object?> get props => [list, clickupAccessToken];
}

class GetTasksInFolderEvent extends ListsPageEvent {
  final ClickupFolder folder;
  final ClickupAccessToken clickupAccessToken;

  const GetTasksInFolderEvent(
      {required this.folder, required this.clickupAccessToken});

  @override
  List<Object?> get props => [folder, clickupAccessToken];
}
