import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../core/extensions.dart';

class CustomCalendar extends StatelessWidget {
  const CustomCalendar({
    super.key,
    this.onTap,
    required this.tasksDataSource,
  });

  final ClickupTasksDataSource tasksDataSource;
  final void Function(CalendarTapDetails)? onTap;

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      allowedViews: const [
        CalendarView.day,
        CalendarView.week,
        CalendarView.month,
      ],
      allowDragAndDrop: true,
      allowAppointmentResize: true,
      allowViewNavigation: true,
      firstDayOfWeek: 6,
      showTodayButton: true,
      dataSource: tasksDataSource,
      showNavigationArrow: true,
      appointmentBuilder: (context, calendarAppointmentDetails) {
        final task =
            calendarAppointmentDetails.appointments.first as ClickupTask;
        final viewExtraDetails =
            calendarAppointmentDetails.bounds.height > 20 &&
                task.isAllDay == false;
        const divider = SizedBox(height: 7,);
        return Container(
            color: task.status?.color?.isNotEmpty == true
                ? HexColor.fromHex(task.status?.color ?? "")
                : Theme.of(context).highlightColor,
            child: SingleChildScrollView(
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
                  Text("${(task).name}\n${(task).description}"),
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
                                        backgroundImage:
                                            e.profilePicture?.isNotEmpty == true
                                                ? NetworkImage(
                                                    e.profilePicture ?? "")
                                                : null,
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: AutoSizeText(e.username ?? ""),
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
      },

    );
  }
}

class ClickupTasksDataSource extends CalendarDataSource {
  final List<ClickupTask> clickupTasks;

  ClickupTasksDataSource({required this.clickupTasks});

  @override
  DateTime getStartTime(int index) {
    return clickupTasks[index].startDate ?? DateTime.now();
  }

  @override
  DateTime getEndTime(int index) {
    return clickupTasks[index].dueDate!;
  }

  @override
  String? getNotes(int index) {
    return clickupTasks[index].description;
  }

  @override
  Object? getId(int index) {
    return clickupTasks[index].id;
  }

  @override
  String getSubject(int index) {
    return clickupTasks[index].name ?? "";
  }

  @override
  bool isAllDay(int index) {
    return clickupTasks[index].isAllDay;
  }

  @override
  List? get appointments => clickupTasks;
}
