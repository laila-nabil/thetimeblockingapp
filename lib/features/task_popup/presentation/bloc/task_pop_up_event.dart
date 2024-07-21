part of 'task_pop_up_bloc.dart';

abstract class TaskPopUpEvent extends Equatable {
  const TaskPopUpEvent();
}

class UpdateTaskParamsEvent extends TaskPopUpEvent{
  final CreateTaskParams taskParams;

  const UpdateTaskParamsEvent({required this.taskParams});
  @override
  List<Object?> get props => [taskParams];

}
