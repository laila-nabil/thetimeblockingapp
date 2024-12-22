import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart' as kalender;

// ignore: unused_import
import 'package:syncfusion_flutter_calendar/calendar.dart' as syncfusion;
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';

import 'package:thetimeblockingapp/features/schedule/presentation/bloc/schedule_bloc.dart';

import '../../../../common/entities/task.dart';
import '../widgets/kcalender/kalender_tasks_calendar.dart';
import '../widgets/syncfusion/syncfusion_tasks_calendar.dart';

enum AppCalendar { kalender, syncfusion }

class ScheduleView extends StatelessWidget {
  const ScheduleView(
      {required this.scheduleBloc,
      this.selectedWorkspaceId,
      required this.scheduleState});

  final ScheduleBloc scheduleBloc;
  final int? selectedWorkspaceId;
  final ScheduleState scheduleState;

  @override
  Widget build(BuildContext context) {
    if (serviceLocator<AppConfig>().appCalendar != null) {
      switch (serviceLocator<AppConfig>().appCalendar) {
        case AppCalendar.kalender:
          final tasks = scheduleState.tasks
                  ?.where((element) => element.dueDate != null)
                  .toList() ??
              [];
          final events = tasks
              .map<kalender.CalendarEvent<Task>>(
                  (task) => kalender.CalendarEvent(
                      data: task,
                      dateTimeRange: DateTimeRange(
                        start: task.startDate!.toLocal(),
                        end: task.dueDate!.toLocal(),
                      )))
              .toList();
          final kalender.EventsController<Task> eventsController =
              kalender.EventsController<Task>();
          eventsController.addEvents(events);
          return KalendarTasksCalendar(
            eventsController: eventsController,
            controller: scheduleBloc.kalenderCalendarController,
            scheduleBloc: scheduleBloc,
            scheduleState: scheduleState,
            selectedWorkspaceId: selectedWorkspaceId,
            currentConfigurationIndex:
                scheduleState.viewIndex ?? ScheduleState.defaultViewIndex,
          );
        case AppCalendar.syncfusion:
          return SyncfusionTasksCalendar(
            tasksDataSource: SupabaseTasksDataSource(
                tasks: scheduleState.tasks
                        ?.where((element) => element.dueDate != null)
                        .toList() ??
                    []),
            controller: scheduleBloc.syncfusionCalendarController,
            scheduleBloc: scheduleBloc,
            scheduleState: scheduleState,
            selectedWorkspaceId: selectedWorkspaceId,
          );
        case null:
          return Container();
      }
    }
    return FutureBuilder(
        future: serviceLocator<AppConfig>().appCalendarFuture,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          }
          switch (snapshot.data) {
            case AppCalendar.kalender:
              final tasks = scheduleState.tasks
                      ?.where((element) => element.dueDate != null)
                      .toList() ??
                  [];
              final events = tasks
                  .map<kalender.CalendarEvent<Task>>(
                      (task) => kalender.CalendarEvent(
                          data: task,
                          dateTimeRange: DateTimeRange(
                            start: task.startDate!.toLocal(),
                            end: task.dueDate!.toLocal(),
                          )))
                  .toList();
              final kalender.EventsController<Task> eventsController =
                  kalender.EventsController<Task>();
              eventsController.addEvents(events);
              return KalendarTasksCalendar(
                eventsController: eventsController,
                controller: scheduleBloc.kalenderCalendarController,
                scheduleBloc: scheduleBloc,
                scheduleState: scheduleState,
                selectedWorkspaceId: selectedWorkspaceId,
                currentConfigurationIndex:
                    scheduleState.viewIndex ?? ScheduleState.defaultViewIndex,
              );
            case AppCalendar.syncfusion:
              return SyncfusionTasksCalendar(
                tasksDataSource: SupabaseTasksDataSource(
                    tasks: scheduleState.tasks
                            ?.where((element) => element.dueDate != null)
                            .toList() ??
                        []),
                controller: scheduleBloc.syncfusionCalendarController,
                scheduleBloc: scheduleBloc,
                scheduleState: scheduleState,
                selectedWorkspaceId: selectedWorkspaceId,
              );
            case null:
              return Container();
          }
        });
  }
}
