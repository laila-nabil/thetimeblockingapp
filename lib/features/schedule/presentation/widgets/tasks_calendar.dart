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
        CalendarView.week,
        CalendarView.month,
      ],
      ///TODO enable when enabling the feautre
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
      timeZone: Globals.clickUpUser?.timezone,
      onTap: (calendarTapDetails){
        printDebug("calendarTapDetails ${calendarTapDetails.targetElement}");
        printDebug("calendarTapDetails ${calendarTapDetails.date}");
        printDebug("calendarTapDetails ${calendarTapDetails.appointments}");
        printDebug("calendarTapDetails ${calendarTapDetails.resource}");
        if (calendarTapDetails.appointments == null) {
          showTaskPopup(
              context: context,
              taskPopupParams: TaskPopupParams(
                  onSave: (params) {
                    params.fold(
                            (l) => null,
                            (r) => scheduleBloc
                            .add(CreateClickUpTaskEvent(params: r)));
                  }));
        } else {
          showTaskPopup(
              context: context,
              taskPopupParams: TaskPopupParams(
                  task: calendarTapDetails.appointments?.first as ClickupTask,
                  onSave: (params) {
                    params.fold(
                            (l) => scheduleBloc
                            .add(UpdateClickUpTaskEvent(params: l)),
                            (r) => {});
                  },
                  onDelete: (params) => scheduleBloc
                      .add(DeleteClickUpTaskEvent(params: params))));
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

          final id = "${viewChangedDetails.visibleDates.tryElementAt(0)?.millisecondsSinceEpoch}${viewChangedDetails.visibleDates.lastOrNull?.millisecondsSinceEpoch}";
          if (scheduleBloc.state.isLoading == false &&
              scheduleBloc.state.getTasksForSingleWorkspaceScheduleEventId !=
                  id) {
            printDebug("onViewChange HEREEEE");
            scheduleBloc.add(GetTasksForSingleWorkspaceScheduleEvent(
                id: id,
                GetClickUpTasksInWorkspaceParams(
                    workspaceId: selectedClickupWorkspaceId ??
                        Globals.clickUpWorkspaces?.first.id ??
                        "",
                    filtersParams: GetClickUpTasksInWorkspaceFiltersParams(
                        clickUpAccessToken: Globals.clickUpAuthAccessToken,
                        filterByAssignees: [
                          Globals.clickUpUser?.id.toString() ?? ""
                        ],
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
