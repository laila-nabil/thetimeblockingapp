import 'dart:io';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalender/kalender.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';

import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';
import 'package:thetimeblockingapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:thetimeblockingapp/features/global/presentation/bloc/global_bloc.dart';

import '../../../bloc/schedule_bloc.dart';
import 'calendar/calendar_header.dart';
import 'calendar/calendar_widget.dart';
import 'calendar/calendar_zoom.dart';
import 'customize/calendar_customize.dart';
import 'customize/view_customize.dart';

/*
class KalendarTasksCalendar extends StatefulWidget {
  const KalendarTasksCalendar({
    super.key,
    this.onTap,
    this.selectedWorkspaceId,
    required this.tasks,
    required this.controller,
    required this.scheduleBloc,
    required this.scheduleState,
  });

  final List<Task> tasks;
  final CalendarController<Task> controller;
  final ScheduleBloc scheduleBloc;
  final ScheduleState scheduleState;
  final void Function(dynamic)? onTap;
  final int? selectedWorkspaceId;

  @override
  State<KalendarTasksCalendar> createState() => _KalendarTasksCalendarState();
}

class _KalendarTasksCalendarState extends State<KalendarTasksCalendar> {
  final CalendarEventsController<Task> eventsController =
      CalendarEventsController<Task>();
  List<ViewConfiguration> viewConfigurations = [
    CustomMultiDayConfiguration(
      name: 'Day',
      numberOfDays: 1,
    ),
    CustomMultiDayConfiguration(
      name: 'Custom',
      numberOfDays: 1,
    ),
    WeekConfiguration(),
    WorkWeekConfiguration(),
    MonthConfiguration(),
    ScheduleConfiguration(),
    MultiWeekConfiguration(
      numberOfWeeks: 3,
    ),
  ];

  late ViewConfiguration currentConfiguration;
  late CalendarComponents calendarComponents;
  late CalendarStyle calendarStyle;
  late CalendarLayoutDelegates<Task> calendarLayoutDelegates;

  @override
  void initState() {
    currentConfiguration = viewConfigurations[0];
    List<CalendarEvent<Task>> events = widget.tasks
        .map((task) => CalendarEvent(
            dateTimeRange:
                DateTimeRange(start: task.startDate!, end: task.dueDate!),
            eventData: task,
            modifiable: true))
        .toList();
    eventsController.addEvents(events);
    calendarComponents = CalendarComponents(
      calendarHeaderBuilder: _calendarHeaderBuilder,
      calendarZoomDetector: _calendarZoomDetectorBuilder,
    );
    calendarStyle = CalendarStyle(monthHeaderStyle: MonthHeaderStyle(
      stringBuilder: (date) {
        return DateFormat.EEEE(Intl.defaultLocale).format(date);
      },
    ), dayHeaderStyle: DayHeaderStyle(
      stringBuilder: (date) {
        return DateFormat('EEE', Intl.defaultLocale).format(date);
      },
    ), scheduleMonthHeaderStyle: ScheduleMonthHeaderStyle(
      stringBuilder: (date) {
        return DateFormat('yyyy - MMMM', Intl.defaultLocale).format(date);
      },
    ));
    calendarLayoutDelegates = CalendarLayoutDelegates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final globalBloc = BlocProvider.of<GlobalBloc>(context);



    Widget _calendarHeader(DateTimeRange dateTimeRange) {
      return Row(
        children: [
          DropdownMenu(
            onSelected: (value) {
              if (value == null) return;
              setState(() {
                currentConfiguration = value;
              });
            },
            initialSelection: currentConfiguration,
            dropdownMenuEntries: viewConfigurations
                .map((e) => DropdownMenuEntry(value: e, label: e.name))
                .toList(),
          ),
          IconButton.filledTonal(
            onPressed: widget.controller.animateToPreviousPage,
            icon: const Icon(Icons.navigate_before_rounded),
          ),
          IconButton.filledTonal(
            onPressed: widget.controller.animateToNextPage,
            icon: const Icon(Icons.navigate_next_rounded),
          ),
          IconButton.filledTonal(
            onPressed: () {
              widget.controller.animateToDate(DateTime.now());
            },
            icon: const Icon(Icons.today),
          ),
        ],
      );
    }

    return CalendarView<Task>(
      controller: widget.controller,
      eventsController: eventsController,
      viewConfiguration: currentConfiguration,
      tileBuilder: _tileBuilder,
      multiDayTileBuilder: _multiDayTileBuilder,
      scheduleTileBuilder: _scheduleTileBuilder,
      components: CalendarComponents(
        // calendarHeaderBuilder: _calendarHeader,

      ),
      eventHandlers: CalendarEventHandlers(
        onEventTapped: _onEventTapped,
        onEventChanged: _onEventChanged,
        onCreateEvent: (dateTimeRange) => _onCreateEvent(
            dateTimeRange: dateTimeRange, globalBloc: globalBloc),
        onEventCreated: _onEventCreated,
      ),
    );
  }
  Widget _calendarHeaderBuilder(DateTimeRange visibleDateTimeRange) {
    return CalendarHeader(
      calendarController: widget.controller,
      viewConfigurations: viewConfigurations,
      currentConfiguration: viewConfigurations.indexOf(currentConfiguration),
      onViewConfigurationChanged: (viewConfiguration) {
        setState(() {
          currentConfiguration = viewConfigurations.where((v)=>v == viewConfiguration).first;
        });
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
  void onTapCalendarElement(
      calendarTapDetails, AuthBloc authBloc, GlobalBloc globalBloc) {
    printDebug(
        "calendarTapDetails targetElement ${calendarTapDetails.targetElement}");
    printDebug("calendarTapDetails date ${calendarTapDetails.date}");
    printDebug(
        "calendarTapDetails appointments ${calendarTapDetails.appointments?.length} ${calendarTapDetails.appointments}");
    printDebug("calendarTapDetails resource ${calendarTapDetails.resource}");
  }

  CalendarEvent<Task> _onCreateEvent(
      {required DateTimeRange dateTimeRange, required GlobalBloc globalBloc}) {
    ///TODO create task
    return CalendarEvent(
        dateTimeRange: dateTimeRange,
        eventData: Task(
            id: "id${dateTimeRange.toString().substring(0, 5)}",
            title: "New task",
            description: "",
            status: globalBloc.state.statuses?.first,
            priority: null,
            tags: [],
            startDate: dateTimeRange.start,
            dueDate: dateTimeRange.end,
            list: globalBloc.state.selectedWorkspace?.defaultList,
            folder: null,
            workspace: globalBloc.state.selectedWorkspace));
  }

  Future<void> _onEventCreated(CalendarEvent<Task> event) async {
    // Add the event to the events controller.
    eventsController.addEvent(event);

    // Deselect the event.
    eventsController.deselectEvent();
  }

  Future<void> _onEventTapped(
    CalendarEvent<Task> event,
  ) async {
    if (isMobile) {
      eventsController.selectedEvent == event
          ? eventsController.deselectEvent()
          : eventsController.selectEvent(event);
    }
  }

  Future<void> _onEventChanged(
    DateTimeRange initialDateTimeRange,
    CalendarEvent<Task> event,
  ) async {
    if (isMobile) {
      eventsController.deselectEvent();
    }
  }

  Widget _tileBuilder(
    CalendarEvent<Task> event,
    TileConfiguration configuration,
  ) {
    final color = event.eventData?.widgetColor ?? Colors.blue;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.zero,
      elevation: configuration.tileType == TileType.ghost ? 0 : 8,
      color: configuration.tileType != TileType.ghost
          ? color
          : color.withAlpha(100),
      child: Center(
        child: configuration.tileType != TileType.ghost
            ? Text(event.eventData?.title ?? 'New Event')
            : null,
      ),
    );
  }

  Widget _multiDayTileBuilder(
    CalendarEvent<Task> event,
    MultiDayTileConfiguration configuration,
  ) {
    final color = event.eventData?.widgetColor ?? Colors.blue;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2),
      elevation: configuration.tileType == TileType.selected ? 8 : 0,
      color: configuration.tileType == TileType.ghost
          ? color.withAlpha(100)
          : color,
      child: Center(
        child: configuration.tileType != TileType.ghost
            ? Text(event.eventData?.title ?? 'New Event')
            : null,
      ),
    );
  }

  Widget _scheduleTileBuilder(CalendarEvent<Task> event, DateTime date) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: event.eventData?.widgetColor ?? Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(event.eventData?.title ?? 'New Event'),
    );
  }

  bool get isMobile {
    return kIsWeb ? false : Platform.isAndroid || Platform.isIOS;
  }
}
*/

