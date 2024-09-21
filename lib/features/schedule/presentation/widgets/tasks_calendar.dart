import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:thetimeblockingapp/common/enums/backend_mode.dart';
import 'package:thetimeblockingapp/common/models/supabase_task_model.dart';

import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';
import 'package:thetimeblockingapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:thetimeblockingapp/features/global/presentation/bloc/global_bloc.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task_parameters.dart';

import '../../../../core/extensions.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../tasks/domain/use_cases/get_tasks_in_single_workspace_use_case.dart';
import '../bloc/schedule_bloc.dart';
import '../../../task_popup/presentation/views/task_popup.dart';

//TODO B FIXME fix UI after Flutter update

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
  final int? selectedWorkspaceId;
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
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

      ///TODO Calendar widget color in calendar is based on list with checkbox colored based on status as design
      // appointmentBuilder: (context, calendarAppointmentDetails) {
      //   return TaskCalendarWidget(
      //       calendarAppointmentDetails: calendarAppointmentDetails);
      // },
      timeZone: serviceLocator<AppConfig>().timezone,
      onTap: (d)=> onTapCalendarElement(d,authBloc),
      onLongPress: (d)=> onTapCalendarElement(d,authBloc),
      onAppointmentResizeEnd: (details){
        printDebug("details.startTime ${details.startTime}");
        printDebug("details.endTime ${details.endTime}");
        scheduleBloc.add(UpdateTaskEvent(
            params: CreateTaskParams.updateTask(
              task: details.appointment as Task,

              updatedDueDate: details.endTime,
              backendMode: serviceLocator<BackendMode>().mode, user: authBloc.state.user!
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
              task: task, user: authBloc.state.user!,

          updatedDueDate: details.droppingTime
              !.add(task.dueDate!.difference(task.startDate!)),
          updatedStartDate: details.droppingTime,
          backendMode: serviceLocator<BackendMode>().mode
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
                        BlocProvider.of<GlobalBloc>(context).state.workspaces?.first.id ??
                        0,
                    filtersParams: scheduleBloc
                        .state.defaultTasksInWorkspaceFiltersParams(

                        user: authBloc.state.user)
                        .copyWith(
                            filterByDueDateGreaterThanUnixTimeMilliseconds:
                                (viewChangedDetails.visibleDates.first
                                        .add(const Duration(days: 1)))
                                    .millisecondsSinceEpoch,
                            filterByDueDateLessThanUnixTimeMilliseconds:
                                viewChangedDetails.visibleDates.last
                                    .add(const Duration(days: 1))
                                    .millisecondsSinceEpoch),
                    backendMode: serviceLocator<BackendMode>().mode)));
          } else {
            printDebug("onViewChange Not");
          }
        }
      },
    );
  }

  void onTapCalendarElement(calendarTapDetails,AuthBloc authBloc){
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
                  params: CreateTaskParams.fromTask(
                      task,
                      serviceLocator<BackendMode>().mode,
                      authBloc.state.user!),
                  workspace: selectedWorkspaceId!));
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
                          params, workspaceId: selectedWorkspaceId!));
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
                      params, workspaceId: selectedWorkspaceId!));
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
    return tasks[index].startDate ??
        getEndTime(index).subtract(
           serviceLocator<AppConfig>().defaultTaskDuration);
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
        " Tasks[index].dueDate ${tasks[index].dueDate}");
    return tasks[index].dueDate ?? super.getEndTime(index);
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
