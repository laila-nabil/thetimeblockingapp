import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';

part 'task_pop_up_event.dart';
part 'task_pop_up_state.dart';

class TaskPopUpBloc extends Bloc<TaskPopUpEvent, TaskPopUpState> {
  TaskPopUpBloc() : super(const TaskPopUpState()) {
    on<TaskPopUpEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
