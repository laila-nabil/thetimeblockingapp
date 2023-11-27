part of 'tags_page_bloc.dart';

enum TagsPageStatus {
  initial,
  loading,
  getTagsSuccess,
  getTagsFailure,
  getTasksForTagSuccess,
  getTasksForTagFailure,
  createTagTry,
  createTagCancel,
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
  navigateTag,refreshTag, updateTagCanceled
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
  final ClickupTag? toUpdateTag;

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
      this.toDeleteTag,
      this.toUpdateTag,
      });

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
        toDeleteTag,
        toUpdateTag,
      ];

  bool get isInit => tagsPageStatus == TagsPageStatus.initial;

  bool get isLoading => tagsPageStatus == TagsPageStatus.loading;

  bool get tryCreateTagInSpace => tagsPageStatus == TagsPageStatus.createTagTry;

  bool updateTagTry(ClickupTag tag) => toUpdateTag == tag && tagsPageStatus == TagsPageStatus.updateTagTry;

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
    ClickupTag? toUpdateTag,
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
      toUpdateTag: toUpdateTag,
    );
  }
}
