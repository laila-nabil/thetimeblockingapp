import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/widgets/tasks_calendar.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:thetimeblockingapp/features/task_popup/presentation/views/task_popup.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_tasks_in_single_workspace_use_case.dart';

import '../../../../common/widgets/add_item_floating_action_button.dart';
import '../../../../common/widgets/custom_pop_up_menu.dart';
import '../../../../common/widgets/responsive/responsive.dart';
import '../../../../common/widgets/responsive/responsive_scaffold.dart';
import '../../../global/presentation/bloc/global_bloc.dart';

///TODO Z in desktop, month calendar view in drawer like SORTED for MAC

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
              final scheduleBloc = BlocProvider.of<ScheduleBloc>(context);
              final globalBloc = BlocProvider.of<GlobalBloc>(context);
              if (state.canShowTaskPopup(
                  startupStateEnum: globalCurrentState.startupStateEnum)) {
                scheduleBloc
                    .add(const ShowTaskPopupEvent(showTaskPopup: false));
                showTaskPopup(
                  context: context,
                  taskPopupParams: state.taskPopupParams!,
                );
              }
              if (globalCurrentState.priorities?.isNotEmpty != true) {
                globalBloc
                    .add(GetPrioritiesEvent(accessToken: Globals.accessToken));
              }
              if (globalCurrentState.statuses?.isNotEmpty != true) {
                globalBloc
                    .add(GetStatusesEvent(accessToken: Globals.accessToken));
              }
            },
            builder: (context, state) {
              printDebug("ScheduleBloc state $state");
              final scheduleBloc = BlocProvider.of<ScheduleBloc>(context);
              final changeTaskSuccessfully = state.changedTaskSuccessfully;
              if ((Globals.isWorkspaceAndSpaceAppWide == false && state.isInitial) ||
                  (Globals.isWorkspaceAndSpaceAppWide == true &&
                      state.tasks == null &&
                      Globals.workspaces?.isNotEmpty == true) ||
                  changeTaskSuccessfully) {
                if (changeTaskSuccessfully) {
                  Navigator.maybePop(context);
                }
                final workspace = (globalCurrentState.selectedWorkspace ??
                    Globals.selectedWorkspace ??
                    Globals.workspaces?.first);
                printDebug(">><< workspace $workspace");
                scheduleBloc.add(GetTasksForSingleWorkspaceScheduleEvent(
                    GetTasksInWorkspaceParams(
                        workspaceId:
                        workspace?.id ?? 0,
                        filtersParams: scheduleBloc
                            .state.defaultTasksInWorkspaceFiltersParams,
                        backendMode: Globals.backendMode)));
                globalBloc.add(GetAllInWorkspaceEvent(
                    workspace: workspace!,
                    accessToken: Globals.accessToken));
              }
              return ResponsiveScaffold(
                  floatingActionButton: AddItemFloatingActionButton(
                    onPressed: () {
                      scheduleBloc.add(ShowTaskPopupEvent(
                          showTaskPopup: true,
                          taskPopupParams: TaskPopupParams.notAllDayTask(
                            onSave: (params) {
                              scheduleBloc
                                  .add(CreateTaskEvent(params: params));
                            },
                            bloc: scheduleBloc,
                            isLoading: (state) => state is! ScheduleState
                                ? false
                                : state.isLoading,
                          )));
                    },
                  ),
                  responsiveScaffoldLoading: ResponsiveScaffoldLoading(
                      responsiveScaffoldLoadingEnum:
                          ResponsiveScaffoldLoadingEnum.overlayLoading,
                      isLoading: state.persistingScheduleStates
                              .contains(ScheduleStateEnum.loading) ||
                          globalCurrentState.isLoading),
                  pageActions: [
                    ///TODO Z Bulk actions on tasks
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

                    ///TODO Z auto Schedule
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
                        selectedWorkspaceId:
                            globalCurrentState.selectedWorkspace?.id ?? 0),
                    large: _SchedulePageContent(
                        scheduleBloc: scheduleBloc,
                        selectedWorkspaceId:
                            globalCurrentState.selectedWorkspace?.id),
                  ),
                  context: context, onRefresh: ()async {
                var selectedWorkspace =
                    Globals.selectedWorkspace ?? Globals.defaultWorkspace;
                scheduleBloc.add(GetTasksForSingleWorkspaceScheduleEvent(
                    GetTasksInWorkspaceParams(
                        workspaceId: selectedWorkspace?.id ?? 0,
                        filtersParams:
                        scheduleBloc.state.defaultTasksInWorkspaceFiltersParams,
                        backendMode: Globals.backendMode)));
                globalBloc.add(GetAllInWorkspaceEvent(
                    workspace: selectedWorkspace!,
                    accessToken: Globals.accessToken));
              },);
            },
          );
        },
      ),
    );
  }
}

class _SchedulePageContent extends StatelessWidget {
  const _SchedulePageContent(
      {required this.scheduleBloc, this.selectedWorkspaceId});
  final ScheduleBloc scheduleBloc;
  final int? selectedWorkspaceId;

  @override
  Widget build(BuildContext context) {
    return TasksCalendar(
      tasksDataSource: SupabaseTasksDataSource(
          tasks: scheduleBloc.state.tasks
                  ?.where((element) => element.dueDate != null)
                  .toList() ??
              []),
      controller: scheduleBloc.controller,
      scheduleBloc: scheduleBloc,
      selectedWorkspaceId: selectedWorkspaceId,
    );
  }
}
