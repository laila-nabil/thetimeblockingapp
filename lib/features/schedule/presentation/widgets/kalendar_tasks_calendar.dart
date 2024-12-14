import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalender/kalender.dart';
import 'package:thetimeblockingapp/common/entities/status.dart';

import 'package:thetimeblockingapp/common/entities/task.dart';
import 'package:thetimeblockingapp/common/enums/backend_mode.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';
import 'package:thetimeblockingapp/core/functions.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:thetimeblockingapp/features/global/presentation/bloc/global_bloc.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/widgets/kcalendar/calendar/calendar_navigation_header.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/widgets/kcalendar/widgets/resize_handler.dart';
import 'package:thetimeblockingapp/features/task_popup/presentation/views/task_popup.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task_parameters.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_task_use_case.dart';

import '../bloc/schedule_bloc.dart';
import 'kcalendar/calendar/calendar_zoom.dart';
import 'kcalendar/widgets/task_widget_in_kalendar.dart';

class KalendarTasksCalendar extends StatelessWidget {
  const KalendarTasksCalendar(
      {required this.eventsController,
      required this.controller,
      required this.scheduleBloc,
      required this.scheduleState,
      this.onTap,
      this.selectedWorkspaceId,
      required this.currentConfigurationIndex});

  final EventsController<Task> eventsController;
  final CalendarController<Task> controller;
  final ScheduleBloc scheduleBloc;
  final ScheduleState scheduleState;
  final void Function(dynamic)? onTap;
  final int? selectedWorkspaceId;
  final int currentConfigurationIndex;

  static List<ViewConfiguration> viewConfigurations(bool isSmallScreen) => [
        MultiDayViewConfiguration.singleDay(
            name: appLocalization.translate("day"),
            // verticalStepDuration: serviceLocator<AppConfig>().defaultTaskDuration,
            // newEventDuration: serviceLocator<AppConfig>().defaultTaskDuration,
            initialHeightPerMinute: 1,),
        MultiDayViewConfiguration.custom(
          name: appLocalization.translate("2Days"),
          numberOfDays: 2,
          // verticalStepDuration:
          // serviceLocator<AppConfig>().defaultTaskDuration,
          // newEventDuration: serviceLocator<AppConfig>().defaultTaskDuration,
          // showWeekNumber: false,
        ),
        MultiDayViewConfiguration.week(
          name: appLocalization.translate("week"),
          firstDayOfWeek: 6,
          // verticalStepDuration:
          // serviceLocator<AppConfig>().defaultTaskDuration,
          // newEventDuration: serviceLocator<AppConfig>().defaultTaskDuration,
          // showWeekNumber: false,
        ),
        if (isSmallScreen == false)
          MultiDayViewConfiguration.custom(
              name: appLocalization.translate("multiWeek"), numberOfDays: 14
              // showWeekNumber: false,
              // verticalStepDuration:
              // serviceLocator<AppConfig>().defaultTaskDuration,
              // newEventDuration: serviceLocator<AppConfig>().defaultTaskDuration,
              ),
        MonthViewConfiguration.singleMonth(
          name: appLocalization.translate("month"),
          // verticalStepDuration: serviceLocator<AppConfig>().defaultTaskDuration,
        ),
        // ScheduleConfiguration(),
      ];

