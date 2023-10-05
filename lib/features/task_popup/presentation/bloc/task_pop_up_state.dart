part of 'task_pop_up_bloc.dart';

class TaskPopUpState extends Equatable {
  final ClickupTask? task;

  const TaskPopUpState({this.task});

  @override
  List<Object?> get props => [task];
}