import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_folder.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_space.dart';

import '../../../auth/domain/entities/clickup_access_token.dart';
import 'clickup_list.dart';
import 'clickup_task.dart';

enum ClickupTaskParamsEnum { create, update }

class ClickupTaskParams extends Equatable{
  final ClickupTaskParamsEnum clickupTaskParamsEnum;
  final ClickupAccessToken clickupAccessToken;
  final ClickupList? clickupList;
  final String? title;
  final String? description;
  final List<ClickupAssignee>? assignees;
  final List<ClickupAssignee>? addedAssignees;
  final List<ClickupAssignee>? removedAssignees;
  final List<ClickupTag>? tags;
  final ClickupStatus? taskStatus;
  final ClickupTaskPriority? taskPriority;
  final DateTime? dueDate;
  final Duration? timeEstimate;
  final DateTime? startDate;
  final bool? notifyAll;
  final ClickupTask? parentTask;
  final ClickupTask? linkedTask;
  final bool? requiredCustomFields;
  final ClickupTask? task;
  final bool? archived;

  final ClickupSpace? clickupSpace;
  final ClickupFolder? folder;
  String get listId => clickupList?.id ?? "";

  String get taskId => task?.id ?? "";

  List<int>? get assigneesId =>
      assignees?.map((e) => e.id?.toInt() ?? 0).toList();

  List<String>? get tagsNames => tags?.map((e) => e.name ?? "").toList();

  int? get priority => taskPriority?.getPriorityNum;

  String? get status => taskStatus?.status;

  int? get dueDateMillisecondsSinceEpoch => dueDate?.millisecondsSinceEpoch;

  int? get startDateMillisecondsSinceEpoch => startDate?.millisecondsSinceEpoch;

  int? get timeEstimateMilliseconds => timeEstimate?.inMilliseconds;

  String? get parentTaskId => parentTask?.id;

  String? get linkedTaskId => linkedTask?.id;

  List<ClickupList> get getAvailableLists {
    if (clickupSpace != null && folder != null) {
      return List.of(folder?.lists ?? <ClickupList>[]);
    } else if (clickupSpace != null && folder == null) {
      return List.of(clickupSpace?.lists ?? []);
    }
    return <ClickupList>[];
  }

  const ClickupTaskParams._(
      {this.clickupList,
      this.title,
      this.description,
      this.assignees,
      this.addedAssignees,
      this.removedAssignees,
      this.tags,
      this.taskStatus,
      this.taskPriority,
      this.dueDate,
      this.timeEstimate,
      this.startDate,
      this.notifyAll,
      this.parentTask,
      this.linkedTask,
      this.requiredCustomFields,
      required this.clickupAccessToken,
      required this.clickupTaskParamsEnum,
      this.task,
      this.clickupSpace,
      this.folder,
      this.archived});

  static _isNewTask(ClickupTask? task) =>
      task?.id == null || task?.id?.isEmpty == true;

  bool? get dueDateTime => dueDate!=null;


  bool? get startDateTime => startDate!=null;

  static ClickupTaskParamsEnum getClickupTaskParamsEnum(ClickupTask? task) {
    printDebug("getClickupTaskParamsEnum $task ${_isNewTask(task)
        ? ClickupTaskParamsEnum.create
        : ClickupTaskParamsEnum.update}");
    return _isNewTask(task)
      ? ClickupTaskParamsEnum.create
      : ClickupTaskParamsEnum.update;
  }
  factory ClickupTaskParams.startCreateNewTask({
    required ClickupAccessToken clickupAccessToken,
    DateTime? startDate,
    DateTime? dueDate,
  }) =>
      ClickupTaskParams._(
          clickupTaskParamsEnum: ClickupTaskParamsEnum.create,
          clickupAccessToken: clickupAccessToken,
          startDate: startDate,
          dueDate: dueDate,
          assignees: [Globals.clickupUser!.asAssignee],);

