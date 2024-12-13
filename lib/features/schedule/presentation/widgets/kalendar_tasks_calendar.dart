import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

import 'package:thetimeblockingapp/common/entities/task.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';

import '../bloc/schedule_bloc.dart';
import 'kcalendar/calendar/calendar_header.dart';
import 'kcalendar/calendar/calendar_widget.dart';
import 'kcalendar/calendar/calendar_zoom.dart';
import 'kcalendar/event_tiles/task_widget_in_kalendar.dart';

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
}