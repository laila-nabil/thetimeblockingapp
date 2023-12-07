import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';

import '../../../../core/localization/localization.dart';
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
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            IconButton(onPressed: () {
              showTaskPopup(
                  context: context,
                  taskPopupParams: TaskPopupParams.open(
                      task: clickupTask,
                      bloc: bloc,
                      onDelete: onDelete,
                      onSave: onSave,
                      isLoading: (state) => isLoading(state)));
            }, icon: const Icon(Icons.more_horiz))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(clickupTask.status?.status ?? "",
                  style: TextStyle(
                      textBaseline:
                      TextBaseline.alphabetic,
                      color: clickupTask.status?.getColor)),
            ),
            if (Globals.selectedSpace?.isPrioritiesEnabled == true)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text((clickupTask.priority?.isNum == true
                    ? clickupTask.priority?.priorityNum.toString()
                    : clickupTask.priority?.priority.toString()) ?? ""),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(clickupTask.name ?? ""),
            ),
          ],
        ),
        Text(clickupTask.description ?? ""),
        Text("${clickupTask.folder?.name ?? ""}/${clickupTask.list?.name ?? ""}"),
        Text("${clickupTask.startDateUtc.toString()} to ${clickupTask.dueDateUtc.toString()}"),
        Text(
            "${clickupTask.tags?.map((e) => e.name) ?? appLocalization.translate("tags")}"),
      ],
    );
  }
}
