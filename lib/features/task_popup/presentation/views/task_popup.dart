import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/common/widgets/custom_button.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';

import '../../../../core/extensions.dart';

class TaskPopupParams {
  final ClickupTask? task;
  final void Function()? saveAllChanges;

  TaskPopupParams({
    this.task,
    this.saveAllChanges,
  });
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
        actions: [
          ///TODO only show in case of changes
          CustomButton(
              onPressed: ()=>Navigator.maybePop(context),
              child: Text(appLocalization.translate("cancel"))),
          CustomButton(
              onPressed:  ///TODO save changes
                null,
              child: Text(appLocalization.translate("save")))
        ],
        content: Column(
          children: [
            ///Priority & Title
            RichText(
                text: TextSpan(children: [
              if (task?.priority != null)
                TextSpan(
                    text: "${task?.priority?.getPriorityExclamation} ",
                    style: TextStyle(
                        textBaseline: TextBaseline.alphabetic,
                        color: task?.priority?.getPriorityExclamationColor)),
              TextSpan(
                text: task?.name ?? appLocalization.translate("title"),
              )
            ])),

            ///Description
            Text(task?.description ?? appLocalization.translate("description")),

            ///Tags
            Text(task?.tags?.map((e) => "#${e.name}").toString() ?? ""),

            ///List
            Text("list : ${task?.list?.name}"),

            ///Project
            Text("project : ${task?.project?.name}"),

            ///Assignees
            Expanded(
              child: Wrap(
                children: task?.assignees
                        ?.map((e) => CircleAvatar(
                              backgroundColor: HexColor.fromHex(e.color ?? ""),
                              backgroundImage:
                                  e.profilePicture?.isNotEmpty == true
                                      ? NetworkImage(e.profilePicture ?? "")
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
