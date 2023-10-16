import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../core/extensions.dart';
import '../../../tasks/domain/entities/clickup_task.dart';

class TaskCalendarWidget extends StatelessWidget {
  const TaskCalendarWidget({Key? key, required this.calendarAppointmentDetails})
      : super(key: key);
  final CalendarAppointmentDetails calendarAppointmentDetails;

  @override
  Widget build(BuildContext context) {
    final task = calendarAppointmentDetails.appointments.first as ClickupTask;
    final viewExtraDetails =
        calendarAppointmentDetails.bounds.height > 20 && task.isAllDay == false;
    const divider = SizedBox(
      height: 7,
    );
    return Container(
        color: task.status?.color?.isNotEmpty == true
            ? HexColor.fromHex(task.status?.color ?? "")
            : Theme.of(context).highlightColor,
        child: task.isAllDay
            ? RichText(
                text: TextSpan(children: [
                if (task.priority != null)
                  TextSpan(
                      text: "${task.priority?.getPriorityExclamation} ",
                      style: TextStyle(
                          textBaseline: TextBaseline.alphabetic,
                          color: task.priority?.getPriorityExclamationColor)),
                TextSpan(
                  text: "${(task).name}\n${(task).description}",
                )
              ]))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (viewExtraDetails)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("${(task).folder?.name}>${(task).list?.name}"),
                          divider,
                        ],
                      ),
                    RichText(
                        text: TextSpan(children: [
                      if (task.priority != null)
                        TextSpan(
                            text: "${task.priority?.getPriorityExclamation} ",
                            style: TextStyle(
                                textBaseline: TextBaseline.alphabetic,
                                color: task
                                    .priority?.getPriorityExclamationColor)),
                      TextSpan(
                        text: "${(task).name}\n${(task).description}",
                      )
                    ])),
                    if (viewExtraDetails)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          divider,
                          Text(task.tags?.map((e) => "#${e.name}").toString() ??
                              ""),
                        ],
                      ),
                    if (viewExtraDetails)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          divider,
                          Wrap(
                            children: task.assignees
                                    ?.map((e) => CircleAvatar(
                                          backgroundColor:
                                              HexColor.fromHex(e.color ?? ""),
                                          backgroundImage:
                                              e.profilePicture?.isNotEmpty ==
                                                      true
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
                        ],
                      )
                  ],
                ),
              ));
  }
}
