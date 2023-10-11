import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_list.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task_parameters.dart';

part 'task_pop_up_event.dart';

part 'task_pop_up_state.dart';

class TaskPopUpBloc extends Bloc<TaskPopUpEvent, TaskPopUpState> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final ClickupTask? task;

  TaskPopUpBloc({required this.task})
      : super(const TaskPopUpState()) {
    printDebug("task from bloc $task");
    titleController.text = task?.name ?? "";
    descriptionController.text = task?.description ?? "";
    on<TaskPopUpEvent>((event, emit) {
      if(event is UpdateClickupTaskParamsEvent){
        emit(TaskPopUpState(taskParams: event.taskParams));
      }
    });
  }
}
