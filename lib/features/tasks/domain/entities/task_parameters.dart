import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/priority.dart';
import 'package:thetimeblockingapp/common/entities/status.dart';
import 'package:thetimeblockingapp/common/entities/tag.dart';
import 'package:thetimeblockingapp/common/entities/user.dart';
import 'package:thetimeblockingapp/common/enums/backend_mode.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/common/entities/folder.dart';
import 'package:thetimeblockingapp/common/entities/space.dart';

import '../../../../common/entities/access_token.dart';
import '../../../../common/entities/tasks_list.dart';
import '../../../../common/entities/task.dart';

enum TaskParamsEnum { create, update }

class CreateTaskParams extends Equatable{
  final BackendMode backendMode;
  final TaskParamsEnum type;
  final AccessToken accessToken;
  final TasksList? list;
  final String? title;
  final String? description;
  final List<Tag>? tags;
  final TaskStatus? taskStatus;
  final TaskPriority? taskPriority;
  final DateTime? dueDate;
  final DateTime? startDate;
  final Task? parentTask;
  final Task? linkedTask;
  final Task? task;
  final User user;
  final Space? space;
  final Folder? folder;

  String get getListId => task?.list?.id ?? list?.id ?? "";

  String get taskId => task?.id ?? "";


  List<String>? get tagsNames => tags?.map((e) => e.name ?? "").toList();

  int? get getPriority => int.tryParse(taskPriority?.id??"");

  String? get getStatus => taskStatus?.name;

  int? get getDueDateMillisecondsSinceEpoch => dueDate?.millisecondsSinceEpoch;

  int? get getStartDateMillisecondsSinceEpoch => startDate?.millisecondsSinceEpoch;

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

  factory CreateTaskParams.fromTask(Task task,BackendMode backendMode,AccessToken accessToken, User user,
      ){
    return CreateTaskParams.createNewTask(
      accessToken: accessToken,
      list: task.list!,
      title: task.title ?? "",
      description: task.description,
      dueDate: task.dueDateUtc,
      folder: task.folder,
      space: task.space,
      tags: task.tags,
      taskPriority: task.priority,
      startDate: task.startDateUtc,
      backendMode: backendMode, user: user
    );
  }
  const CreateTaskParams._(
      {this.list,
      this.title,
      this.description,
      this.tags,
      this.taskStatus,
      this.taskPriority,
      this.dueDate,
      this.startDate,
      this.parentTask,
      this.linkedTask,
      required this.accessToken,
      required this.type,
      required this.user,
      this.task,
      this.space,
      this.folder,required this.backendMode, });

  static _isNewTask(Task? task) =>
      task?.id == null || task?.id?.isEmpty == true;

  ///[dueDateTime] is a true/false value that determines whether you
  /// want to include the time of the due date when creating the task.
  /// For example, do you want the task due on the 10th of October 2023
  /// or the 10th of October 2023 at 6:30 pm? We’ll leave this as false for now.
  bool? get dueDateTime =>
      (type == TaskParamsEnum.update)
          ? didDueDateChange
          : dueDate != null;

  ///[startDateTime] is a true/false value that determines whether you
  /// want to include the time of the start date when creating the task.
  /// For example, do you want the task due on the 10th of October 2023
  /// or the 10th of October 2023 at 6:30 pm? We’ll leave this as false for now.
  bool? get startDateTime => (type == TaskParamsEnum.update)
      ? didStartDateChange
      : startDate != null;

  bool get didDueDateChange =>
      task?.dueDateUtc != null &&
      dueDate?.isAtSameMomentAs(task!.dueDateUtc!) == false;

  bool get didStartDateChange =>
      task?.startDateUtc != null &&
      startDate?.isAtSameMomentAs(task!.startDateUtc!) == false;

