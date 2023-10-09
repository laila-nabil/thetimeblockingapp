part of 'task_pop_up_bloc.dart';

class TaskPopUpState extends Equatable {
  final ClickupTaskParams? taskParams;

  const TaskPopUpState({
    this.taskParams,
  });

  bool get readyToSubmit => taskParams?.clickupList != null && changesAvailable;

  bool get changesAvailable {
    if (taskParams?.task == null) {
      return taskParams?.title != null &&
          taskParams?.clickupList != null &&
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
          taskParams?.clickupList != taskParams?.task?.list ||
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

  @override
  List<Object?> get props => [
        taskParams,
      ];
}
