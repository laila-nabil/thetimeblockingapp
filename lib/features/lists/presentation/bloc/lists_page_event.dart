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
  List<Object?> get props => [getClickupListAndItsTasksParams,];
}

