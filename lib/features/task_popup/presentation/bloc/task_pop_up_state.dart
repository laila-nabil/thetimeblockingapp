part of 'task_pop_up_bloc.dart';

class TaskPopUpState extends Equatable {
  final CreateTaskParams? taskParams;

  const TaskPopUpState({
    this.taskParams,
  });

  bool get readyToSubmit {

    if (taskParams?.task == null) {
      return taskParams?.title != null &&
          taskParams?.list != null &&
          (taskParams?.description != null ||
              taskParams?.tags?.isNotEmpty == true ||
              taskParams?.taskPriority != null ||
              taskParams?.taskStatus != null ||
              taskParams?.dueDate != null ||
              taskParams?.startDate != null ||
              taskParams?.parentTask != null ||
              taskParams?.linkedTask != null);
    } else {
      return (taskParams?.title != taskParams?.task?.title ||
          taskParams?.description != taskParams?.task?.description ||
          taskParams?.list != taskParams?.task?.list ||
          taskParams?.tags != taskParams?.task?.tags ||
          taskParams?.taskPriority != taskParams?.task?.priority ||
          taskParams?.taskStatus != taskParams?.task?.status ||
          taskParams?.dueDate != taskParams?.task?.dueDateUtc ||
          taskParams?.startDate != taskParams?.task?.startDateUtc ||
          taskParams?.parentTask != null ||
          taskParams?.linkedTask != null);
    }
  }

  bool get isFoldersListAvailable => taskParams?.workspace?.folders
      ?.isNotEmpty ==
      true || taskParams?.folder !=null;

  bool get viewTagsButton =>
      taskParams?.task != null || taskParams?.workspace != null;

  CreateTaskParams onSaveTaskParams (DateTime? newTaskDueDate,User user){
    CreateTaskParams params;
    final task = taskParams?.task;
    if (task != null) {
      params = CreateTaskParams.updateTask(
        task: taskParams!.task!,
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
        updatedParentTask: taskParams?.parentTask == task.list
            ? null
            : taskParams?.parentTask,
        folder: taskParams?.folder == task.folder
            ? null
            : taskParams?.folder,
        list: taskParams?.list == task.list
            ? null
            : taskParams?.list,
          backendMode: serviceLocator<BackendMode>().mode, user: user
      );
    } else {
      params = taskParams ?? CreateTaskParams.createNewTask(
        dueDate: newTaskDueDate,
        list: taskParams!.list!,
        title: taskParams?.title ?? "",
        description: taskParams?.description,
        backendMode: serviceLocator<BackendMode>().mode, user: user,
        taskStatus: taskParams?.taskStatus,
        folder: taskParams?.folder,
        workspace: taskParams?.workspace,
        startDate: taskParams?.startDate,
        tags: taskParams?.tags,
        taskPriority: taskParams?.taskPriority,
        parentTask: taskParams?.parentTask
      );
    }
    return params;
  }

  @override
  List<Object?> get props => [
        taskParams,
      ];
}