  @override
  Widget build(BuildContext context) {
    /// This function is called when an event is tapped.
    Future<void> onEventTapped(
      CalendarEvent<Task> event,
      RenderBox renderBox,
    ) async {
      if (isMobile) {
        // widget.eventsController.selectedEvent == event
        //     ? widget.eventsController.deselectEvent()
        //     : widget.eventsController.selectEvent(event);
      } else {
        // Make a copy of the event to restore it if the user cancels the changes.
        CalendarEvent<Task> copyOfEvent = event.copyWith();
        // Show the edit dialog.
        var scheduleBloc = BlocProvider.of<ScheduleBloc>(context);
        var authBloc = BlocProvider.of<AuthBloc>(context);
        var globalBloc = BlocProvider.of<GlobalBloc>(context);
        scheduleBloc.add(ShowTaskPopupEvent(
            showTaskPopup: true,
            taskPopupParams: TaskPopupParams.openNotAllDayTask(
              task: event.data,
              onSave: (params) {
                scheduleBloc.add(UpdateTaskEvent(params: params));
              },
              onDelete: (params) =>
                  scheduleBloc.add(DeleteTaskEvent(params: params)),
              bloc: scheduleBloc,
              isLoading: (state) =>
                  state is! ScheduleState ? false : state.isLoading,
              onDuplicate: () {
                var selectedWorkspace = globalBloc.state.selectedWorkspace;
                scheduleBloc.add(DuplicateTaskEvent(
                    params: CreateTaskParams.fromTask(
                      event.data!,
                      serviceLocator<BackendMode>().mode,
                      authBloc.state.user!,
                      selectedWorkspace!.defaultList!,
                    ),
                    workspace: selectedWorkspace.id!));
              },
            )));
      }
    }

    void onDuplicate(params) {
      var scheduleBloc = BlocProvider.of<ScheduleBloc>(context);
      scheduleBloc.add(DuplicateTaskEvent(
        params: params,
        workspace:
            BlocProvider.of<GlobalBloc>(context).state.selectedWorkspace!.id!,
      ));
    }

    void onSave(params) {
      var scheduleBloc = BlocProvider.of<ScheduleBloc>(context);
      scheduleBloc.add(UpdateTaskEvent(
        params: params,
      ));
      Navigator.maybePop(context);
    }

    void onDelete(params) {
      var scheduleBloc = BlocProvider.of<ScheduleBloc>(context);
      scheduleBloc.add(DeleteTaskEvent(
        params: params,
      ));
      Navigator.maybePop(context);
    }

    void onCompleteConfirmed(Task task) {
      var authState = BlocProvider.of<AuthBloc>(context).state;
      var globalState = BlocProvider.of<GlobalBloc>(context).state;
      var scheduleBloc = BlocProvider.of<ScheduleBloc>(context);
      final newTask =
          task.copyWith(status: globalState.statuses!.completedStatus);
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
    }

    void onDeleteConfirmed(Task task) {
      BlocProvider.of<ScheduleBloc>(context, listen: false).add(DeleteTaskEvent(
        params: DeleteTaskParams(
          task: task,
        ),
      ));
    }


    TileComponents<Task> tileComponents({bool body = true}) {
      return TileComponents<Task>(
        tileBuilder: (event, tileRange) {
          return TaskWidgetInKalendar(
            event: event,
            tileType: TileType.normal,
            onDeleteConfirmed: () => onDeleteConfirmed(event.data!),
            onCompleteConfirmed: () => onCompleteConfirmed(event.data!),
            viewConfiguration: viewConfigurations(
                context.showSmallDesign)[currentConfigurationIndex],
            heightPerMinute: controller.viewController is MultiDayViewController
                ? (controller.viewController as MultiDayViewController)
                    .heightPerMinute
                    .value
                : null,
            onDelete: onDelete,
            onSave: onSave,
            onDuplicate: onDuplicate,
          );
        },
        dropTargetTile: (event) => DecoratedBox(
          decoration: BoxDecoration(
            border:
                Border.all(color: event.data!.color.withAlpha(80), width: 2),
            borderRadius: radius,
          ),
        ),
        feedbackTileBuilder: (event, dropTargetWidgetSize) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: dropTargetWidgetSize.width * 0.8,
          height: dropTargetWidgetSize.height,
          decoration: BoxDecoration(
              color: event.data!.color.withAlpha(100), borderRadius: radius),
        ),
        tileWhenDraggingBuilder: (event) => Container(
          decoration: BoxDecoration(
              color: event.data!.color.withAlpha(80), borderRadius: radius),
        ),
        dragAnchorStrategy: pointerDragAnchorStrategy,
        verticalResizeHandle: const VerticalResizeHandle(),
        horizontalResizeHandle: const HorizontalResizeHandle(),
      );
    }

