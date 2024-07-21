import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/folder.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/space.dart';

import '../../../auth/domain/entities/clickup_access_token.dart';
import 'tasks_list.dart';
import 'task.dart';

enum ClickupTaskParamsEnum { create, update }

class CreateTaskParams extends Equatable{
  final ClickupTaskParamsEnum clickupTaskParamsEnum;
  final ClickupAccessToken clickupAccessToken;
  final TasksList? list;
  final String? title;
  final String? description;
  final List<Assignee>? assignees;
  final List<Assignee>? addedAssignees;
  final List<Assignee>? removedAssignees;
  final List<Tag>? tags;
  final Status? taskStatus;
  final TaskPriority? taskPriority;
  final DateTime? dueDate;
  final Duration? timeEstimate;
  final DateTime? startDate;
  final bool? notifyAll;
  final Task? parentTask;
  final Task? linkedTask;
  final bool? requiredCustomFields;
  final Task? task;
  final bool? archived;

  final Space? space;
  final Folder? folder;

  String get getListId => task?.list?.id ?? list?.id ?? "";

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

  List<TasksList> get getAvailableLists {
    if (space != null && folder != null) {
      return List.of(folder?.lists ?? <TasksList>[]);
    } else if (space != null && folder == null) {
      return List.of(space?.lists ?? []);
    }
    return <TasksList>[];
  }

  factory CreateTaskParams.fromTask(Task clickupTask){
    return CreateTaskParams.createNewTask(
      accessToken: Globals.AccessToken,
      list: clickupTask.list!,
      title: clickupTask.name ?? "",
      description: clickupTask.description,
      dueDate: clickupTask.dueDateUtc,
      folder: clickupTask.folder,
      space: clickupTask.space,
      tags: clickupTask.tags,
      taskPriority: clickupTask.priority,
      startDate: clickupTask.startDateUtc,
      timeEstimate: clickupTask.timeEstimate,
    );
  }
  const CreateTaskParams._(
      {this.list,
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
      this.space,
      this.folder,
      this.archived});

  static _isNewTask(Task? task) =>
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

  static ClickupTaskParamsEnum getClickupTaskParamsEnum(Task? task) {
    printDebug("getClickupTaskParamsEnum $task ${_isNewTask(task)
        ? ClickupTaskParamsEnum.create
        : ClickupTaskParamsEnum.update}");
    return _isNewTask(task)
      ? ClickupTaskParamsEnum.create
      : ClickupTaskParamsEnum.update;
  }
  factory CreateTaskParams.startCreateNewTask({
    required ClickupAccessToken accessToken,
    DateTime? startDate,
    DateTime? dueDate,
    Space? space,
    TasksList? list,
    Tag? tag
  }) {
    printDebug("ClickupTaskParams startCreateNewTask task");
    return CreateTaskParams._(
          clickupTaskParamsEnum: ClickupTaskParamsEnum.create,
          clickupAccessToken: accessToken,
          startDate: startDate,
          dueDate: dueDate,
          space: space,
          list: list,
          tags: tag == null ? null : [tag],
          assignees: [Globals.clickupUser!.asAssignee],);
  }

