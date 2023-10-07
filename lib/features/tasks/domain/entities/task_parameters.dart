import '../../../auth/domain/entities/clickup_access_token.dart';
import 'clickup_task.dart';

enum ClickUpTaskParamsEnum { create, update }

class ClickUpTaskParams {
  final ClickUpTaskParamsEnum clickUpTaskParamsEnum;
  final ClickUpAccessToken clickUpAccessToken;
  final ClickupList? clickUpList;
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

  String get listId => clickUpList?.id ?? "";

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

  ClickUpTaskParams._(
      {this.clickUpList,
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
      required this.clickUpAccessToken,
      required this.clickUpTaskParamsEnum,
      this.task,
      this.archived});

  factory ClickUpTaskParams.createNewTask({
    required ClickUpAccessToken clickUpAccessToken,
    required ClickupList clickUpList,
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
      ClickUpTaskParams._(
          clickUpTaskParamsEnum: ClickUpTaskParamsEnum.create,
          clickUpAccessToken: clickUpAccessToken,
          clickUpList: clickUpList,
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

  factory ClickUpTaskParams.updateTask({
    required ClickUpAccessToken clickUpAccessToken,
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
      ClickUpTaskParams._(
          clickUpTaskParamsEnum: ClickUpTaskParamsEnum.update,
          clickUpAccessToken: clickUpAccessToken,
          clickUpList: null,
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
    if (clickUpTaskParamsEnum == ClickUpTaskParamsEnum.create) {
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
      ///FIX
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
}
