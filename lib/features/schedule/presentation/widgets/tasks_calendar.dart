import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/widgets/task_calendar_widget.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';

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

        printDebug("onViewChange");
        printDebug("viewChangedDetails.visibleDates.first.isBefore(scheduleBloc.state.tasksDueDateEarliestDate ${viewChangedDetails.visibleDates.first
            .isBefore(scheduleBloc.state.tasksDueDateEarliestDate)}");
        printDebug("viewChangedDetails.visibleDates.last.isAfter(scheduleBloc.state.tasksDueDateLatestDate) ${viewChangedDetails.visibleDates.last
            .isAfter(scheduleBloc.state.tasksDueDateLatestDate)}");
        if (viewChangedDetails.visibleDates.first
                .isBefore(scheduleBloc.state.tasksDueDateEarliestDate) ||
            viewChangedDetails.visibleDates.last
                .isAfter(scheduleBloc.state.tasksDueDateLatestDate)) {

          ///TODO onViewChange
          ///TODO fix adding event multiple times
          if (scheduleBloc.state.isLoading == false) {
            printDebug("HEREEEE");
            // scheduleBloc.add(GetTasksForSingleWorkspaceScheduleEvent(
            //     GetClickUpTasksInWorkspaceParams(
            //         workspaceId: selectedClickupWorkspaceId ??
            //             Globals.clickUpWorkspaces?.first.id ??
            //             "",
            //         filtersParams: GetClickUpTasksInWorkspaceFiltersParams(
            //             clickUpAccessToken: Globals.clickUpAuthAccessToken,
            //             filterByAssignees: [
            //               Globals.clickUpUser?.id.toString() ?? ""
            //             ],
            //             filterByDueDateGreaterThanUnixTimeMilliseconds:
            //                 viewChangedDetails
            //                     .visibleDates.last.millisecondsSinceEpoch,
            //             filterByDueDateLessThanUnixTimeMilliseconds:
            //                 viewChangedDetails
            //                     .visibleDates.first.millisecondsSinceEpoch))));
          }
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
        getEndTime(index).subtract(const Duration(minutes: 30));
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