  factory CreateTaskParams.createNewTask({
    required ClickupAccessToken accessToken,
    required TasksList list,
    required String title,
    String? description,
    List<Tag>? tags,
    Status? taskStatus,
    TaskPriority? taskPriority,
    DateTime? dueDate,
    Duration? timeEstimate,
    DateTime? startDate,
    bool? notifyAll,
    Task? parentTask,
    Task? linkedTask,
    bool? requiredCustomFields,
    Folder? folder,
    Space? space,
  }) {
    printDebug("ClickupTaskParams createNewTask task");
    return CreateTaskParams._(
          clickupTaskParamsEnum: ClickupTaskParamsEnum.create,
          clickupAccessToken: accessToken,
          space: space,
          list: list,
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

  factory CreateTaskParams.startUpdateTask({
    required ClickupAccessToken accessToken,
    required Task task,
  }) {
    printDebug("ClickupTaskParams startUpdateTask task $task");
    printDebug("startUpdateTask task ${task.space}");
    final space = Globals.spaces
        ?.firstWhere((element) => element.id == task.space?.id);
    final folder =  space?.folders
        .where((element) => element.id == task.folder?.id).firstOrNull;
    final list = space?.lists
        .where((element) => element.id == task.list?.id)
        .firstOrNull ??  folder?.lists
        ?.where((element) => element.id == task.list?.id)
            .firstOrNull;
    return CreateTaskParams._(
        clickupTaskParamsEnum: ClickupTaskParamsEnum.update,
        clickupAccessToken: accessToken,
        task: task,
        description: null,//description controlled by text controller
        title: null,//title controlled by text controller
        space: space,
        folder: folder,
        list: list,
        taskPriority: task.priority,
        tags: task.tags,
        taskStatus: task.status,
        timeEstimate: task.timeEstimate,
        ///TODO get parentTask
        parentTask: null,
        dueDate: task.dueDateUtc,
        startDate: task.startDateUtc,
        );
  }

  factory CreateTaskParams.updateTask({
    required ClickupAccessToken accessToken,
    required Task task,
    String? updatedTitle,
    String? updatedDescription,
    List<Assignee>? updatedAssignees,
    List<Assignee>? addedAssignees,
    List<Assignee>? removedAssignees,
    List<Tag>? updatedTags,
    Status? updatedTaskStatus,
    TaskPriority? updatedTaskPriority,
    DateTime? updatedDueDate,
    bool? updatedDueDateTime,
    Duration? updatedTimeEstimate,
    DateTime? updatedStartDate,
    Task? updatedParentTask,
    Task? updatedLinkedTask,
    bool? updatedArchived,
    TasksList? list,
    Folder? folder,
  }) =>
      CreateTaskParams._(
          clickupTaskParamsEnum: ClickupTaskParamsEnum.update,
          clickupAccessToken: accessToken,
          space: null,
          list: list,
          folder: folder,
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

  CreateTaskParams copyWith({
    ClickupTaskParamsEnum? clickupTaskParamsEnum,
    ClickupAccessToken? clickupAccessToken,
    TasksList? list,
    String? title,
    String? description,
    List<Assignee>? assignees,
    List<Assignee>? addedAssignees,
    List<Assignee>? removedAssignees,
    List<Tag>? tags,
    Status? taskStatus,
    TaskPriority? taskPriority,
    DateTime? dueDate,
    Duration? timeEstimate,
    DateTime? startDate,
    bool? notifyAll,
    Task? parentTask,
    Task? linkedTask,
    bool? requiredCustomFields,
    Task? task,
    bool? archived,
    List<int>? addedAssigneesId,
    List<int>? removedAssigneesId,
    Space? space,
    Folder? folder,
    bool? clearFolder,
    bool? clearPriority,
  }) {
    Space? selectedSpace = space ?? this.space;
    TaskPriority? selectedPriority =
        clearFolder == true ? null : (taskPriority ?? this.taskPriority);
    Folder? selectedFolder =
        clearFolder == true ? null : (folder ?? this.folder);
    if (selectedSpace?.folders.contains(selectedFolder) == false) {
      selectedFolder = null;
    }

    TasksList? selectedList = list ?? this.list;
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
    return CreateTaskParams._(
      clickupTaskParamsEnum:
          clickupTaskParamsEnum ?? this.clickupTaskParamsEnum,
      clickupAccessToken: clickupAccessToken ?? this.clickupAccessToken,
      list: selectedList,
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
      space: selectedSpace,
    );
  }

  @override
  List<Object?> get props => [list,
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
    space,
    getAvailableLists,
    archived];

  @override
  String toString() {
    return 'ClickupTaskParams{clickupTaskParamsEnum: $clickupTaskParamsEnum, clickupAccessToken: $clickupAccessToken, clickupList: $list, title: $title, description: $description, assignees: $assignees, addedAssignees: $addedAssignees, removedAssignees: $removedAssignees, tags: $tags, taskStatus: $taskStatus, taskPriority: $taskPriority, dueDate: $dueDate, timeEstimate: $timeEstimate, startDate: $startDate, notifyAll: $notifyAll, parentTask: $parentTask, linkedTask: $linkedTask, requiredCustomFields: $requiredCustomFields, task: $task, archived: $archived, clickupSpace: $space, folder: $folder}';
  }
}
