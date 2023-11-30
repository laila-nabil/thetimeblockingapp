import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
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
      ///TODO keep view in schedule to keep selected view
      // view: CalendarView.day,
      allowedViews: const [
        CalendarView.day,
        CalendarView.schedule,
        CalendarView.week,
        CalendarView.month,
      ],
      ///FIXME enabling agenda disables navigating to day from month view
      // monthViewSettings: const MonthViewSettings(
      //   showAgenda: true,
      // ),
      ///TODO V2 enable allowDragAndDrop
      allowDragAndDrop: false,
      allowAppointmentResize: false,
      allowViewNavigation: true,
      firstDayOfWeek: 6,
      showTodayButton: true,
      dataSource: tasksDataSource,
      showNavigationArrow: true,
      controller: controller,
      ///TODO V1 appointmentBuilder TaskCalendarWidget that takes UI colors from list & status
      // appointmentBuilder: (context, calendarAppointmentDetails) {
      //   return TaskCalendarWidget(
      //       calendarAppointmentDetails: calendarAppointmentDetails);
      // },
      timeZone: Globals.clickupUser?.timezone,
      onTap: onTapCalendarElement,
      onLongPress: onTapCalendarElement,
      onAppointmentResizeEnd: (appointmentResizeEndDetails){
        ///TODO V2 onAppointmentResizeEnd
      },

      timeSlotViewSettings: const TimeSlotViewSettings(
        ///TODO V2 TimeSlotViewSettings
      ),
      onDragEnd: (appointmentDragEndDetails){
        ///TODO V2 onDragEnd
      },
      onDragStart: (appointmentDragEndDetails){
        ///TODO V2 onDragStart
      },
      onDragUpdate: (appointmentDragEndDetails){
        ///TODO V2 onDragUpdate
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

  void onTapCalendarElement(calendarTapDetails){
      printDebug("calendarTapDetails targetElement ${calendarTapDetails.targetElement}");
      printDebug("calendarTapDetails date ${calendarTapDetails.date}");
      printDebug("calendarTapDetails appointments ${calendarTapDetails.appointments?.length} ${calendarTapDetails.appointments}");
      printDebug("calendarTapDetails resource ${calendarTapDetails.resource}");
      if (calendarTapDetails.targetElement == CalendarElement.appointment) {
        scheduleBloc.add(ShowTaskPopupEvent(
            showTaskPopup: true,
            taskPopupParams: TaskPopupParams.notAllDayTask(
                task: calendarTapDetails.appointments?.first as ClickupTask,
                onSave: (params) {
                  scheduleBloc.add(UpdateClickupTaskEvent(params: params));
                },
                onDelete: (params) =>
                    scheduleBloc.add(DeleteClickupTaskEvent(params: params)),
                bloc: scheduleBloc,
                isLoading: (state)=> state is! ScheduleState
                    ? false
                    : state.isLoading,)));
      } else if (calendarTapDetails.targetElement ==
              CalendarElement.calendarCell &&
          calendarTapDetails.appointments == null) {
        scheduleBloc.add(ShowTaskPopupEvent(
            showTaskPopup: true,
            taskPopupParams: TaskPopupParams.notAllDayTask(
                cellDate: calendarTapDetails.date,
                onSave: (params) {
                  scheduleBloc.add(CreateClickupTaskEvent(
                      params:
                          params));
                },
                bloc: scheduleBloc,
                isLoading:(state)=>scheduleBloc.state.isLoading
            )));
      } else if (calendarTapDetails.targetElement ==
          CalendarElement.allDayPanel &&
          calendarTapDetails.appointments == null) {
        scheduleBloc.add(ShowTaskPopupEvent(
            showTaskPopup: true,
            taskPopupParams: TaskPopupParams.allDayTask(
                cellDate: calendarTapDetails.date,
                onSave: (params) {
                  scheduleBloc.add(CreateClickupTaskEvent(
                      params:
                      params));
                },
                bloc: scheduleBloc,
                isLoading: (state)=>state is! ScheduleState
                    ? false
                    : state.isLoading)));
      }
    }
}

class ClickupTasksDataSource extends CalendarDataSource {
  final List<ClickupTask> clickupTasks;

  ClickupTasksDataSource({required this.clickupTasks});

  @override
  DateTime getStartTime(int index) {
    printDebug("${clickupTasks[index].name}=>"
        " clickupTasks[index].startDateUtc ${clickupTasks[index].startDateUtc}");
    return clickupTasks[index].startDateUtc ??
        getEndTime(index).subtract(Globals.defaultTaskDuration);
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
