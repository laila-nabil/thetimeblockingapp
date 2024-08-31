import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../core/extensions.dart';
import '../../../../common/entities/task.dart';

class TaskCalendarWidget extends StatelessWidget {
  const TaskCalendarWidget({super.key, required this.calendarAppointmentDetails});
  final CalendarAppointmentDetails calendarAppointmentDetails;

  @override
  Widget build(BuildContext context) {
    final task = calendarAppointmentDetails.appointments.first as Task;
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
                      text: "${task.priority?.name} ",
                      style: TextStyle(
                          textBaseline: TextBaseline.alphabetic,
                          color: task.priority?.getColor)),
                TextSpan(
                  text: "${(task).title}\n${(task).description}",
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
                            text: "${task.priority?.name} ",
                            style: TextStyle(
                                textBaseline: TextBaseline.alphabetic,
                                color: task
                                    .priority?.getColor)),
                      TextSpan(
                        text: "${(task).title}\n${(task).description}",
                      )
                    ])),
                    if (viewExtraDetails)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          divider,
                          Text(task.tags.map((e) => "#${e.name}").toString()),
                        ],
                      ),
                  ],
                ),
              ));
  }
}