  static TaskParamsEnum getTaskParamsEnum(Task? task) {
    printDebug("getTaskParamsEnum $task ${_isNewTask(task)
        ? TaskParamsEnum.create
        : TaskParamsEnum.update}");
    return _isNewTask(task)
      ? TaskParamsEnum.create
      : TaskParamsEnum.update;
  }
  factory CreateTaskParams.startCreateNewTask({
    required AccessToken accessToken,
    DateTime? startDate,
    DateTime? dueDate,
    Space? space,
    TasksList? list,
    Tag? tag,
    required BackendMode backendMode,
    required User user,

  }) {
    printDebug("TaskParams startCreateNewTask task");
    return CreateTaskParams._(
          type: TaskParamsEnum.create,
          accessToken: accessToken,
          startDate: startDate,
          dueDate: dueDate,
          space: space,
          list: list,
          tags: tag == null ? null : [tag],
          backendMode: backendMode, user: user
    );
  }

  factory CreateTaskParams.createNewTask({
    required AccessToken accessToken,
    required TasksList list,
    required String title,
    String? description,
    List<Tag>? tags,
    TaskStatus? taskStatus,
    TaskPriority? taskPriority,
    DateTime? dueDate,
    DateTime? startDate,
    Task? parentTask,
    Task? linkedTask,
    Folder? folder,
    Space? space,
    required BackendMode backendMode,
    required User user,
  }) {
    printDebug("TaskParams createNewTask task");
    return CreateTaskParams._(
          type: TaskParamsEnum.create,
          accessToken: accessToken,
          space: space,
          list: list,
          folder: folder,
          title: title,
          description: description,
          tags: tags,
          taskStatus: taskStatus,
          task: null,
          dueDate: dueDate,
          linkedTask: linkedTask,
          parentTask: parentTask,
          startDate: startDate,
          taskPriority: taskPriority,
          backendMode: backendMode, user: user
    );
  }

  factory CreateTaskParams.startUpdateTask({
    required AccessToken accessToken,
    required Task task,
    required BackendMode backendMode,
    required User user,

  }) {
    printDebug("TaskParams startUpdateTask task $task");
    printDebug("startUpdateTask task ${task.space}");
    final space = Globals.selectedSpace;
    final folder =  space?.folders
        ?.where((element) => element.id == task.folder?.id).firstOrNull;
    final list = space?.lists
        ?.where((element) => element.id == task.list?.id)
        .firstOrNull ??  folder?.lists
        ?.where((element) => element.id == task.list?.id)
            .firstOrNull;
    return CreateTaskParams._(
        type: TaskParamsEnum.update,
        accessToken: accessToken,
        task: task,
        description: null,//description controlled by text controller
        title: null,//title controlled by text controller
        space: space,
        folder: folder,
        list: list,
        taskPriority: task.priority,
        tags: task.tags,
        taskStatus: task.status,
        ///TODO get Z parentTask
        parentTask: null,
        dueDate: task.dueDateUtc,
        startDate: task.startDateUtc,
        backendMode: backendMode, user: user
        );
  }

