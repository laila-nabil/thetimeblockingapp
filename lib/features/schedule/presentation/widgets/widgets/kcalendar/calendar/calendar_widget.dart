import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalender/kalender.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';
import 'package:thetimeblockingapp/common/entities/tasks_list.dart';
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/common/enums/backend_mode.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:thetimeblockingapp/features/global/presentation/bloc/global_bloc.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:thetimeblockingapp/features/task_popup/presentation/views/task_popup.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task_parameters.dart';


import '../dialogs/event_edit_dialog.dart';
import '../dialogs/new_event_dialog.dart';
import '../event_tiles/event_tile.dart';
import '../event_tiles/multi_day_event_tile.dart';
import '../event_tiles/schedule_event_tile.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({
    super.key,
    required this.eventsController,
    required this.calendarController,
    required this.calendarComponents,
    required this.calendarStyle,
    required this.calendarLayoutDelegates,
    required this.currentConfiguration,
    required this.onDateTapped,
  });

  final CalendarEventsController<Task> eventsController;
  final CalendarController<Task> calendarController;
  final CalendarComponents calendarComponents;
  final CalendarStyle calendarStyle;
  final CalendarLayoutDelegates<Task> calendarLayoutDelegates;

  final ViewConfiguration currentConfiguration;
  final VoidCallback onDateTapped;

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  @override
  Widget build(BuildContext context) {
    final globalBloc = BlocProvider.of<GlobalBloc>(context);
    return CalendarView<Task>(
      controller: widget.calendarController,
      eventsController: widget.eventsController,
      viewConfiguration: widget.currentConfiguration,
      tileBuilder: _tileBuilder,
      multiDayTileBuilder: _multiDayTileBuilder,
      scheduleTileBuilder: _scheduleTileBuilder,
      components: widget.calendarComponents,
      style: widget.calendarStyle,
      layoutDelegates: widget.calendarLayoutDelegates,
      eventHandlers: CalendarEventHandlers<Task>(
        onEventChanged: onEventChanged,
        onEventTapped: onEventTapped,
        onDateTapped: onDateTapped,
        onCreateEvent: (dateTimeRange) => onEventCreate(
            dateTimeRange: dateTimeRange,
            workspace: globalBloc.state.selectedWorkspace!,
            list: globalBloc.state.selectedWorkspace!.defaultList!),
        onEventCreated: onEventCreated,
      ),
    );
  }

  CalendarEvent<Task> onEventCreate(
      {required DateTimeRange dateTimeRange,
      required Workspace workspace,
      required TasksList list}) {
    return CalendarEvent<Task>(
      dateTimeRange: dateTimeRange,
      eventData: Task(
          id: "id",
          title: 'New Event',
          description: '',
          status: null,
          priority: null,
          tags: [],
          startDate: dateTimeRange.start,
          dueDate: dateTimeRange.end,
          list: list,
          folder: null,
          workspace: workspace),
    );
  }

  /// This function is called when a new event is created.
  Future<void> onEventCreated(CalendarEvent<Task> event) async {
    // Show the new event dialog.
    var scheduleBloc = BlocProvider.of<ScheduleBloc>(context);
    var globalBloc = BlocProvider.of<GlobalBloc>(context);
    scheduleBloc.add(ShowTaskPopupEvent(
        showTaskPopup: true,
        taskPopupParams: TaskPopupParams.notAllDayTask(
            start: event.start,
            onSave: (params) {
              scheduleBloc.add(CreateTaskEvent(
                  params:
                  params, workspaceId: globalBloc.state.selectedWorkspace!.id!));
            },
            bloc: scheduleBloc,
            isLoading:(state)=>scheduleBloc.state.isLoading
        )));

  }

  /// This function is called when an event is tapped.
  Future<void> onEventTapped(CalendarEvent<Task> event) async {
    if (isMobile) {
      widget.eventsController.selectedEvent == event
          ? widget.eventsController.deselectEvent()
          : widget.eventsController.selectEvent(event);
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
            task: event.eventData,
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
              var selectedWorkspace = globalBloc.state.selectedWorkspace;
              scheduleBloc.add(DuplicateTaskEvent(
                  params: CreateTaskParams.fromTask(
                    event.eventData!,
                    serviceLocator<BackendMode>().mode,
                    authBloc.state.user!,
                    selectedWorkspace!.defaultList!,
                  ),
                  workspace: selectedWorkspace.id!));
            },)));
    }
  }

  /// This function is called when an event is changed.
  Future<void> onEventChanged(
    DateTimeRange initialDateTimeRange,
    CalendarEvent<Task> event,
  ) async {
    if (event.eventData != null &&
        (event.eventData?.dueDate?.isAtSameMomentAs(event.end) != true ||
            event.eventData?.startDate?.isAtSameMomentAs(event.start) != true)) {
      var scheduleBloc = BlocProvider.of<ScheduleBloc>(context);
      var globalBloc = BlocProvider.of<GlobalBloc>(context);
      var authBloc = BlocProvider.of<AuthBloc>(context);
      printDebug("initialDateTimeRange $initialDateTimeRange");
      printDebug("event.eventData ${event.eventData}");
      printDebug("authBloc.state.user! ${authBloc.state.user!}");
      scheduleBloc.add(UpdateTaskEvent(
          params: CreateTaskParams.updateTask(
              defaultList: globalBloc.state.selectedWorkspace!.defaultList!,
              task: event.eventData!,
              updatedDueDate: event.end,
              updatedStartDate: event.start,
              backendMode: serviceLocator<BackendMode>().mode,
              user: authBloc.state.user!)));
    }
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Show the snackbar and undo the changes if the user presses the undo button.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${event.eventData?.title} changed'),
        // action: SnackBarAction(
        //   label: 'Undo',
        //   onPressed: () {
        //     widget.eventsController.updateEvent(
        //       newEventData: event.eventData,
        //       newDateTimeRange: initialDateTimeRange,
        //       test: (other) => other.eventData == event.eventData,
        //     );
        //   },
        // ),
      ),
    );
  }

  /// This function is called when a date is tapped.
  void onDateTapped(date) {
    // If the current view is not the single day view, change the view to the single day view.
    if (widget.currentConfiguration is! DayConfiguration) {
      // Set the selected date to the tapped date.
      widget.calendarController.selectedDate = date;
      widget.onDateTapped();
      // widget.currentConfiguration = widget.viewConfigurations.first;
    }
  }

  Widget _tileBuilder(
    CalendarEvent<Task> event,
    TileConfiguration tileConfiguration,
  ) {
    return EventTile(
      event: event,
      tileType: tileConfiguration.tileType,
      drawOutline: tileConfiguration.drawOutline,
      continuesBefore: tileConfiguration.continuesBefore,
      continuesAfter: tileConfiguration.continuesAfter,
    );
  }

  Widget _multiDayTileBuilder(
    CalendarEvent<Task> event,
    MultiDayTileConfiguration tileConfiguration,
  ) {
    return MultiDayEventTile(
      event: event,
      tileType: tileConfiguration.tileType,
      continuesBefore: tileConfiguration.continuesBefore,
      continuesAfter: tileConfiguration.continuesAfter,
    );
  }

  Widget _scheduleTileBuilder(
    CalendarEvent<Task> event,
    DateTime date,
  ) {
    return ScheduleTile(
      event: event,
      date: date,
    );
  }

  bool get isMobile => kIsWeb ? false : Platform.isAndroid || Platform.isIOS;
}
