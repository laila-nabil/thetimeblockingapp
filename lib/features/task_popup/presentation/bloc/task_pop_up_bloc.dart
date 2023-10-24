import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task_parameters.dart';

import '../../../../core/globals.dart';
import '../views/task_popup.dart';

part 'task_pop_up_event.dart';

part 'task_pop_up_state.dart';

class TaskPopUpBloc extends Bloc<TaskPopUpEvent, TaskPopUpState> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final TaskPopupParams taskPopupParams;

  TaskPopUpBloc({required this.taskPopupParams})
      : super(const TaskPopUpState()) {
    final task = taskPopupParams.task;
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
