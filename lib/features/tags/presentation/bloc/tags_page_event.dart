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

class GetTagsInWorkspaceEvent extends TagsPageEvent {
  final GetTagsInWorkspaceParams params;

  const GetTagsInWorkspaceEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class GetTasksForTagEvent extends TagsPageEvent {

  final Tag tag;
  final Workspace workspace;

  const GetTasksForTagEvent(
      {
      required this.tag,
      required this.workspace,});

  @override
  List<Object?> get props => [ tag,];
}

class CreateTagInSpaceEvent extends TagsPageEvent {
  CreateTagInWorkspaceParams? params;
  bool? tryEvent;
  CreateTagInSpaceEvent.tryCreate(){
    tryEvent = true;
  }
  CreateTagInSpaceEvent.cancelCreate(){
    tryEvent = false;
  }
  CreateTagInSpaceEvent.submit({
    required CreateTagInWorkspaceParams this.params
  }){
    tryEvent = false;
  }

  @override
  List<Object?> get props => [params,tryEvent];
}

class UpdateTagEvent extends TagsPageEvent {
  UpdateTagParams? params;
  bool? tryEvent;
  final bool insideTagPage;
  UpdateTagEvent.tryUpdate({this.params,required this.insideTagPage}) {
    tryEvent = true;
  }

  UpdateTagEvent.cancel({required this.insideTagPage}) {
    tryEvent = false;
  }

  UpdateTagEvent.submit({this.params,required this.insideTagPage}) {
    tryEvent = false;
  }

  @override
  List<Object?> get props => [params,tryEvent,insideTagPage];
}

class DeleteTagEvent extends TagsPageEvent {
  DeleteTagParams? params;
  bool? tryEvent;

  DeleteTagEvent.tryDelete(this.params) {
    tryEvent = true;
  }

  DeleteTagEvent.cancelDelete() {
    tryEvent = false;
  }

  DeleteTagEvent.submit({this.params}) {
    tryEvent = false;
  }

  @override
  List<Object?> get props => [params];
}

class CreateTaskEvent extends TagsPageEvent {
  final CreateTaskParams params;
  final Workspace workspace;

  const CreateTaskEvent({
    required this.params,
    required this.workspace,
  });

  @override
  List<Object?> get props => [params, workspace];
}

class DuplicateTaskEvent extends TagsPageEvent {
  final DuplicateTaskParams params;
  final Workspace workspace;

  const DuplicateTaskEvent({
    required this.params,
    required this.workspace,
  });

  @override
  List<Object?> get props => [params, workspace];
}

class UpdateTaskEvent extends TagsPageEvent {
  final CreateTaskParams params;
  final Workspace workspace;

  const UpdateTaskEvent({
    required this.params,
    required this.workspace,
  });

  @override
  List<Object?> get props => [params,workspace];
}

class DeleteTaskEvent extends TagsPageEvent {
  final DeleteTaskParams params;
  final Workspace workspace;

  const DeleteTaskEvent({
    required this.params,
    required this.workspace,
  });

  @override
  List<Object?> get props => [params,workspace];
}
