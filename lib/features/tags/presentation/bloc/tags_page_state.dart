part of 'tags_page_bloc.dart';

enum TagsPageStatus {
  initial,
  loading,
  getTagsSuccess,
  getTagsFailure,
  getTasksForTagSuccess,
  getTasksForTagFailure,
  createTagTry,
  createTagSuccess,
  createTagFailure,
  updateTagTry,
  updateTagSuccess,
  updateTagFailure,
  deleteTagTry,
  deleteTagCanceled,
  deleteTagSuccess,
  deleteTagFailure,
  createTaskSuccess,
  createTaskFailed,
  updateTaskSuccess,
  updateTaskFailed,
  deleteTaskTry,
  deleteTaskSuccess,
  deleteTaskFailed,
  navigateTag
}

class TagsPageState extends Equatable {
  final TagsPageStatus tagsPageStatus;
  final ClickupTag? navigateTag;
  final List<ClickupTag>? getTagsInSpaceResult;
  final Failure? getTagsInSpaceFailure;
  final Failure? getTasksForTagFailure;
  final Failure? createTagFailure;
  final ClickupTag? updateTagResult;
  final Failure? updateTagFailure;
  final Failure? deleteTagFailure;
  final List<ClickupTask>? currentTagTasksResult;
  final Failure? createTaskFailure;
  final Failure? updateTaskFailure;
  final ClickupTag? toDeleteTag;

  const TagsPageState(
      {required this.tagsPageStatus,
      this.navigateTag,
      this.getTagsInSpaceResult,
      this.getTagsInSpaceFailure,
      this.getTasksForTagFailure,
      this.createTagFailure,
      this.updateTagResult,
      this.updateTagFailure,
      this.deleteTagFailure,
      this.currentTagTasksResult,
      this.createTaskFailure,
      this.updateTaskFailure,
      this.toDeleteTag});

  @override
  List<Object?> get props => [
        tagsPageStatus,
        navigateTag,
        getTagsInSpaceResult,
        getTagsInSpaceFailure,
        getTasksForTagFailure,
        createTagFailure,
        updateTagResult,
        updateTagFailure,
        deleteTagFailure,
        currentTagTasksResult,
        createTaskFailure,
        updateTaskFailure,
        toDeleteTag
      ];

  bool get isInit => tagsPageStatus == TagsPageStatus.initial;

  bool get isLoading => tagsPageStatus == TagsPageStatus.loading;

  TagsPageState copyWith({
    required TagsPageStatus tagsPageStatus,
    ClickupTag? navigateTag,
    List<ClickupTag>? getTagsInSpaceResult,
    Failure? getTagsInSpaceFailure,
    Failure? getTasksForTagFailure,
    Failure? createTagFailure,
    ClickupTag? updateTagResult,
    Failure? updateTagFailure,
    Failure? deleteTagFailure,
    List<ClickupTask>? currentTagTasksResult,
    Failure? createTaskFailure,
    Failure? updateTaskFailure,
    ClickupTag? toDeleteTag,
  }) {
    return TagsPageState(
      tagsPageStatus: tagsPageStatus,
      navigateTag: navigateTag ?? this.navigateTag,
      getTagsInSpaceResult: getTagsInSpaceResult ?? this.getTagsInSpaceResult,
      getTagsInSpaceFailure:
          getTagsInSpaceFailure ?? this.getTagsInSpaceFailure,
      getTasksForTagFailure:getTasksForTagFailure??this.getTasksForTagFailure,
      createTagFailure: createTagFailure ?? this.createTagFailure,
      updateTagResult: updateTagResult ?? this.updateTagResult,
      updateTagFailure: updateTagFailure ?? this.updateTagFailure,
      deleteTagFailure: deleteTagFailure ?? this.deleteTagFailure,
      currentTagTasksResult: currentTagTasksResult ?? this.currentTagTasksResult,
      createTaskFailure: createTaskFailure ?? this.createTaskFailure,
      updateTaskFailure: updateTaskFailure ?? this.updateTaskFailure,
      toDeleteTag: toDeleteTag,
    );
  }
}
