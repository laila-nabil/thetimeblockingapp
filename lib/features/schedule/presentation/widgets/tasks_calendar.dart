import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../../../core/extensions.dart';

class TasksCalendar extends StatelessWidget {
  const TasksCalendar({
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
                      ],
                    )
                ],
              ),
            ));
      },
      timeZone: Globals.clickUpUser?.timezone,
      onTap: (calendarTapDetails){
        printDebug("calendarTapDetails ${calendarTapDetails.targetElement}");
        printDebug("calendarTapDetails ${calendarTapDetails.date}");
        printDebug("calendarTapDetails ${calendarTapDetails.appointments}");
        printDebug("calendarTapDetails ${calendarTapDetails.resource}");
        if(calendarTapDetails.appointments == null){
          ///TODO try to add a new task
        }else{
          ///TODO view/edit the task
        }
      },
      onAppointmentResizeEnd: (appointmentResizeEndDetails){
        ///TODO onAppointmentResizeEnd
      },

      timeSlotViewSettings: const TimeSlotViewSettings(
        ///TODO TimeSlotViewSettings
      ),
      onDragEnd: (appointmentDragEndDetails){
        ///TODO onDragEnd
      },
      onDragStart: (appointmentDragEndDetails){
        ///TODO onDragStart
      },
      onDragUpdate: (appointmentDragEndDetails){
        ///TODO onDragUpdate
      },
      onViewChanged: (viewChangedDetails){
        ///TODO onViewChanged
      },
    );
  }
}

class ClickupTasksDataSource extends CalendarDataSource {
  final List<ClickupTask> clickupTasks;

  ClickupTasksDataSource({required this.clickupTasks});

  @override
  DateTime getStartTime(int index) {
    ///TODO ??
    return clickupTasks[index].startDateUtc ??
        getEndTime(index).subtract(Duration(minutes: 30));
  }

  @override
  DateTime getEndTime(int index) {
    return clickupTasks[index].dueDateUtc ?? super.getEndTime(index);
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
