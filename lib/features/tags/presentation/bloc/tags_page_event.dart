// ignore_for_file: must_be_immutable

part of 'tags_page_bloc.dart';

abstract class TagsPageEvent extends Equatable {
  const TagsPageEvent();
}

class NavigateToTagPageEvent extends TagsPageEvent {
  final ClickupTag tag;

  const NavigateToTagPageEvent(this.tag);

  @override
  List<Object?> get props => [tag];
}

class GetClickupTagsInSpaceEvent extends TagsPageEvent {
  final GetClickupTagsInSpaceParams params;

  const GetClickupTagsInSpaceEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class GetClickupTasksForTagEvent extends TagsPageEvent {
  final ClickupAccessToken clickupAccessToken;
  final ClickupTag tag;
  final ClickupSpace space;
  final ClickupWorkspace workspace;

  const GetClickupTasksForTagEvent(
      {required this.clickupAccessToken,
      required this.tag,
      required this.workspace,
      required this.space});

  @override
  List<Object?> get props => [clickupAccessToken, tag, space];
}

class CreateClickupTagInSpaceEvent extends TagsPageEvent {
  CreateClickupTagInSpaceParams? params;
  bool? tryEvent;
  CreateClickupTagInSpaceEvent.tryCreate(){
    tryEvent = true;
  }
  CreateClickupTagInSpaceEvent.cancelCreate(){
    tryEvent = false;
  }
  CreateClickupTagInSpaceEvent.submit({
    required CreateClickupTagInSpaceParams this.params
  }){
    tryEvent = false;
  }

  @override
  List<Object?> get props => [params,tryEvent];
}

class UpdateClickupTagEvent extends TagsPageEvent {
  final UpdateClickupTagParams params;

  const UpdateClickupTagEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class DeleteClickupTagEvent extends TagsPageEvent {
  DeleteClickupTagParams? params;
  bool? tryEvent;

  DeleteClickupTagEvent.tryDelete(this.params) {
    tryEvent = true;
  }

  DeleteClickupTagEvent.cancelDelete() {
    tryEvent = false;
  }

  DeleteClickupTagEvent.submit({this.params}) {
    tryEvent = false;
  }

  @override
  List<Object?> get props => [params];
}

class CreateClickupTaskEvent extends TagsPageEvent {
  final ClickupTaskParams params;
  final ClickupWorkspace workspace;

  const CreateClickupTaskEvent({
    required this.params,
    required this.workspace,
  });

  @override
  List<Object?> get props => [params, workspace];
}

class UpdateClickupTaskEvent extends TagsPageEvent {
  final ClickupTaskParams params;
  final ClickupWorkspace workspace;

  const UpdateClickupTaskEvent({
    required this.params,
    required this.workspace,
  });

  @override
  List<Object?> get props => [params,workspace];
}

class DeleteClickupTaskEvent extends TagsPageEvent {
  final DeleteClickupTaskParams params;
  final ClickupWorkspace workspace;

  const DeleteClickupTaskEvent({
    required this.params,
    required this.workspace,
  });

  @override
  List<Object?> get props => [params,workspace];
}
