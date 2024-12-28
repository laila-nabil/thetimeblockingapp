import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:thetimeblockingapp/common/entities/status.dart';
import 'package:thetimeblockingapp/common/enums/backend_mode.dart';
import 'package:thetimeblockingapp/common/models/supabase_task_model.dart';
import 'package:thetimeblockingapp/common/widgetbook.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';
import 'package:thetimeblockingapp/core/functions.dart';

import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';
import 'package:thetimeblockingapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:thetimeblockingapp/features/global/presentation/bloc/global_bloc.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task_parameters.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/widgets/syncfusion/widgets/task_widget_in_sync_fusion_calendar.dart';

import '../../../../../core/extensions.dart';
import '../../../../../core/resources/app_colors.dart';
import '../../../../tasks/domain/use_cases/delete_task_use_case.dart';
import '../../../../tasks/domain/use_cases/get_tasks_in_single_workspace_use_case.dart';
import '../../bloc/schedule_bloc.dart';
import '../../../../task_popup/presentation/views/task_popup.dart';


class SyncfusionTasksCalendar extends StatelessWidget {
  const SyncfusionTasksCalendar({
    super.key,
    this.onTap,
    this.selectedWorkspaceId,
    required this.tasksDataSource,
    required this.controller,
    required this.scheduleBloc,
    required this.scheduleState,
  });

