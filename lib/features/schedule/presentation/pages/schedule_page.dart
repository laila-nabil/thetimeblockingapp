import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalender/kalender.dart';
import 'package:thetimeblockingapp/common/enums/backend_mode.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/get_priorities_use_case.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/get_workspaces_use_case.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/widgets/syncfusion_tasks_calendar.dart';

import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:thetimeblockingapp/features/task_popup/presentation/views/task_popup.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_tasks_in_single_workspace_use_case.dart';

import '../../../../common/entities/task.dart';
import '../../../../common/widgets/add_item_floating_action_button.dart';
import '../../../../common/widgets/custom_pop_up_menu.dart';
import '../../../../common/widgets/responsive/responsive.dart';
import '../../../../common/widgets/responsive/responsive_scaffold.dart';
import '../../../global/presentation/bloc/global_bloc.dart';
import '../widgets/kalendar_tasks_calendar.dart';

///TODO in desktop, month calendar view in drawer like SORTED for MAC

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key, this.waitForStartGetTasks = false});

  static const routeName = "/Schedule";
  final bool waitForStartGetTasks;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<ScheduleBloc>(),
      child: BlocConsumer<GlobalBloc, GlobalState>(
        listener: (context, globalCurrentState) {},
        builder: (context, globalCurrentState) {
          final globalBloc = BlocProvider.of<GlobalBloc>(context);
          return BlocConsumer<ScheduleBloc, ScheduleState>(
            listener: (context, state) {
              final scheduleBloc =
                  BlocProvider.of<ScheduleBloc>(context, listen: false);
              if (isLoading(
                          scheduleState: state,
                          globalCurrentState: globalCurrentState,
                          authBloc: BlocProvider.of<AuthBloc>(context)) ==
                      false &&
                  state.showTaskPopup == true) {
                showTaskPopup(
                  context: context,
                  taskPopupParams: state.taskPopupParams!,
                );
                scheduleBloc
                    .add(const ShowTaskPopupEvent(showTaskPopup: false));
              }
            },
            builder: (context, state) {
              printDebug("ScheduleBloc state $state");
              final scheduleBloc =
                  BlocProvider.of<ScheduleBloc>(context, listen: false);
              final authBloc = BlocProvider.of<AuthBloc>(context);
              final changeTaskSuccessfully = state.changedTaskSuccessfully;
              if (globalCurrentState.priorities?.isNotEmpty != true) {
                globalBloc.add(GetPrioritiesEvent(
                    GetPrioritiesParams(appLocalization.getCurrentLanguagesEnum(context) ??
                        LanguagesEnum.en)));
              }
              if (globalCurrentState.statuses?.isNotEmpty != true) {
                globalBloc.add(GetStatusesEvent());
              }
              if (globalCurrentState.workspaces?.isNotEmpty != true) {
                final globalBloc =
                    BlocProvider.of<GlobalBloc>(context, listen: false);
                globalBloc.add(GetAllWorkspacesEvent(
                    params:
                        GetWorkspacesParams(userId: authBloc.state.user!.id!)));
              }
              var isWorkspaceAndSpaceAppWide =
                  serviceLocator<AppConfig>().isWorkspaceAppWide;
              if (globalCurrentState.isLoading != true &&
                  state.isLoading != true &&
                  ((isWorkspaceAndSpaceAppWide == false && state.isInitial) ||
                      (isWorkspaceAndSpaceAppWide == true &&
                          state.tasks == null &&
                          globalCurrentState.workspaces?.isNotEmpty == true) ||
                      changeTaskSuccessfully)) {
                if (changeTaskSuccessfully) {
                  Navigator.maybePop(context);
                }
                final workspace = (globalCurrentState.selectedWorkspace ??
                    globalCurrentState.selectedWorkspace ??
                    globalCurrentState.workspaces?.first);
                printDebug(">><< workspace $workspace");
                scheduleBloc.add(GetTasksForSingleWorkspaceScheduleEvent(
                    GetTasksInWorkspaceParams(
                        workspaceId: workspace?.id ?? 0,
                        filtersParams:
                            state.defaultTasksInWorkspaceFiltersParams(
                                user: authBloc.state.user),
                        backendMode: serviceLocator<BackendMode>().mode)));
                globalBloc.add(GetAllInWorkspaceEvent(
                    workspace: workspace!, user: authBloc.state.user!));
              }
              return ResponsiveScaffold(
                floatingActionButton: AddItemFloatingActionButton(
                  onPressed: () {
                    scheduleBloc.add(ShowTaskPopupEvent(
                        showTaskPopup: true,
                        taskPopupParams: TaskPopupParams.notAllDayTask(
                          onSave: (params) {
                            scheduleBloc.add(CreateTaskEvent(
                                params: params,
                                workspaceId: (globalCurrentState
                                            .selectedWorkspace ??
                                        globalCurrentState.selectedWorkspace ??
                                        globalCurrentState.workspaces?.first)!
                                    .id!));
                          },
                          bloc: scheduleBloc,
                          isLoading: (state) =>
                              state is! ScheduleState ? false : state.isLoading,
                        )));
                  },
                ),
                responsiveScaffoldLoading: ResponsiveScaffoldLoading(
                    responsiveScaffoldLoadingEnum:
                        ResponsiveScaffoldLoadingEnum.overlayLoading,
                    isLoading: isLoading(
                        scheduleState: state,
                        globalCurrentState: globalCurrentState,
                        authBloc: authBloc)),
                pageActions: [
                  ///TODO Bulk actions on tasks
                  // CustomDropDownItem.text(
                  //   title: appLocalization.translate("filterBy") +
                  //       appLocalization.translate("Lists").toLowerCase(),
                  //   onTap: () {
                  //     ///TO DO filter by lists in schedule page
                  //   },
                  // ),
                  // CustomDropDownItem.text(
                  //   title: appLocalization.translate("filterBy") +
                  //       appLocalization.translate("Tags").toLowerCase(),
                  //   onTap: () {
                  //     ///TO DO filter by tags in schedule page
                  //   },
                  // ),

                  ///TODO auto Schedule
                  // ignore: dead_code
                  if (false)
                    CustomPopupItem(
                      title: appLocalization.translate("autoSchedule"),
                      onTap: () {},
                    ),

                  // ignore: dead_code
                  if (false)
                    CustomPopupItem(
                      title: appLocalization.translate("showCompleted"),
                      onTap: () {},
                    ),
                ],
                responsiveBody: ResponsiveTParams(
                  small: _SchedulePageContent(
                      scheduleBloc: scheduleBloc,
                      scheduleState: state,
                      selectedWorkspaceId:
                          globalCurrentState.selectedWorkspace?.id ?? 0),
                  large: _SchedulePageContent(
                      scheduleBloc: scheduleBloc,
                      scheduleState: state,
                      selectedWorkspaceId:
                          globalCurrentState.selectedWorkspace?.id),
                ),
                context: context,
                onRefresh: () async {
                  var selectedWorkspace = BlocProvider.of<GlobalBloc>(context)
                      .state
                      .selectedWorkspace;
                  scheduleBloc.add(GetTasksForSingleWorkspaceScheduleEvent(
                      GetTasksInWorkspaceParams(
                          workspaceId: selectedWorkspace?.id ?? 0,
                          filtersParams:
                              state.defaultTasksInWorkspaceFiltersParams(
                                  user: authBloc.state.user),
                          backendMode: serviceLocator<BackendMode>().mode)));
                  globalBloc.add(GetAllInWorkspaceEvent(
                      workspace: selectedWorkspace!,
                      user: authBloc.state.user!));
                },
              );
            },
          );
        },
      ),
    );
  }

  bool isLoading(
      {required ScheduleState scheduleState,
      required GlobalState globalCurrentState,
      required AuthBloc authBloc}) {
    return scheduleState.persistingScheduleStates
            .contains(ScheduleStateEnum.loading) ||
        globalCurrentState.isLoading ||
        authBloc.state.isLoading ||
        globalCurrentState.workspaces == null;
  }
}

class _SchedulePageContent extends StatelessWidget {
  const _SchedulePageContent(
      {required this.scheduleBloc,
      this.selectedWorkspaceId,
      required this.scheduleState});

  final ScheduleBloc scheduleBloc;
  final int? selectedWorkspaceId;
  final ScheduleState scheduleState;

  @override
  Widget build(BuildContext context) {
    final calendarController = CalendarController<Task>();
    final tasks = scheduleState.tasks
            ?.where((element) => element.dueDate != null)
            .toList() ??
        [];
    final events = tasks
        .map<CalendarEvent<Task>>((task) => CalendarEvent(
            eventData: task,
            dateTimeRange:
                DateTimeRange(start: task.startDate!, end: task.dueDate!)))
        .toList();
    final CalendarEventsController<Task> eventsController =
        CalendarEventsController<Task>();
    eventsController.addEvents(events);
    return KalendarTasksCalendar(
      eventsController: eventsController,
      controller: calendarController,
      scheduleBloc: scheduleBloc,
      scheduleState: scheduleState,
      selectedWorkspaceId: selectedWorkspaceId,
      currentConfigurationIndex:
          scheduleState.viewIndex ?? ScheduleState.defaultViewIndex,
    );
  }
}
