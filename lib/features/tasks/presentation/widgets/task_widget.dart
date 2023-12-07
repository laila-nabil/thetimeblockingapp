import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';

import '../../../task_popup/presentation/views/task_popup.dart';
import '../../domain/entities/task_parameters.dart';
import '../../domain/use_cases/delete_clickup_task_use_case.dart';


class TaskWidget extends StatelessWidget {
  const TaskWidget(
      {super.key,
      required this.clickupTask,
      required this.bloc,
      required this.isLoading,
      required this.onDelete,
      required this.onSave});
  final ClickupTask clickupTask;
  final Bloc<dynamic, dynamic> bloc;
  final bool Function(Object?) isLoading;
  final void Function(DeleteClickupTaskParams) onDelete;
  final void Function(ClickupTaskParams) onSave;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(clickupTask.name ?? ""),
      onTap: () {
        showTaskPopup(
            context: context,
            taskPopupParams: TaskPopupParams.open(
                task: clickupTask,
                bloc: bloc,
                onDelete: onDelete,
                onSave: onSave,
                isLoading: (state) => isLoading(state)));
      },
    );
  }
}
