import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/widgets/task_calendar_widget.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../../../core/extensions.dart';
import '../../../tasks/domain/use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';
import '../bloc/schedule_bloc.dart';

class TasksCalendar extends StatelessWidget {
  const TasksCalendar({
    super.key,
    this.onTap,
    this.selectedClickupWorkspaceId,
    required this.tasksDataSource,
    required this.controller,
    required this.scheduleBloc,
  });

  final ClickupTasksDataSource tasksDataSource;
  final CalendarController controller;
  final ScheduleBloc scheduleBloc;
  final void Function(CalendarTapDetails)? onTap;
  final String? selectedClickupWorkspaceId;
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
      controller: controller,
      appointmentBuilder: (context, calendarAppointmentDetails) {
        return TaskCalendarWidget(
            calendarAppointmentDetails: calendarAppointmentDetails);
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
        ///TODO onViewChange
        final tasksDueDates = scheduleBloc.state.clickUpTasks
                ?.where((element) => element.dueDateUtc != null).toList()
                .map((e) => e.dueDateUtc)
                .toList() ??
            [];
        final tasksStartsDates = scheduleBloc.state.clickUpTasks
                ?.where((element) => element.startDateUtc != null)
                .toList()
                .map((e) => e.startDateUtc)
                .toList() ??
            [];
        bool tasksDueDatesIncludesVisibleDates = true;
        bool tasksStartDatesIncludesVisibleDates = true;
        try {
          printDebug("ListDateTimeExtensions.datesAIncludesB tasksDueDates");
          tasksDueDatesIncludesVisibleDates = ListDateTimeExtensions.datesAIncludesB(
                       tasksDueDates,viewChangedDetails.visibleDates,);
          printDebug(tasksDueDatesIncludesVisibleDates);
        } catch (e) {
          printDebug("ListDateTimeExtensions.datesAIncludesB tasksDueDates $e");
        }

        try {
          printDebug("ListDateTimeExtensions.datesAIncludesB tasksStartsDates");
          tasksStartDatesIncludesVisibleDates = ListDateTimeExtensions.datesAIncludesB(
               tasksStartsDates,viewChangedDetails.visibleDates);
          printDebug(tasksStartDatesIncludesVisibleDates);
        } catch (e) {
          printDebug("ListDateTimeExtensions.datesAIncludesB tasksStartsDates $e");
        }
        if (tasksStartDatesIncludesVisibleDates &&
            tasksDueDatesIncludesVisibleDates) {
          printDebug("get tasks");
          //   scheduleBloc.add(GetTasksForSingleWorkspaceScheduleEvent(
        //       GetClickUpTasksInWorkspaceParams(
        //           workspaceId:
        //           selectedClickupWorkspaceId ??
        //               Globals.clickUpWorkspaces?.first.id ??
        //               "",
        //           filtersParams: GetClickUpTasksInWorkspaceFiltersParams(
        //             clickUpAccessToken:
        //             Globals.clickUpAuthAccessToken,
        //             filterByAssignees: [Globals.clickUpUser?.id.toString()??""],
        //             // filterByDueDateLessThanUnixTimeMilliseconds:
        //           ))));
        }
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