    return Scaffold(
      body: CalendarZoomDetector(
        controller: controller,
        child: CalendarView<Task>(
          eventsController: eventsController,
          calendarController: controller,
          viewConfiguration: viewConfigurations(
              context.showSmallDesign)[currentConfigurationIndex],
          // Handle the callbacks made by the calendar.
          callbacks: CalendarCallbacks<Task>(
            onEventTapped: (event, renderBox) => controller.selectEvent(event),
            onEventCreate: (event) => event,
            onEventCreated: (event) => eventsController.addEvent(event),
          ),
          // Customize the components.
          components: CalendarComponents(
            multiDayComponents: MultiDayComponents(),
            multiDayComponentStyles: MultiDayComponentStyles(),
            monthComponents: MonthComponents(),
            monthComponentStyles: MonthComponentStyles(),
          ),
          header: Column(
            children: [
              CalendarNavigationHeader(
                  calendarController: controller,
                  viewConfigurations: viewConfigurations(context.showSmallDesign),
                  currentConfiguration: currentConfigurationIndex,
                  onViewConfigurationChanged: (value) =>
                      scheduleBloc.add(ChangeCalendarView(viewIndex: value)),
                  visibleDateTimeRange: controller.visibleDateTimeRange.value),
              CalendarHeader(
                multiDayTileComponents: tileComponents(),
                multiDayHeaderConfiguration: MultiDayHeaderConfiguration(),
              ),
              Divider()
            ],
          ),
          body: CalendarBody<Task>(
            multiDayTileComponents: tileComponents(),
            monthTileComponents: tileComponents(body: false),
            multiDayBodyConfiguration:
                MultiDayBodyConfiguration(showMultiDayEvents: false),
            monthBodyConfiguration: MultiDayHeaderConfiguration(),
          ),
        ),
      ),
    );
  }

  BorderRadius get radius => BorderRadius.circular(8);

  ///TODO not correct
  bool get isMobile => getAppPlatformType().isMobile;
}

