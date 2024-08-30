import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:thetimeblockingapp/common/entities/access_token.dart';
import 'package:thetimeblockingapp/common/enums/backend_mode.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task_parameters.dart';

import '../../../../common/entities/user.dart';
import '../../../../core/globals.dart';
import '../views/task_popup.dart';

part 'task_pop_up_event.dart';

part 'task_pop_up_state.dart';

class TaskPopUpBloc extends Bloc<TaskPopUpEvent, TaskPopUpState> {
  final TextEditingController titleController = TextEditingController();
  final FocusNode titleFocusNode = FocusNode();
  final TextEditingController descriptionController = TextEditingController();
  final FocusNode descriptionFocusNode = FocusNode();

  final TaskPopupParams taskPopupParams;

  TaskPopUpBloc({required this.taskPopupParams})
      : super(const TaskPopUpState()) {
    final task = taskPopupParams.task;
    printDebug("task from bloc $task");
    titleController.text = task?.title ?? "";
    descriptionController.text = task?.description ?? "";
    on<TaskPopUpEvent>((event, emit) {
      if(event is UpdateTaskParamsEvent){
        emit(TaskPopUpState(taskParams: event.taskParams));
        printDebug("state after UpdateTaskParamsEvent $state");
      }
    });
  }
}
