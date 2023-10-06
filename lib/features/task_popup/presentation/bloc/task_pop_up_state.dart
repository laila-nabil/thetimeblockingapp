part of 'task_pop_up_bloc.dart';

class TaskPopUpState extends Equatable {
  final ClickupTask? task;
  final ClickupList? list;
  final List<ClickupTag>? tags;
  final List<ClickupAssignees>? assignees;
  final String? title;
  final String? description;
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

  const TaskPopUpState({
    this.task,
    this.list,
    this.tags,
    this.assignees,
    this.title,
    this.description,
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
  });

  bool get readyToSubmit => list != null && changesAvailable;

  bool get changesAvailable {
    if (task == null) {
      return title != null &&
          list != null &&
          (description != null ||
              tags?.isNotEmpty == true ||
              assignees?.isNotEmpty == true ||
              taskPriority != null ||
              taskStatus != null ||
              dueDate != null ||
              startDate != null ||
              timeEstimate != null ||
              notifyAll != null ||
              parentTask != null ||
              linkedTask != null);
    } else {
      return (title != task?.name ||
          description != task?.description ||
          list != task?.list ||
          tags != task?.tags ||
          assignees != task?.assignees ||
          taskPriority != task?.priority ||
          taskStatus != task?.status ||
          dueDate != task?.dueDateUtc ||
          startDate != task?.startDateUtc ||
          timeEstimate != task?.timeEstimate ||
          notifyAll != null ||
          parentTask != null ||
          linkedTask != null);
    }
  }

  @override
  List<Object?> get props => [
        task,
        list,
        tags,
        assignees,
        title,
        description,
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
      ];

  TaskPopUpState copyWith({
    ClickupTask? task,
    ClickupList? list,
    List<ClickupTag>? tags,
    List<ClickupAssignees>? assignees,
    String? title,
    String? description,
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
  }) {
    return TaskPopUpState(
      task: task ?? this.task,
      list: list ?? this.list,
      tags: tags ?? this.tags,
      assignees: assignees ?? this.assignees,
      title: title ?? this.title,
      description: description ?? this.description,
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
    );
  }
}