/*
class KalendarTasksCalendar extends StatelessWidget {
  const KalendarTasksCalendar(
      {required this.eventsController,
      required this.controller,
      required this.scheduleBloc,
      required this.scheduleState,
      this.onTap,
      this.selectedWorkspaceId,
      required this.currentConfigurationIndex});

  final CalendarEventsController<Task> eventsController;
  final CalendarController<Task> controller;
  final ScheduleBloc scheduleBloc;
  final ScheduleState scheduleState;
  final void Function(dynamic)? onTap;
  final int? selectedWorkspaceId;
  final int currentConfigurationIndex;

  static List<ViewConfiguration> viewConfigurations(bool isSmallScreen) => [
        DayConfiguration(
          name: appLocalization.translate("day"),
          verticalStepDuration: serviceLocator<AppConfig>().defaultTaskDuration,
          newEventDuration: serviceLocator<AppConfig>().defaultTaskDuration,
          initialHeightPerMinute: 1
        ),
        CustomMultiDayConfiguration(
            name: appLocalization.translate("2Days"),
            numberOfDays: 2,
            verticalStepDuration:
                serviceLocator<AppConfig>().defaultTaskDuration,
            newEventDuration: serviceLocator<AppConfig>().defaultTaskDuration,
            showWeekNumber: false),
        WeekConfiguration(
            name: appLocalization.translate("week"),
            firstDayOfWeek: 6,
            verticalStepDuration:
                serviceLocator<AppConfig>().defaultTaskDuration,
            newEventDuration: serviceLocator<AppConfig>().defaultTaskDuration,
            showWeekNumber: false),
        if (isSmallScreen == false)
          MultiWeekConfiguration(
            name: appLocalization.translate("multiWeek"),
            showWeekNumber: false,
            verticalStepDuration:
                serviceLocator<AppConfig>().defaultTaskDuration,
            newEventDuration: serviceLocator<AppConfig>().defaultTaskDuration,
          ),
        MonthConfiguration(
          name: appLocalization.translate("month"),
          verticalStepDuration: serviceLocator<AppConfig>().defaultTaskDuration,
        ),
        ScheduleConfiguration(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CalendarWidget(
          eventsController: eventsController,
          calendarController: controller,
          calendarComponents: CalendarComponents(
            calendarHeaderBuilder: (
              DateTimeRange visibleDateTimeRange,
            ) =>
                _calendarHeaderBuilder(visibleDateTimeRange,
                    viewConfigurations(context.showSmallDesign)),
            calendarZoomDetector: _calendarZoomDetectorBuilder,
          ),
          calendarStyle: CalendarStyle(
              calendarHeaderBackgroundStyle: CalendarHeaderBackgroundStyle(
                  headerElevation: 0.5,
                  headerBackgroundColor:
                      appTheme(context.isDarkMode).scaffoldBackgroundColor,
                  headerSurfaceTintColor:
                      appTheme(context.isDarkMode).scaffoldBackgroundColor),
              daySeparatorStyle: DaySeparatorStyle(
                  color: appTheme(context.isDarkMode).dividerTheme.color,
                  thickness: 0.3),
              hourLineStyle: HourLineStyle(
                  color: appTheme(context.isDarkMode).dividerTheme.color,
                  thickness:
                      appTheme(context.isDarkMode).dividerTheme.thickness),
              monthGridStyle: MonthGridStyle(
                  color: appTheme(context.isDarkMode).dividerTheme.color,
                  thickness:
                      appTheme(context.isDarkMode).dividerTheme.thickness),
              monthHeaderStyle: MonthHeaderStyle(
                stringBuilder: (date) {
                  return DateFormat.EEEE(Intl.defaultLocale).format(date);
                },
              ),
              dayHeaderStyle: DayHeaderStyle(
                stringBuilder: (date) {
                  return DateFormat('EEE', Intl.defaultLocale).format(date);
                },
              ),
              scheduleMonthHeaderStyle: ScheduleMonthHeaderStyle(
                stringBuilder: (date) {
                  return DateFormat('yyyy - MMMM', Intl.defaultLocale)
                      .format(date);
                },
              ),
              scheduleDateTileStyle: ScheduleDateTileStyle(
                tilePadding: EdgeInsets.symmetric(vertical: AppSpacing.x2Small4.value)
              )
          ),
          currentConfiguration: viewConfigurations(
              context.showSmallDesign)[currentConfigurationIndex],
          calendarLayoutDelegates: CalendarLayoutDelegates(),
          onDateTapped: () {
            scheduleBloc.add(
                ChangeCalendarView(viewIndex: ScheduleState.defaultViewIndex));
          },
        ),
      ),
    );
  }

  Widget _calendarHeaderBuilder(DateTimeRange visibleDateTimeRange,
      List<ViewConfiguration> viewConfigurations) {
    return CustomCalendarHeader(
      calendarController: controller,
      viewConfigurations: viewConfigurations,
      currentConfiguration: currentConfigurationIndex,
      onViewConfigurationChanged: (viewConfiguration) {
        scheduleBloc.add(ChangeCalendarView(viewIndex: viewConfiguration));
      },
      visibleDateTimeRange: visibleDateTimeRange,
    );
  }

  Widget _calendarZoomDetectorBuilder(
      CalendarController controller, Widget child) {
    return CalendarZoomDetector(
      controller: controller,
      child: child,
    );
  }
}

extension ViewConfigurationExt on ViewConfiguration{
  CalendarViewType? get getCalendarViewType {
    if (this.name == appLocalization.translate("day")) {
      return CalendarViewType.day;
    }
    if (this.name == appLocalization.translate("2Days")) {
      return CalendarViewType.twoDays;
    }
    if (this.name == appLocalization.translate("week")) {
      return CalendarViewType.week;
    }
    if (this.name == appLocalization.translate("multiWeek")) {
      return CalendarViewType.multiWeek;
    }
    if (this.name == appLocalization.translate("month")) {
      return CalendarViewType.month;
    }
    if (this.name == 'Schedule') {
      return CalendarViewType.schedule;
    }

    return null;
  }
}*/
