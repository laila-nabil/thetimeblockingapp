import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/widgets/task_calendar_widget.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';

import '../../../../core/extensions.dart';
import '../../../tasks/domain/use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';
import '../bloc/schedule_bloc.dart';
import '../../../task_popup/presentation/views/task_popup.dart';

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
        CalendarView.schedule,
        CalendarView.week,
        CalendarView.month,
      ],
      ///TODO C enable when enabling the feature
      allowDragAndDrop: false,
      allowAppointmentResize: false,
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
      timeZone: Globals.clickupUser?.timezone,
      onTap: (calendarTapDetails){
        printDebug("calendarTapDetails targetElement ${calendarTapDetails.targetElement}");
        printDebug("calendarTapDetails date ${calendarTapDetails.date}");
        printDebug("calendarTapDetails appointments ${calendarTapDetails.appointments?.length} ${calendarTapDetails.appointments}");
        printDebug("calendarTapDetails resource ${calendarTapDetails.resource}");
        if (calendarTapDetails.targetElement == CalendarElement.appointment) {
          ///TODO A should handle in case of multiple appointments
          scheduleBloc.add(ShowTaskPopupEvent(
              showTaskPopup: true,
              taskPopupParams: TaskPopupParams(
                  task: calendarTapDetails.appointments?.first as ClickupTask,
                  onSave: (params) {
                    scheduleBloc.add(UpdateClickupTaskEvent(params: params));
                  },
                  onDelete: (params) =>
                      scheduleBloc.add(DeleteClickupTaskEvent(params: params)),
                  scheduleBloc: scheduleBloc)));
        } else if (calendarTapDetails.targetElement ==
                CalendarElement.calendarCell &&
            calendarTapDetails.appointments == null) {
          scheduleBloc.add(ShowTaskPopupEvent(
              showTaskPopup: true,
              taskPopupParams: TaskPopupParams(
                  cellDate: calendarTapDetails.date,
                  onSave: (params) {
                    scheduleBloc.add(CreateClickupTaskEvent(
                        params:
                            params));
                  },
                  scheduleBloc: scheduleBloc)));
        }
      },
      onAppointmentResizeEnd: (appointmentResizeEndDetails){
        ///TODO C onAppointmentResizeEnd
      },

      timeSlotViewSettings: const TimeSlotViewSettings(
        ///TODO AB TimeSlotViewSettings
      ),
      onDragEnd: (appointmentDragEndDetails){
        ///TODO C onDragEnd
      },
      onDragStart: (appointmentDragEndDetails){
        ///TODO C onDragStart
      },
      onDragUpdate: (appointmentDragEndDetails){
        ///TODO C onDragUpdate
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

          final id = "${viewChangedDetails.visibleDates.tryElementAt(0)?.millisecondsSinceEpoch}${viewChangedDetails.visibleDates.lastOrNull?.millisecondsSinceEpoch}";
          if (scheduleBloc.state.isLoading == false &&
              scheduleBloc.state.getTasksForSingleWorkspaceScheduleEventId !=
                  id) {
            printDebug("onViewChange HEREEEE");
            scheduleBloc.add(GetTasksForSingleWorkspaceScheduleEvent(
                id: id,
                GetClickupTasksInWorkspaceParams(
                    workspaceId: selectedClickupWorkspaceId ??
                        Globals.clickupWorkspaces?.first.id ??
                        "",
                    filtersParams: scheduleBloc
                        .state.defaultTasksInWorkspaceFiltersParams
                        .copyWith(
                            filterByDueDateGreaterThanUnixTimeMilliseconds:
                                (viewChangedDetails.visibleDates.first
                                        .add(const Duration(days: 1)))
                                    .millisecondsSinceEpoch,
                            filterByDueDateLessThanUnixTimeMilliseconds:
                                viewChangedDetails.visibleDates.last
                                    .add(const Duration(days: 1))
                                    .millisecondsSinceEpoch))));
          } else {
            printDebug("onViewChange Not");
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
    printDebug("${clickupTasks[index].name}=>"
        " clickupTasks[index].startDateUtc ${clickupTasks[index].startDateUtc}");
    ///TODO A ??
    return clickupTasks[index].startDateUtc ??
        getEndTime(index).subtract(const Duration(minutes: 30));
  }

  @override
  DateTime getEndTime(int index) {
    printDebug("${clickupTasks[index].name}=>"
        " clickupTasks[index].dueDateUtc ${clickupTasks[index].dueDateUtc}");
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