  factory ClickupTaskParams.createNewTask({
    required ClickupAccessToken clickupAccessToken,
    required ClickupList clickupList,
    required String title,
    String? description,
    List<ClickupTag>? tags,
    ClickupStatus? taskStatus,
    ClickupTaskPriority? taskPriority,
    DateTime? dueDate,
    Duration? timeEstimate,
    DateTime? startDate,
    bool? notifyAll,
    ClickupTask? parentTask,
    ClickupTask? linkedTask,
    bool? requiredCustomFields,
    ClickupFolder? folder,
    ClickupSpace? space,
  }) =>
      ClickupTaskParams._(
          clickupTaskParamsEnum: ClickupTaskParamsEnum.create,
          clickupAccessToken: clickupAccessToken,
          clickupSpace: space,
          clickupList: clickupList,
          folder: folder,
          title: title,
          description: description,
          assignees: [Globals.clickupUser!.asAssignee],
          addedAssignees: null,
          removedAssignees: null,
          tags: tags,
          taskStatus: taskStatus,
          task: null,
          archived: null,
          dueDate: dueDate,
          linkedTask: linkedTask,
          parentTask: parentTask,
          notifyAll: notifyAll,
          requiredCustomFields: requiredCustomFields,
          startDate: startDate,
          taskPriority: taskPriority,
          timeEstimate: timeEstimate);

  factory ClickupTaskParams.startUpdateTask({
    required ClickupAccessToken clickupAccessToken,
    required ClickupTask task,
  }) {
    printDebug("startUpdateTask task $task");
    printDebug("startUpdateTask task ${task.space}");
    final space = Globals.clickupSpaces
        ?.firstWhere((element) => element.id == task.space?.id);
    final folder =  space?.folders
        .where((element) => element.id == task.folder?.id).firstOrNull;
    final list = space?.lists
        .where((element) => element.id == task.list?.id)
        .firstOrNull ??  folder?.lists
        ?.where((element) => element.id == task.list?.id)
        .firstOrNull;
    return ClickupTaskParams._(
          clickupTaskParamsEnum: ClickupTaskParamsEnum.update,
          clickupAccessToken: clickupAccessToken,
          task: task,
          clickupSpace: space,
          folder: folder,
          clickupList: list
      );
  }

  factory ClickupTaskParams.updateTask({
    required ClickupAccessToken clickupAccessToken,
    required ClickupTask task,
    String? updatedTitle,
    String? updatedDescription,
    List<ClickupAssignee>? updatedAssignees,
    List<ClickupAssignee>? addedAssignees,
    List<ClickupAssignee>? removedAssignees,
    List<ClickupTag>? updatedTags,
    ClickupStatus? updatedTaskStatus,
    ClickupTaskPriority? updatedTaskPriority,
    DateTime? updatedDueDate,
    bool? updatedDueDateTime,
    Duration? updatedTimeEstimate,
    DateTime? updatedStartDate,
    ClickupTask? updatedParentTask,
    ClickupTask? updatedLinkedTask,
    bool? updatedArchived,
    ClickupFolder? updatedFolder,
    ClickupList? updatedList,
    ClickupSpace? updatedSpace,
  }) =>
      ClickupTaskParams._(
          clickupTaskParamsEnum: ClickupTaskParamsEnum.update,
          clickupAccessToken: clickupAccessToken,
          clickupSpace: updatedSpace,
          clickupList: updatedList,
          folder: updatedFolder,
          title: updatedTitle,
          description: updatedDescription,
          assignees: updatedAssignees,
          addedAssignees: addedAssignees,
          removedAssignees: removedAssignees,
          tags: updatedTags,
          taskStatus: updatedTaskStatus,
          task: task,
          archived: updatedArchived,
          dueDate: updatedDueDate,
          linkedTask: updatedLinkedTask,
          parentTask: updatedParentTask,
          notifyAll: null,
          requiredCustomFields: null,
          startDate: updatedStartDate,
          taskPriority: updatedTaskPriority,
          timeEstimate: updatedTimeEstimate);

