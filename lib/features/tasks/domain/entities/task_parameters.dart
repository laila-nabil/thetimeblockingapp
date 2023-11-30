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

  String get getListId => task?.list?.id ?? clickupList?.id ?? "";

  String get taskId => task?.id ?? "";

  List<int>? get assigneesId =>
      assignees?.map((e) => e.id?.toInt() ?? 0).toList();

  List<String>? get tagsNames => tags?.map((e) => e.name ?? "").toList();

  int? get getPriority => taskPriority?.getPriorityNum;

  String? get getStatus => taskStatus?.status;

  int? get getDueDateMillisecondsSinceEpoch => dueDate?.millisecondsSinceEpoch;

  int? get getStartDateMillisecondsSinceEpoch => startDate?.millisecondsSinceEpoch;

  int? get getTimeEstimateMilliseconds => timeEstimate?.inMilliseconds;

  String? get getParentTaskId => parentTask?.id;

  String? get getLinkedTaskId => linkedTask?.id;

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

  ///[dueDateTime] is a true/false value that determines whether you
  /// want to include the time of the due date when creating the task.
  /// For example, do you want the task due on the 10th of October 2023
  /// or the 10th of October 2023 at 6:30 pm? We’ll leave this as false for now.
  bool? get dueDateTime =>
      (clickupTaskParamsEnum == ClickupTaskParamsEnum.update)
          ? didDueDateChange
          : dueDate != null;

  ///[startDateTime] is a true/false value that determines whether you
  /// want to include the time of the start date when creating the task.
  /// For example, do you want the task due on the 10th of October 2023
  /// or the 10th of October 2023 at 6:30 pm? We’ll leave this as false for now.
  bool? get startDateTime => (clickupTaskParamsEnum == ClickupTaskParamsEnum.update)
      ? didStartDateChange
      : startDate != null;

  bool get didDueDateChange =>
      task?.dueDateUtc != null &&
      dueDate?.isAtSameMomentAs(task!.dueDateUtc!) == false;

  bool get didStartDateChange =>
      task?.startDateUtc != null &&
      startDate?.isAtSameMomentAs(task!.startDateUtc!) == false;

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
    ClickupSpace? space,
    ClickupList? list,
    ClickupTag? tag
  }) {
    printDebug("ClickupTaskParams startCreateNewTask task");
    return ClickupTaskParams._(
          clickupTaskParamsEnum: ClickupTaskParamsEnum.create,
          clickupAccessToken: clickupAccessToken,
          startDate: startDate,
          dueDate: dueDate,
          clickupSpace: space,
          clickupList: list,
          tags: tag == null ? null : [tag],
          assignees: [Globals.clickupUser!.asAssignee],);
  }

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
  }) {
    printDebug("ClickupTaskParams createNewTask task");
    return ClickupTaskParams._(
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
  }

  factory ClickupTaskParams.startUpdateTask({
    required ClickupAccessToken clickupAccessToken,
    required ClickupTask task,
  }) {
    printDebug("ClickupTaskParams startUpdateTask task $task");
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
        description: null,//description controlled by text controller
        title: null,//title controlled by text controller
        clickupSpace: space,
        folder: folder,
        clickupList: list,
        taskPriority: task.priority,
        tags: task.tags,
        taskStatus: task.status,
        timeEstimate: task.timeEstimate,
        ///TODO V3 get parentTask
        parentTask: null,
        dueDate: task.dueDateUtc,
        startDate: task.startDateUtc,
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
  }) =>
      ClickupTaskParams._(
          clickupTaskParamsEnum: ClickupTaskParamsEnum.update,
          clickupAccessToken: clickupAccessToken,
          clickupSpace: null,//not updatable
          clickupList: null,//not updatable
          folder: null,//not updatable
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
      Map<String, Object?>  createMap = {
        "name": title,
        "description": description,
        "assignees": assigneesId,
        "tags": tagsNames,
        "status": getStatus,
        "priority": getPriority,
        "due_date": getDueDateMillisecondsSinceEpoch,
        "due_date_time": dueDateTime,
        "time_estimate": getTimeEstimateMilliseconds,
        "start_date": getStartDateMillisecondsSinceEpoch,
        "start_date_time": startDateTime,
        "notify_all": notifyAll,
        "parent": getParentTaskId,
        "links_to": getLinkedTaskId,
        // "custom_fields": [
        //   {"id": "0a52c486-5f05-403b-b4fd-c512ff05131c", "value": 23},
        //   {
        //     "id": "03efda77-c7a0-42d3-8afd-fd546353c2f5",
        //     "value": "Text field input"
        //   }
        // ]
      };
      return createMap;
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
      Map<String, Object?>  updateMap = {};
      if(title?.isNotEmpty == true) updateMap["name"] = title;
      if(description?.isNotEmpty == true) updateMap["description"] = description?.isEmpty == true ? " " : description;
    //To clear the task description, include Description with " "
      if(assignees.isNotEmpty == true) updateMap["assignees"] = assignees;
      if(getPriority != null) updateMap["priority"] = getPriority;
      if(getDueDateMillisecondsSinceEpoch != null) updateMap["due_date"] = getDueDateMillisecondsSinceEpoch;
      if(dueDateTime != null) updateMap["due_date_time"] = dueDateTime;
      if(getTimeEstimateMilliseconds != null) updateMap["time_estimate"] = getTimeEstimateMilliseconds;
      if(getStartDateMillisecondsSinceEpoch != null) updateMap["start_date"] = getStartDateMillisecondsSinceEpoch;
      if(startDateTime != null) updateMap["start_date_time"] = startDateTime;
      if(archived != null) updateMap["archived"] = archived;
      if(getParentTaskId != null) updateMap["getParentTaskId"] = getParentTaskId;
      if(getStatus != null) updateMap["status"] = getStatus;
      return updateMap;
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
    bool? clearPriority,
  }) {
    ClickupSpace? selectedSpace = clickupSpace ?? this.clickupSpace;
    ClickupTaskPriority? selectedPriority =
        clearFolder == true ? null : (taskPriority ?? this.taskPriority);
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
    DateTime? selectedStartDate = startDate ?? this.startDate;
    DateTime? selectedDueDate = dueDate ?? this.dueDate;
    if (selectedStartDate != null &&
        selectedDueDate?.isBefore(selectedStartDate) == true) {
      printDebug("selectedStartDate $selectedStartDate");
      printDebug("selectedDueDate $selectedDueDate");
      if (startDate != null) {
        selectedDueDate = null;
      } else if (dueDate != null) {
        selectedStartDate = null;
      }
      printDebug("selectedStartDate $selectedStartDate");
      printDebug("selectedDueDate $selectedDueDate");
    }
    /*if (selectedStartDate != null &&
        selectedDueDate?.isBefore(selectedStartDate) == true) {
      if (startDate != null) {
        selectedDueDate = null;
      } else if (dueDate != null) {
        selectedStartDate = null;
      }
    }*/
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
      taskPriority: selectedPriority,
      dueDate: selectedDueDate,
      timeEstimate: timeEstimate ?? this.timeEstimate,
      startDate: selectedStartDate,
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
