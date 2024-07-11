// ignore_for_file: must_be_immutable

part of 'tags_page_bloc.dart';

abstract class TagsPageEvent extends Equatable {
  const TagsPageEvent();
}

class NavigateToTagPageEvent extends TagsPageEvent {
  final Tag tag;
  final bool insideTagPage;
  const NavigateToTagPageEvent({required this.tag,required this.insideTagPage});

  @override
  List<Object?> get props => [tag,insideTagPage];
}

class GetClickupTagsInSpaceEvent extends TagsPageEvent {
  final GetClickupTagsInSpaceParams params;

  const GetClickupTagsInSpaceEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class GetClickupTasksForTagEvent extends TagsPageEvent {
  final ClickupAccessToken clickupAccessToken;
  final Tag tag;
  final Space space;
  final Workspace workspace;

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
  UpdateClickupTagParams? params;
  bool? tryEvent;
  final bool insideTagPage;
  UpdateClickupTagEvent.tryUpdate({this.params,required this.insideTagPage}) {
    tryEvent = true;
  }

  UpdateClickupTagEvent.cancel({required this.insideTagPage}) {
    tryEvent = false;
  }

  UpdateClickupTagEvent.submit({this.params,required this.insideTagPage}) {
    tryEvent = false;
  }

  @override
  List<Object?> get props => [params,tryEvent,insideTagPage];
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
  final Workspace workspace;

  const CreateClickupTaskEvent({
    required this.params,
    required this.workspace,
  });

  @override
  List<Object?> get props => [params, workspace];
}

class DuplicateClickupTaskEvent extends TagsPageEvent {
  final ClickupTaskParams params;
  final Workspace workspace;

  const DuplicateClickupTaskEvent({
    required this.params,
    required this.workspace,
  });

  @override
  List<Object?> get props => [params, workspace];
}

class UpdateClickupTaskEvent extends TagsPageEvent {
  final ClickupTaskParams params;
  final Workspace workspace;

  const UpdateClickupTaskEvent({
    required this.params,
    required this.workspace,
  });

  @override
  List<Object?> get props => [params,workspace];
}

class DeleteClickupTaskEvent extends TagsPageEvent {
  final DeleteClickupTaskParams params;
  final Workspace workspace;

  const DeleteClickupTaskEvent({
    required this.params,
    required this.workspace,
  });

  @override
  List<Object?> get props => [params,workspace];
}
