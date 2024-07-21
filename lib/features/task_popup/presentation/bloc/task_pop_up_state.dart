part of 'task_pop_up_bloc.dart';

class TaskPopUpState extends Equatable {
  final CreateTaskParams? taskParams;

  const TaskPopUpState({
    this.taskParams,
  });

  bool get readyToSubmit => taskParams?.list != null && changesAvailable;

  bool get changesAvailable {
    if (taskParams?.task == null) {
      return taskParams?.title != null &&
          taskParams?.list != null &&
          (taskParams?.description != null ||
              taskParams?.tags?.isNotEmpty == true ||
              taskParams?.assignees?.isNotEmpty == true ||
              taskParams?.taskPriority != null ||
              taskParams?.taskStatus != null ||
              taskParams?.dueDate != null ||
              taskParams?.startDate != null ||
              taskParams?.timeEstimate != null ||
              taskParams?.notifyAll != null ||
              taskParams?.parentTask != null ||
              taskParams?.linkedTask != null);
    } else {
      return (taskParams?.title != taskParams?.task?.name ||
          taskParams?.description != taskParams?.task?.description ||
          taskParams?.list != taskParams?.task?.list ||
          taskParams?.tags != taskParams?.task?.tags ||
          taskParams?.assignees != taskParams?.task?.assignees ||
          taskParams?.taskPriority != taskParams?.task?.priority ||
          taskParams?.taskStatus != taskParams?.task?.status ||
          taskParams?.dueDate != taskParams?.task?.dueDateUtc ||
          taskParams?.startDate != taskParams?.task?.startDateUtc ||
          taskParams?.timeEstimate != taskParams?.task?.timeEstimate ||
          taskParams?.notifyAll != null ||
          taskParams?.parentTask != null ||
          taskParams?.linkedTask != null);
    }
  }

  bool get isPrioritiesEnabled =>
      taskParams?.space?.isPrioritiesEnabled ?? false;

  bool get isFoldersListAvailable => taskParams?.space?.folders
      .isNotEmpty ==
      true || taskParams?.folder !=null;

  bool get viewTagsButton =>
      taskParams?.task != null || taskParams?.space != null;

  CreateTaskParams onSaveTaskParams (DateTime? newTaskDueDate){
    CreateTaskParams params;
    final task = taskParams?.task;
    if (task != null) {
      params = CreateTaskParams.updateTask(
        task: taskParams!.task!,
        accessToken: Globals.accessToken,
        updatedTitle: taskParams?.title,
        updatedDescription: taskParams?.description,
        updatedTags: taskParams?.tags == task.tags ? null : taskParams?.tags,
        updatedDueDate:
            taskParams?.dueDate == task.dueDateUtc ? null : taskParams?.dueDate,
        updatedStartDate: taskParams?.startDate == task.startDateUtc
            ? null
            : taskParams?.startDate,
        updatedTaskPriority: taskParams?.taskPriority == task.priority
            ? null
            : taskParams?.taskPriority,
        updatedTaskStatus: taskParams?.taskStatus == task.status
            ? null
            : taskParams?.taskStatus,
        updatedTimeEstimate: taskParams?.timeEstimate == task.timeEstimate
            ? null
            : taskParams?.timeEstimate,
        updatedParentTask: taskParams?.parentTask == task.list
            ? null
            : taskParams?.parentTask,
        folder: taskParams?.folder == task.folder
            ? null
            : taskParams?.folder,
        list: taskParams?.list == task.list
            ? null
            : taskParams?.list,
      );
    } else {
      params = taskParams ?? CreateTaskParams.createNewTask(
        dueDate: newTaskDueDate,
        list: taskParams!.list!,
        accessToken:
        Globals.accessToken,
        title: taskParams?.title ?? "",
        description: taskParams?.description,
      );
    }
    return params;
  }

  @override
  List<Object?> get props => [
        taskParams,
      ];
}