  factory CreateTaskParams.updateTask({
    required AccessToken accessToken,
    required Task task,
    String? updatedTitle,
    String? updatedDescription,
    List<Tag>? updatedTags,
    TaskStatus? updatedTaskStatus,
    TaskPriority? updatedTaskPriority,
    DateTime? updatedDueDate,
    bool? updatedDueDateTime,
    DateTime? updatedStartDate,
    Task? updatedParentTask,
    Task? updatedLinkedTask,
    bool? updatedArchived,
    TasksList? list,
    Folder? folder,
    required BackendMode backendMode,
    required User user,
  }) =>
      CreateTaskParams._(
          type: TaskParamsEnum.update,
          accessToken: accessToken,
          space: null,
          user: user,
          list: list,
          folder: folder,
          title: updatedTitle,
          description: updatedDescription,
          tags: updatedTags,
          taskStatus: updatedTaskStatus,
          task: task,
          dueDate: updatedDueDate,
          linkedTask: updatedLinkedTask,
          parentTask: updatedParentTask,
          startDate: updatedStartDate,
          taskPriority: updatedTaskPriority,
          backendMode: backendMode
      );

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "user_id": user.id??"",
      "list_id": list?.id??""
    };
    if (type == TaskParamsEnum.create) {
      Map<String, Object?>  createMap = {
        "name": title,
        "description": description,
        "tags": tagsNames,
        "status": getStatus,
        "priority": getPriority,
        "due_date": getDueDateMillisecondsSinceEpoch,
        "due_date_time": dueDateTime,
        "start_date": getStartDateMillisecondsSinceEpoch,
        "start_date_time": startDateTime,
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

      Map<String, Object?>  updateMap = {};
      if(title?.isNotEmpty == true) updateMap["name"] = title;
      if(description?.isNotEmpty == true) updateMap["description"] = description?.isEmpty == true ? " " : description;
      if(getPriority != null) updateMap["priority"] = getPriority;
      if(getDueDateMillisecondsSinceEpoch != null) updateMap["due_date"] = getDueDateMillisecondsSinceEpoch;
      if(dueDateTime != null) updateMap["due_date_time"] = dueDateTime;
      if(getStartDateMillisecondsSinceEpoch != null) updateMap["start_date"] = getStartDateMillisecondsSinceEpoch;
      if(startDateTime != null) updateMap["start_date_time"] = startDateTime;
      if(getParentTaskId != null) updateMap["getParentTaskId"] = getParentTaskId;
      if(getStatus != null) updateMap["status"] = getStatus;
      return updateMap;
    }
  }

  CreateTaskParams copyWith({
    TaskParamsEnum? taskParamsEnum,
    AccessToken? accessToken,
    TasksList? list,
    String? title,
    String? description,
    List<Tag>? tags,
    TaskStatus? taskStatus,
    TaskPriority? taskPriority,
    DateTime? dueDate,
    Duration? timeEstimate,
    DateTime? startDate,
    Task? parentTask,
    Task? linkedTask,
    Task? task,
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
    if (selectedSpace?.folders?.contains(selectedFolder) == false) {
      selectedFolder = null;
    }

    TasksList? selectedList = list ?? this.list;
    if ((selectedFolder != null &&
            selectedFolder.lists?.contains(selectedList) == false) ||
        (selectedSpace != null &&
            selectedFolder == null &&
            selectedSpace.lists?.contains(selectedList) == false)) {
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
    return CreateTaskParams._(
      type:
          taskParamsEnum ?? type,
      accessToken: accessToken ?? this.accessToken,
      list: selectedList,
      title: title ?? this.title,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      taskStatus: taskStatus ?? this.taskStatus,
      taskPriority: selectedPriority,
      dueDate: selectedDueDate,
      startDate: selectedStartDate,
      parentTask: parentTask ?? this.parentTask,
      linkedTask: linkedTask ?? this.linkedTask,
      task: task ?? this.task,
      folder: selectedFolder,
      space: selectedSpace,
      backendMode: backendMode, user: user
    );
  }

  @override
  List<Object?> get props => [list,
    title,
    description,
    tags,
    taskStatus,
    taskPriority,
    dueDate,
    dueDateTime,
    startDate,
    startDateTime,
    parentTask,
    linkedTask,
    accessToken,
    type,
    task,
    folder,
    space,
    getAvailableLists,backendMode,user];

  @override
  String toString() {
    return 'CreateTaskParams{backendMode: $backendMode, type: $type, accessToken: $accessToken, list: $list, title: $title, description: $description, tags: $tags, taskStatus: $taskStatus, taskPriority: $taskPriority, dueDate: $dueDate, startDate: $startDate, parentTask: $parentTask, linkedTask: $linkedTask, task: $task, user: $user, space: $space, folder: $folder}';
  }
}
