import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/priority.dart';
import 'package:thetimeblockingapp/common/entities/status.dart';
import 'package:thetimeblockingapp/common/entities/tag.dart';
import 'package:thetimeblockingapp/common/entities/user.dart';
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/common/enums/backend_mode.dart';
import 'package:thetimeblockingapp/core/extensions.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';

import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/common/entities/folder.dart';

import '../../../../common/entities/tasks_list.dart';
import '../../../../common/entities/task.dart';
import 'task_date_time.dart';

enum TaskParamsEnum { create, update }

class CreateTaskParams extends Equatable{
  final BackendMode backendMode;
  final TaskParamsEnum type;
  final TasksList defaultList;
  final TasksList? list;
  final String? title;
  final String? description;
  final List<Tag>? tags;
  final TaskStatus? taskStatus;
  final TaskPriority? taskPriority;
  final TaskDateTime? dueDate;
  final TaskDateTime? startDate;
  final Task? parentTask;
  final Task? linkedTask;
  final Task? task;
  final User user;
  final Workspace? workspace;
  final Folder? folder;

  String get getListId => task?.list?.id ?? list?.id ?? "";

  String get taskId => task?.id ?? "";


  List<String>? get tagsNames => tags?.map((e) => e.name ?? "").toList();

  int? get getPriority => int.tryParse(taskPriority?.id??"");

  String? getStatus(LanguagesEnum languagesEnum) => taskStatus?.name(languagesEnum);

  int? get getDueDateMillisecondsSinceEpoch => dueDate?.dateTime?.millisecondsSinceEpoch;

  int? get getStartDateMillisecondsSinceEpoch => startDate?.dateTime?.millisecondsSinceEpoch;

  String? get getParentTaskId => parentTask?.id;

  String? get getLinkedTaskId => linkedTask?.id;

  List<TasksList> getAvailableLists(Folder? folder) {
    if (workspace != null && folder != null) {
      return List.of(folder.lists ?? <TasksList>[]);
    } else if (workspace != null && folder == null) {
      return List.of(workspace?.lists ?? []);
    }
    return <TasksList>[];
  }