  Map<String, dynamic> toJson() {
    if (clickupTaskParamsEnum == ClickupTaskParamsEnum.create) {
      return {
        "name": title,
        "description": description,
        "assignees": assigneesId,
        "tags": tagsNames,
        "status": status,
        "priority": priority,
        "due_date": dueDateMillisecondsSinceEpoch,
        "due_date_time": dueDateTime,
        "time_estimate": timeEstimateMilliseconds,
        "start_date": startDateMillisecondsSinceEpoch,
        "start_date_time": startDateTime,
        "notify_all": notifyAll,
        "parent": parentTaskId,
        "links_to": linkedTaskId,
        // "custom_fields": [
        //   {"id": "0a52c486-5f05-403b-b4fd-c512ff05131c", "value": 23},
        //   {
        //     "id": "03efda77-c7a0-42d3-8afd-fd546353c2f5",
        //     "value": "Text field input"
        //   }
        // ]
      };
    } else {
      List<int>? addedAssigneesId =
          addedAssignees?.map((e) => e.id?.toInt() ?? 0).toList();

      List<int>? removedAssigneesId =
          removedAssignees?.map((e) => e.id?.toInt() ?? 0).toList();
      Map<String, dynamic> assignees = {};
      if (addedAssigneesId?.isNotEmpty == true) {
        assignees["add"] = addedAssigneesId;
      }
      if (removedAssigneesId?.isNotEmpty == true) {
        assignees["rem"] = removedAssigneesId;
      }
      return {
        "name": title,
        "description": description?.isEmpty == true ? " " : description,
        //To clear the task description, include Description with " "
        "assignees": assignees,
        "tags": tagsNames,
        "status": status,
        "priority": priority,
        "due_date": dueDateMillisecondsSinceEpoch,
        "due_date_time": dueDateTime,
        "time_estimate": timeEstimateMilliseconds,
        "start_date": startDateMillisecondsSinceEpoch,
        "start_date_time": startDateMillisecondsSinceEpoch,
        "archived": archived,
        "parent": parentTaskId,
      };
    }
  }

  ClickupTaskParams copyWith({
    ClickupTaskParamsEnum? clickupTaskParamsEnum,
    ClickupAccessToken? clickupAccessToken,
    ClickupList? clickupList,
    String? title,
    String? description,
    List<ClickupAssignee>? assignees,
    List<ClickupAssignee>? addedAssignees,
    List<ClickupAssignee>? removedAssignees,
    List<ClickupTag>? tags,
    ClickupStatus? taskStatus,
    ClickupTaskPriority? taskPriority,
    DateTime? dueDate,
    Duration? timeEstimate,
    DateTime? startDate,
    bool? notifyAll,
    ClickupTask? parentTask,
    ClickupTask? linkedTask,
    bool? requiredCustomFields,
    ClickupTask? task,
    bool? archived,
    List<int>? addedAssigneesId,
    List<int>? removedAssigneesId,
    ClickupSpace? clickupSpace,
    ClickupFolder? folder,
    bool? clearFolder,
  }) {
    ClickupSpace? selectedSpace = clickupSpace ?? this.clickupSpace;
    ClickupFolder? selectedFolder =
        clearFolder == true ? null : (folder ?? this.folder);
    if (selectedSpace?.folders.contains(selectedFolder) == false) {
      selectedFolder = null;
    }

    ClickupList? selectedList = clickupList ?? this.clickupList;
    if ((selectedFolder != null &&
            selectedFolder.lists?.contains(selectedList) == false) ||
        (selectedSpace != null &&
            selectedFolder == null &&
            selectedSpace.lists.contains(selectedList) == false)) {
      selectedList = null;
    }

    return ClickupTaskParams._(
      clickupTaskParamsEnum:
          clickupTaskParamsEnum ?? this.clickupTaskParamsEnum,
      clickupAccessToken: clickupAccessToken ?? this.clickupAccessToken,
      clickupList: selectedList,
      title: title ?? this.title,
      description: description ?? this.description,
      assignees: assignees ?? this.assignees,
      addedAssignees: addedAssignees ?? this.addedAssignees,
      removedAssignees: removedAssignees ?? this.removedAssignees,
      tags: tags ?? this.tags,
      taskStatus: taskStatus ?? this.taskStatus,
      taskPriority: taskPriority ?? this.taskPriority,
      dueDate: dueDate ?? this.dueDate,
      timeEstimate: timeEstimate ?? this.timeEstimate,
      startDate: startDate ?? this.startDate,
      notifyAll: notifyAll ?? this.notifyAll,
      parentTask: parentTask ?? this.parentTask,
      linkedTask: linkedTask ?? this.linkedTask,
      requiredCustomFields: requiredCustomFields ?? this.requiredCustomFields,
      task: task ?? this.task,
      archived: archived ?? this.archived,
      folder: selectedFolder,
      clickupSpace: selectedSpace
    );
  }

  @override
  List<Object?> get props => [clickupList,
    title,
    description,
    assignees,
    addedAssignees,
    removedAssignees,
    tags,
    taskStatus,
    taskPriority,
    dueDate,
    dueDateTime,
    timeEstimate,
    startDate,
    startDateTime,
    notifyAll,
    parentTask,
    linkedTask,
    requiredCustomFields,
    clickupAccessToken,
    clickupTaskParamsEnum,
    task,
    folder,
    clickupSpace,
    getAvailableLists,
    archived];
}