class KalendarTasksCalendar extends StatelessWidget {
  const KalendarTasksCalendar(
      {required this.eventsController,
      required this.controller,
      required this.scheduleBloc,
      required this.scheduleState,
      this.onTap,
      this.selectedWorkspaceId,
      required this.viewConfigurations,
      required this.currentConfigurationIndex});

  final CalendarEventsController<Task> eventsController;
  final CalendarController<Task> controller;
  final ScheduleBloc scheduleBloc;
  final ScheduleState scheduleState;
  final void Function(dynamic)? onTap;
  final int? selectedWorkspaceId;
  final List<ViewConfiguration> viewConfigurations;
  final int currentConfigurationIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CalendarWidget(
          eventsController: eventsController,
          calendarController: controller,
          calendarComponents: CalendarComponents(
            calendarHeaderBuilder: _calendarHeaderBuilder,
            calendarZoomDetector: _calendarZoomDetectorBuilder,
          ),
          calendarStyle: CalendarStyle(monthHeaderStyle: MonthHeaderStyle(
            stringBuilder: (date) {
              return DateFormat.EEEE(Intl.defaultLocale).format(date);
            },
          ), dayHeaderStyle: DayHeaderStyle(
            stringBuilder: (date) {
              return DateFormat('EEE', Intl.defaultLocale).format(date);
            },
          ), scheduleMonthHeaderStyle: ScheduleMonthHeaderStyle(
            stringBuilder: (date) {
              return DateFormat('yyyy - MMMM', Intl.defaultLocale).format(date);
            },
          )),
          currentConfiguration:
              viewConfigurations[currentConfigurationIndex],
          calendarLayoutDelegates: CalendarLayoutDelegates(),
          onDateTapped: () {
            scheduleBloc.add(
                ChangeCalendarView(viewIndex: ScheduleState.defaultViewIndex));
          },
        ),
      ),
    );
  }

  Widget _calendarHeaderBuilder(DateTimeRange visibleDateTimeRange) {
    return CalendarHeader(
      calendarController: controller,
      viewConfigurations: viewConfigurations,
      currentConfiguration: currentConfigurationIndex,
      onViewConfigurationChanged: (viewConfiguration) {
        scheduleBloc
            .add(ChangeCalendarView(viewIndex: viewConfiguration));
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