  factory CreateTaskParams.fromTask(Task task,BackendMode backendMode, User user,
      TasksList defaultList
      ){
    return CreateTaskParams.createNewTask(
      list: task.list!,
      title: task.title ?? "",
      description: task.description,
      dueDate: task.dueDate,
      folder: task.folder,
      workspace: task.workspace,
      tags: task.tags,
      taskPriority: task.priority,
      startDate: task.startDate,
      backendMode: backendMode, user: user,
      taskStatus: task.status,
      defaultList: defaultList,
    );
  }
  const CreateTaskParams._(
      {this.list,
      this.title,
      required this.defaultList,
      this.description,
      this.tags,
      this.taskStatus,
      this.taskPriority,
      this.dueDate,
      this.startDate,
      this.parentTask,
      this.linkedTask,
      required this.type,
      required this.user,
      this.task,
      this.workspace,
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
      task?.dueDate != null &&
      dueDate?.dateTime?.isAtSameMomentAs(task!.dueDate!) == false;

  bool get didStartDateChange =>
      task?.startDate != null &&
      startDate?.dateTime?.isAtSameMomentAs(task!.startDate!) == false;

  static TaskParamsEnum getTaskParamsEnum(Task? task) {
    printDebug("getTaskParamsEnum $task ${_isNewTask(task)
        ? TaskParamsEnum.create
        : TaskParamsEnum.update}");
    return _isNewTask(task)
      ? TaskParamsEnum.create
      : TaskParamsEnum.update;
  }
  factory CreateTaskParams.startCreateNewTask({
    TaskDateTime? startDate,
    TaskDateTime? dueDate,
    Workspace? workspace,
    TasksList? list,
    Folder? folder,
    required List<Tag> tags,
    required BackendMode backendMode,
    required User user,
    required TasksList defaultList,

  }) {
    printDebug("TaskParams startCreateNewTask task");
    return CreateTaskParams._(
          type: TaskParamsEnum.create,
          startDate: startDate,
          dueDate: dueDate,
          workspace: workspace,
          list: list,
          defaultList: defaultList,
          folder: folder,
          tags: tags,
          backendMode: backendMode, user: user
    );
  }

  factory CreateTaskParams.createNewTask({
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
    Workspace? workspace,
    required BackendMode backendMode,
    required User user,
    required TasksList defaultList,
  }) {
    printDebug("TaskParams createNewTask task");
    return CreateTaskParams._(
          type: TaskParamsEnum.create,
          workspace: workspace,
          list: list,
        defaultList: defaultList,
          folder: folder,
          title: title,
          description: description,
          tags: tags,
          taskStatus: taskStatus,
          task: null,
          dueDate: TaskDateTime(dateTime: dueDate),
          linkedTask: linkedTask,
          parentTask: parentTask,
          startDate: TaskDateTime(dateTime: startDate),
          taskPriority: taskPriority,
          backendMode: backendMode, user: user
    );
  }

  factory CreateTaskParams.startUpdateTask({
    required Task task,
    required BackendMode backendMode,
    required User user,
    required Workspace? workspace,
    required List<Tag> tags,
    required TasksList defaultList,
  }) {
    printDebug("TaskParams startUpdateTask task $task");
    printDebug("startUpdateTask task ${task.workspace}");
    return CreateTaskParams._(
        type: TaskParamsEnum.update,
        task: task,
        description: null,//description controlled by text controller
        title: null,//title controlled by text controller
        workspace: workspace,
        folder: task.folder,
        list: task.list,
        defaultList: defaultList,
        taskPriority: task.priority,
        tags: tags,
        taskStatus: task.status,
        ///TODO get parentTask
        parentTask: null,
        dueDate: TaskDateTime(dateTime: task.dueDate, cleared: false),
        startDate: TaskDateTime(dateTime: task.startDate),
        backendMode: backendMode, user: user
        );
  }

  factory CreateTaskParams.updateTask({
    required Task task,
    String? updatedTitle,
    String? updatedDescription,
    List<Tag>? updatedTags,
    TaskStatus? updatedTaskStatus,
    TaskPriority? updatedTaskPriority,
    TaskDateTime? updatedDueDate,
    bool? updatedDueDateTime,
    TaskDateTime? updatedStartDate,
    Task? updatedParentTask,
    Task? updatedLinkedTask,
    bool? updatedArchived,
    TasksList? list,
    Folder? folder,
    required BackendMode backendMode,
    required User user,
    required TasksList defaultList,
  }) =>
      CreateTaskParams._(
          type: TaskParamsEnum.update,
          workspace: null,
          user: user,
          list: list,
          defaultList: defaultList,
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
    var map = {
      if(title!=null)"title": title,
      if(description!=null)"description": description,
      if(taskStatus!=null)"status_id": int.tryParse(taskStatus?.id??""),
      if(getPriority!=null)"priority_id" : getPriority,
      if(list!=null)"list_id": list?.id,
      "user_id": user.id,
      if(parentTask!=null)"parent_task_id": parentTask?.id,
      "child_task_id": null,///TODO Child task
    };
    if(dueDate?.cleared == true){
      map.addAll({"due_date": null});
    }else if(dueDate?.dateTime !=null ){
      map.addAll({"due_date": dueDate?.dateTime?.toStringIncludeTimeZone()});
    }
    if(startDate?.cleared == true){
      map.addAll({"start_date": null});
    }else if(startDate?.dateTime !=null ){
      map.addAll({"start_date": startDate?.dateTime?.toStringIncludeTimeZone()});
    }

    return map;
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
    TasksList? list,
    TasksList? defaultList,
    String? title,
    String? description,
    List<Tag>? tags,
    TaskStatus? taskStatus,
    TaskPriority? taskPriority,
    TaskDateTime? dueDate,
    Duration? timeEstimate,
    TaskDateTime? startDate,
    Task? parentTask,
    Task? linkedTask,
    Task? task,
    Workspace? workspace,
    Folder? folder,
    bool? clearFolder,
    bool? clearPriority,
  }) {
    Workspace? selectedWorkspace = workspace ?? this.workspace;
    TaskPriority? selectedPriority =
        clearPriority == true ? null : (taskPriority ?? this.taskPriority);
    Folder? selectedFolder =
        clearFolder == true ? null : (folder ?? this.folder);
    if (selectedWorkspace?.folders?.contains(selectedFolder) == false) {
      selectedFolder = null;
    }

    TasksList? selectedList = list ?? this.list;
    if ((selectedFolder != null &&
            selectedFolder.lists?.contains(selectedList) == false) ||
        (selectedWorkspace != null &&
            selectedFolder == null &&
            selectedWorkspace.lists?.contains(selectedList) == false)) {
      selectedList = null;
    }
    var updatedStartDate = startDate ?? this.startDate;
    var updatedDueDate = dueDate ?? this.dueDate;
    printDebug("CreateTaskParams copyWith startDate?.dateTime ${startDate?.dateTime}");
    printDebug("CreateTaskParams copyWith dueDate?.dateTime ${dueDate?.dateTime}");
    printDebug("CreateTaskParams copyWith updatedStartDate ${updatedStartDate}");
    printDebug("CreateTaskParams copyWith updatedDueDate ${updatedDueDate}");
    if (updatedStartDate?.dateTime != null && updatedDueDate?.dateTime != null ) {
      printDebug("CreateTaskParams copyWith updatedDueDate?.dateTime?.isBefore(updatedDueDate.dateTime!) ${updatedDueDate?.dateTime?.isBefore(updatedStartDate!.dateTime!)}");
      printDebug("CreateTaskParams copyWith updatedDueDate?.dateTime?.toUtc().isBefore(updatedDueDate.dateTime!.toUtc()) ${updatedDueDate?.dateTime?.toUtc().isBefore(updatedStartDate!.dateTime!.toUtc())}");
      if(updatedDueDate?.dateTime?.toUtc().isBefore(updatedStartDate!.dateTime!.toUtc()) == true){
        if (dueDate?.dateTime !=null) {
          updatedStartDate = null;
          printDebug("CreateTaskParams copyWith updatedStartDate cleared ${updatedStartDate}");
        } else if (startDate?.dateTime !=null) {
          updatedDueDate = null;
          printDebug("CreateTaskParams copyWith updatedDueDate cleared ${updatedDueDate}");
        }
      }
    }
    
    return CreateTaskParams._(
      type:
          taskParamsEnum ?? type,
      list: selectedList,
      defaultList: defaultList ?? this.defaultList,
      title: title ?? this.title,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      taskStatus: taskStatus ?? this.taskStatus,
      taskPriority: selectedPriority,
      dueDate: updatedDueDate,
      startDate: updatedStartDate,
      parentTask: parentTask ?? this.parentTask,
      linkedTask: linkedTask ?? this.linkedTask,
      task: task ?? this.task,
      folder: selectedFolder,
      workspace: selectedWorkspace,

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
    type,
    task,
    folder,
    workspace,
    getAvailableLists,backendMode,user];

  @override
  String toString() {
    return 'CreateTaskParams{backendMode: $backendMode, type: $type, list: $list, title: $title, description: $description, tags: $tags, taskStatus: $taskStatus, taskPriority: $taskPriority, dueDate: $dueDate, startDate: $startDate, parentTask: $parentTask, linkedTask: $linkedTask, task: $task, user: $user, space: $workspace, folder: $folder}';
  }
}
