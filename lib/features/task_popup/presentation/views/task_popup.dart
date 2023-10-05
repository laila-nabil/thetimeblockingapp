import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';

import '../../../../core/extensions.dart';

class TaskPopupParams {
  final ClickupTask task;

  TaskPopupParams(this.task);
}

Future showTaskPopup(
    {required BuildContext context, required TaskPopupParams taskPopupParams}) {
  return showDialog(
      context: context,
      builder: (ctx) {
        return TaskPopup(
          taskPopupParams: taskPopupParams,
        );
      });
}

class TaskPopup extends StatelessWidget {
  const TaskPopup({super.key, required this.taskPopupParams});

  final TaskPopupParams taskPopupParams;

  @override
  Widget build(BuildContext context) {
    const radius = 20.0;
    final borderRadius = BorderRadius.circular(radius);
    final task = taskPopupParams.task;
    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        contentPadding: const EdgeInsets.all(radius),
        content: Column(
          children: [
            RichText(
                text: TextSpan(children: [
                  if (task.priority != null)
                    TextSpan(
                        text: "${task.priority?.getPriorityExclamation} ",
                        style: TextStyle(
                            textBaseline: TextBaseline.alphabetic,
                            color:
                            task.priority?.getPriorityExclamationColor)),
                  TextSpan(
                    text: "${task.name}",
                  )
                ])),
            Text(task.description ?? "description"),
            Text(task.tags?.map((e) => "#${e.name}").toString() ??
                ""),
            Text("list : ${task.list?.name}"),
            Text("project : ${task.project?.name}"),
            Expanded(
              child: Wrap(
                children: task.assignees
                    ?.map((e) => CircleAvatar(
                  backgroundColor:
                  HexColor.fromHex(e.color ?? ""),
                  backgroundImage:
                  e.profilePicture?.isNotEmpty == true
                      ? NetworkImage(
                      e.profilePicture ?? "")
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: AutoSizeText(e.initials ??
                        e.getInitialsFromUserName ??
                        ""),
                  ),
                ))
                    .toList() ??
                    [],
              ),
            ),
          ],
        ));
  }
}
