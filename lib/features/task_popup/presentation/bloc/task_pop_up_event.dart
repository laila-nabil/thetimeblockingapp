part of 'task_pop_up_bloc.dart';

abstract class TaskPopUpEvent extends Equatable {
  const TaskPopUpEvent();
}

class UpdateClickupTaskParamsEvent extends TaskPopUpEvent{
  final ClickupTaskParams taskParams;

  const UpdateClickupTaskParamsEvent({required this.taskParams});
  @override
  List<Object?> get props => [taskParams];

}
