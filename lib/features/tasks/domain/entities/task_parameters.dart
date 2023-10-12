import 'package:equatable/equatable.dart';
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
  final List<ClickupAssignees>? assignees;
  final List<ClickupAssignees>? addedAssignees;
  final List<ClickupAssignees>? removedAssignees;
  final List<ClickupTag>? tags;
  final ClickupStatus? taskStatus;
  final ClickupTaskPriority? taskPriority;
  final DateTime? dueDate;
  final bool? dueDateTime;
  final Duration? timeEstimate;
  final DateTime? startDate;
  final bool? startDateTime;
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
      this.dueDateTime,
      this.timeEstimate,
      this.startDate,
      this.startDateTime,
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

  static isNewTask (ClickupTask? task) =>task?.id?.isNotEmpty == false;

  factory ClickupTaskParams.unknown({
    required ClickupAccessToken clickupAccessToken,
    required ClickupTaskParamsEnum clickupTaskParamsEnum,
    ClickupList? clickupList,
    String? title,
    String? description,
    List<ClickupAssignees>? assignees,
    List<ClickupTag>? tags,
    ClickupStatus? taskStatus,
    ClickupTaskPriority? taskPriority,
    DateTime? dueDate,
    bool? dueDateTime,
    Duration? timeEstimate,
    DateTime? startDate,
    bool? startDateTime,
    bool? notifyAll,
    ClickupTask? parentTask,
    ClickupTask? linkedTask,
    bool? requiredCustomFields,
  }) =>
      ClickupTaskParams._(
          clickupTaskParamsEnum: clickupTaskParamsEnum,
          clickupAccessToken: clickupAccessToken,
          clickupList: clickupList,
          title: title,
          description: description,
          assignees: assignees,
          addedAssignees: null,
          removedAssignees: null,
          tags: tags,
          taskStatus: taskStatus,
          task: null,
          archived: null,
          dueDate: dueDate,
          dueDateTime: dueDateTime,
          linkedTask: linkedTask,
          parentTask: parentTask,
          notifyAll: notifyAll,
          requiredCustomFields: requiredCustomFields,
          startDate: startDate,
          startDateTime: startDateTime,
          taskPriority: taskPriority,
          timeEstimate: timeEstimate);

  factory ClickupTaskParams.createNewTask({
    required ClickupAccessToken clickupAccessToken,
    required ClickupList clickupList,
    required String title,
    String? description,
    required List<ClickupAssignees> assignees,
    List<ClickupTag>? tags,
    ClickupStatus? taskStatus,
    ClickupTaskPriority? taskPriority,
    DateTime? dueDate,
    bool? dueDateTime,
    Duration? timeEstimate,
    DateTime? startDate,
    bool? startDateTime,
    bool? notifyAll,
    ClickupTask? parentTask,
    ClickupTask? linkedTask,
    bool? requiredCustomFields,
  }) =>
      ClickupTaskParams._(
          clickupTaskParamsEnum: ClickupTaskParamsEnum.create,
          clickupAccessToken: clickupAccessToken,
          clickupList: clickupList,
          title: title,
          description: description,
          assignees: assignees,
          addedAssignees: null,
          removedAssignees: null,
          tags: tags,
          taskStatus: taskStatus,
          task: null,
          archived: null,
          dueDate: dueDate,
          dueDateTime: dueDateTime,
          linkedTask: linkedTask,
          parentTask: parentTask,
          notifyAll: notifyAll,
          requiredCustomFields: requiredCustomFields,
          startDate: startDate,
          startDateTime: startDateTime,
          taskPriority: taskPriority,
          timeEstimate: timeEstimate);

  factory ClickupTaskParams.updateTask({
    required ClickupAccessToken clickupAccessToken,
    required ClickupTask task,
    String? title,
    String? description,
    List<ClickupAssignees>? assignees,
    List<ClickupAssignees>? addedAssignees,
    List<ClickupAssignees>? removedAssignees,
    List<ClickupTag>? tags,
    ClickupStatus? taskStatus,
    ClickupTaskPriority? taskPriority,
    DateTime? dueDate,
    bool? dueDateTime,
    Duration? timeEstimate,
    DateTime? startDate,
    bool? startDateTime,
    ClickupTask? parentTask,
    ClickupTask? linkedTask,
    bool? archived,
  }) =>
      ClickupTaskParams._(
          clickupTaskParamsEnum: ClickupTaskParamsEnum.update,
          clickupAccessToken: clickupAccessToken,
          clickupList: null,
          title: title,
          description: description,
          assignees: assignees,
          addedAssignees: addedAssignees,
          removedAssignees: removedAssignees,
          tags: tags,
          taskStatus: taskStatus,
          task: task,
          archived: archived,
          dueDate: dueDate,
          dueDateTime: dueDateTime,
          linkedTask: linkedTask,
          parentTask: parentTask,
          notifyAll: null,
          requiredCustomFields: null,
          startDate: startDate,
          startDateTime: startDateTime,
          taskPriority: taskPriority,
          timeEstimate: timeEstimate);

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
        "start_date_time": startDateMillisecondsSinceEpoch,
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
    List<ClickupAssignees>? assignees,
    List<ClickupAssignees>? addedAssignees,
    List<ClickupAssignees>? removedAssignees,
    List<ClickupTag>? tags,
    ClickupStatus? taskStatus,
    ClickupTaskPriority? taskPriority,
    DateTime? dueDate,
    bool? dueDateTime,
    Duration? timeEstimate,
    DateTime? startDate,
    bool? startDateTime,
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
      dueDateTime: dueDateTime ?? this.dueDateTime,
      timeEstimate: timeEstimate ?? this.timeEstimate,
      startDate: startDate ?? this.startDate,
      startDateTime: startDateTime ?? this.startDateTime,
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