  final SupabaseTasksDataSource tasksDataSource;
  final CalendarController controller;
  final ScheduleBloc scheduleBloc;
  final ScheduleState scheduleState;
  final void Function(CalendarTapDetails)? onTap;
  final int? selectedWorkspaceId;
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final globalBloc = BlocProvider.of<GlobalBloc>(context);
    return SfCalendar(
      ///TODO save selected view in calendar
      // view: CalendarView.day,
      allowedViews: const [
        CalendarView.day,
        CalendarView.schedule,
        CalendarView.week,
        CalendarView.month,
      ],
      showDatePickerButton: true,
      monthViewSettings: MonthViewSettings(
        appointmentDisplayMode: context.showSmallDesign
            ? MonthAppointmentDisplayMode.indicator
            : MonthAppointmentDisplayMode.appointment,
        showAgenda: context.showSmallDesign,
        numberOfWeeksInView: 5,
      ),
      allowDragAndDrop: true,
      allowAppointmentResize: true,
      allowViewNavigation: true,
      firstDayOfWeek: 6,
      showTodayButton: true,
      dataSource: tasksDataSource,
      showNavigationArrow: true,
      controller: controller,
      headerStyle: CalendarHeaderStyle(
        backgroundColor: AppColors.background(context.isDarkMode),
      ),
      todayTextStyle: AppTextStyle.getTextStyle(AppTextStyleParams(
          appFontSize: AppFontSize.paragraphSmall,
          color: AppColors.white(false),
          appFontWeight: AppFontWeight.regular)),
      cellBorderColor: AppColors.grey(context.isDarkMode)
          .withOpacity(context.isDarkMode ? 1 : 0.3),
      ///TODO Calendar widget color in calendar is based on list with checkbox colored based on status as design
      scheduleViewSettings: ScheduleViewSettings(
        appointmentItemHeight: 120
      ),
      appointmentBuilder: (context, calendarAppointmentDetails) {
              List<Task> tasks = [];
              calendarAppointmentDetails.appointments.forEach(
                  (appointment) => tasks.add(appointment as TaskModel));
              var task = tasks.first;
              return TaskWidgetInSyncfusionCalendar(
                bounds: calendarAppointmentDetails.bounds,
                calendarView: controller.view,
                task: task,
                bloc: scheduleBloc,
                onDelete: (params) {
                  scheduleBloc.add(DeleteTaskEvent(
                    params: params,
                  ));
                  Navigator.maybePop(context);
                },
                onSave: (params) {
                  scheduleBloc.add(UpdateTaskEvent(
                    params: params,
                  ));
                  Navigator.maybePop(context);
                },
                isLoading: (state) => false,
                onDuplicate: (params) {
                  scheduleBloc.add(DuplicateTaskEvent(
                    params: params,
                    workspace: BlocProvider.of<GlobalBloc>(context)
                        .state
                        .selectedWorkspace!
                        .id!,
                  ));
                },
                onDeleteConfirmed: () {
                  scheduleBloc.add(DeleteTaskEvent(
                    params: DeleteTaskParams(
                      task: task,
                    ),
                  ));
                },
                onCompleteConfirmed: () {
                  var authState = BlocProvider.of<AuthBloc>(context).state;
                  var globalState = BlocProvider.of<GlobalBloc>(context).state;
                  final newTask = task.copyWith(
                      status: globalState.statuses!.completedStatus);
                  printDebug("newTask $newTask");
                  scheduleBloc.add(UpdateTaskEvent(
                    params: CreateTaskParams.startUpdateTask(
                        defaultList: globalState.selectedWorkspace!.defaultList!,
                        task: newTask,
                        backendMode: serviceLocator<BackendMode>(),
                        user: authState.user!,
                        workspace: newTask.workspace,
                        tags: newTask.tags),
                  ));
                },
              );
            },
      timeZone: serviceLocator<AppConfig>().timezone,
      onTap: (d)=> onTapCalendarElement(d,authBloc,globalBloc),
      onLongPress: (d)=> onTapCalendarElement(d,authBloc,globalBloc),
      onAppointmentResizeEnd: (details){
        printDebug("details.startTime ${details.startTime}");
        printDebug("details.endTime ${details.endTime}");
        scheduleBloc.add(UpdateTaskEvent(
            params: CreateTaskParams.updateTask(
                defaultList: globalBloc.state.selectedWorkspace!.defaultList!,
              task: details.appointment as Task,
              updatedStartDate: details.startTime,
              updatedDueDate: details.endTime,
              backendMode: serviceLocator<BackendMode>().mode, user: authBloc.state.user!
            )));
      },
      timeSlotViewSettings: TimeSlotViewSettings(
        timeInterval: serviceLocator<AppConfig>().defaultTaskDuration,
        timeFormat: 'h:mm a',
        timeTextStyle: AppTextStyle.getTextStyle(AppTextStyleParams(
            appFontSize: AppFontSize.paragraphX2Small,
            color: AppColors.grey(context.isDarkMode),
            appFontWeight: AppFontWeight.thin)),
        // timeRulerSize: 60,//SETTING timeRulerSize causes bug in month view hovering
        minimumAppointmentDuration: Duration(minutes: 15),
      ),
      dragAndDropSettings: const DragAndDropSettings(
        allowNavigation: true
      ),
      onDragEnd: (details){
        final task = details.appointment as Task;
        var updatedDueDate = details.droppingTime!
            .add(task.dueDate!.difference(task.startDate!));
        var updatedStartDate = details.droppingTime;
        // Round off the start and end times to the nearest 15 minutes
        int startMinutes = details.droppingTime!.minute;
        int roundedStartMinutes = (startMinutes / 15).round() * 15;

        // Update the appointment start and end times
        updatedStartDate = DateTime(
            details.droppingTime!.year,
            details.droppingTime!.month,
            details.droppingTime!.day,
            details.droppingTime!.hour,
            roundedStartMinutes);
        updatedDueDate = updatedStartDate.add(task.duration!);
        scheduleBloc.add(UpdateTaskEvent(
            params: CreateTaskParams.updateTask(
                defaultList: globalBloc.state.selectedWorkspace!.defaultList!,
                task: task,
                user: authBloc.state.user!,
                updatedDueDate: updatedDueDate,
                updatedStartDate: updatedStartDate,
                backendMode: serviceLocator<BackendMode>().mode
        )));
      },
      onViewChanged: (viewChangedDetails){

        printDebug("onViewChange");
        if (viewChangedDetails.visibleDates.first
            .isBefore(scheduleState.tasksDueDateEarliestDate) ||
            viewChangedDetails.visibleDates.last
                .isAfter(scheduleState.tasksDueDateLatestDate)) {

          final id = "${viewChangedDetails.visibleDates.tryElementAt(0)?.millisecondsSinceEpoch}${viewChangedDetails.visibleDates.lastOrNull?.millisecondsSinceEpoch}";
          if (scheduleState.isLoading == false &&
              scheduleState.getTasksForSingleWorkspaceScheduleEventId !=
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

  void onTapCalendarElement(calendarTapDetails,AuthBloc authBloc,GlobalBloc globalBloc){
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
                      authBloc.state.user!,
                      globalBloc.state.selectedWorkspace!.defaultList!,
                  ),
                  workspace: selectedWorkspaceId!));
            },)));
      } else if (calendarTapDetails.targetElement ==
              CalendarElement.calendarCell &&
          calendarTapDetails.appointments == null) {
        scheduleBloc.add(ShowTaskPopupEvent(
            showTaskPopup: true,
            taskPopupParams: TaskPopupParams.notAllDayTask(
                start: calendarTapDetails.date,
                onSave: (params) {
                  scheduleBloc.add(CreateTaskEvent(
                      params:
                          params, workspaceId: selectedWorkspaceId!));
                },
                bloc: scheduleBloc,
                isLoading:(state)=>scheduleState.isLoading
            )));
      } else if (calendarTapDetails.targetElement ==
          CalendarElement.allDayPanel &&
          calendarTapDetails.appointments == null) {
        scheduleBloc.add(ShowTaskPopupEvent(
            showTaskPopup: true,
            taskPopupParams: TaskPopupParams.allDayTask(
                start: calendarTapDetails.date,
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
    return task.color;
  }
  @override
  DateTime getEndTime(int index) {
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
    //DON'T use printDebug here -> causes recursion
    return customData as TaskModel;
  }

  @override
  List? get appointments => tasks;
}

class SfLocalizationsArDelegate extends LocalizationsDelegate<SfLocalizations> {
  const SfLocalizationsArDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ar';

  @override
  Future<SfLocalizations> load(Locale locale) {
    return SynchronousFuture<SfLocalizations>(SfLocalizationsAr());
  }

  @override
  bool shouldReload(LocalizationsDelegate<SfLocalizations> old) => true;
}
