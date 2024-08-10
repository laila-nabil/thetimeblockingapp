import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:thetimeblockingapp/common/models/supabase_task_model.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task_parameters.dart';

import '../../../../core/extensions.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../tasks/domain/use_cases/get_tasks_in_single_workspace_use_case.dart';
import '../bloc/schedule_bloc.dart';
import '../../../task_popup/presentation/views/task_popup.dart';

class TasksCalendar extends StatelessWidget {
  const TasksCalendar({
    super.key,
    this.onTap,
    this.selectedWorkspaceId,
    required this.tasksDataSource,
    required this.controller,
    required this.scheduleBloc,
  });

  final SupabaseTasksDataSource tasksDataSource;
  final CalendarController controller;
  final ScheduleBloc scheduleBloc;
  final void Function(CalendarTapDetails)? onTap;
  final String? selectedWorkspaceId;
  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      ///TODO save selected view in calendar
      // view: CalendarView.day,
      allowedViews: const [
        CalendarView.day,
        CalendarView.schedule,
        CalendarView.week,
        CalendarView.month,
      ],
      // monthViewSettings: const MonthViewSettings(
      //   showAgenda: true,
      // ),
      allowDragAndDrop: true,
      allowAppointmentResize: true,
      allowViewNavigation: true,
      firstDayOfWeek: 6,
      showTodayButton: true,
      dataSource: tasksDataSource,
      showNavigationArrow: true,
      controller: controller,
      ///TODO calendar widget color in calendar is based on list with checkbox colored based on status as design
      // appointmentBuilder: (context, calendarAppointmentDetails) {
      //   return TaskCalendarWidget(
      //       calendarAppointmentDetails: calendarAppointmentDetails);
      // },
      // timeZone: Globals.user?.timezone,
      onTap: onTapCalendarElement,
      onLongPress: onTapCalendarElement,
      onAppointmentResizeEnd: (details){
        printDebug("details.startTime ${details.startTime}");
        printDebug("details.endTime ${details.endTime}");
        scheduleBloc.add(UpdateTaskEvent(
            params: CreateTaskParams.updateTask(
              task: details.appointment as Task,
              accessToken: Globals.accessToken,
              updatedDueDate: details.endTime,
              backendMode: Globals.backendMode
            )));
      },

      timeSlotViewSettings: const TimeSlotViewSettings(
        ///TODO adjust TimeSlotViewSettings in calendar
      ),
      dragAndDropSettings: const DragAndDropSettings(
        allowNavigation: false
      ),
      onDragEnd: (details){
        final task = details.appointment as Task;
        scheduleBloc.add(UpdateTaskEvent(
            params: CreateTaskParams.updateTask(
              task: task,
              accessToken: Globals.accessToken,
          updatedDueDate: details.droppingTime
              !.add(task.dueDateUtc!.difference(task.startDateUtc!)),
          updatedStartDate: details.droppingTime,
          backendMode: Globals.backendMode
        )));
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
                GetTasksInWorkspaceParams(
                    workspaceId: selectedWorkspaceId ??
                        Globals.workspaces?.first.id ??
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
                                    .millisecondsSinceEpoch),
                    backendMode: Globals.backendMode)));
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
        final task = calendarTapDetails.appointments?.first as Task;
        scheduleBloc.add(ShowTaskPopupEvent(
            showTaskPopup: true,
            taskPopupParams: TaskPopupParams.openNotAllDayTask(
                task: task,
                onSave: (params) {
                  scheduleBloc.add(UpdateTaskEvent(params: params));
                },
                onDelete: (params) =>
                    scheduleBloc.add(DeleteTaskEvent(params: params)),
                bloc: scheduleBloc,
                isLoading: (state)=> state is! ScheduleState
                    ? false
                    : state.isLoading,
                onDuplicate: () {
              scheduleBloc.add(DuplicateTaskEvent(
                  params: CreateTaskParams.fromTask(task,Globals.backendMode)));
            },)));
      } else if (calendarTapDetails.targetElement ==
              CalendarElement.calendarCell &&
          calendarTapDetails.appointments == null) {
        scheduleBloc.add(ShowTaskPopupEvent(
            showTaskPopup: true,
            taskPopupParams: TaskPopupParams.notAllDayTask(
                cellDate: calendarTapDetails.date,
                onSave: (params) {
                  scheduleBloc.add(CreateTaskEvent(
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
                  scheduleBloc.add(CreateTaskEvent(
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

class SupabaseTasksDataSource extends CalendarDataSource {
  final List<Task> tasks;

  SupabaseTasksDataSource({required this.tasks});

  @override
  DateTime getStartTime(int index) {
    printDebug("${tasks[index].title}=>"
        "Tasks[index].startDateUtc ${tasks[index].startDateUtc}");
    return tasks[index].startDateUtc ??
        getEndTime(index).subtract(Globals.defaultTaskDuration);
  }

  @override
  Color getColor(int index) {
    var task = tasks[index];
    if(task.isCompleted){
      return AppColors.grey(false).shade300;
    }
    return task.priority?.getColor ??
        AppColors.paletteBlue;
  }
  @override
  DateTime getEndTime(int index) {
    printDebug("${tasks[index].title}=>"
        " Tasks[index].dueDateUtc ${tasks[index].dueDateUtc}");
    return tasks[index].dueDateUtc ?? super.getEndTime(index);
  }

  @override
  String? getNotes(int index) {
    return tasks[index].description;
  }

  @override
  Object? getId(int index) {
    return tasks[index].id;
  }

  @override
  String getSubject(int index) {
    return tasks[index].title ?? "";
  }

  @override
  bool isAllDay(int index) {
    return tasks[index].isAllDay;
  }

  @override
  Object? convertAppointmentToObject(
      Object? customData, Appointment appointment) {
    printDebug("customData $customData");
    printDebug("appointment $appointment");
    return customData as TaskModel;
  }

  @override
  List? get appointments => tasks;
}
