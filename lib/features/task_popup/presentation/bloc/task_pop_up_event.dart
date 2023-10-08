part of 'task_pop_up_bloc.dart';

abstract class TaskPopUpEvent extends Equatable {
  const TaskPopUpEvent();
}

class UpdateClickUpTaskParamsEvent extends TaskPopUpEvent{
  final ClickUpTaskParams taskParams;

  const UpdateClickUpTaskParamsEvent({required this.taskParams});
  @override
  List<Object?> get props => [taskParams];

}
