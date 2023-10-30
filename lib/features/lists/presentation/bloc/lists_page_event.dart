part of 'lists_page_bloc.dart';

abstract class ListsPageEvent extends Equatable {
  const ListsPageEvent();
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
