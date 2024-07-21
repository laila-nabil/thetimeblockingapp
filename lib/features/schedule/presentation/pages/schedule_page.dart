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
import '../../../startup/presentation/bloc/startup_bloc.dart';

///TODO in desktop, month calendar view in drawer like SORTED for MAC

class SchedulePage extends StatelessWidget {
  const SchedulePage({Key? key, this.waitForStartGetTasks = false})
      : super(key: key);
  static const routeName = "/Schedule";
  final bool waitForStartGetTasks;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<ScheduleBloc>(),
      child: BlocConsumer<StartupBloc, StartupState>(
        listener: (context, startUpCurrentState) {},
        builder: (context, startUpCurrentState) {
          final startupBloc = BlocProvider.of<StartupBloc>(context);
          return BlocConsumer<ScheduleBloc, ScheduleState>(
            listener: (context, state) {
              final scheduleBloc = BlocProvider.of<ScheduleBloc>(context);
              final startupBloc = BlocProvider.of<StartupBloc>(context);
              if (state.canShowTaskPopup(
                  startupStateEnum: startUpCurrentState.startupStateEnum)) {
                scheduleBloc
                    .add(const ShowTaskPopupEvent(showTaskPopup: false));
                showTaskPopup(
                  context: context,
                  taskPopupParams: state.taskPopupParams!,
                );
              }
              if ((startUpCurrentState.startupStateEnum ==
                          StartupStateEnum.getAllInSpaceFailed ||
                      startUpCurrentState.startupStateEnum ==
                          StartupStateEnum.getAllInSpaceSuccess) &&
                  state.startGetTasks(
                      startGetTasks: startUpCurrentState.startGetTasks,
                      waitForStartGetTasks: waitForStartGetTasks)) {
                startupBloc.add(const StartGetTasksEvent(startGetTasks: false));
              }
            },
            builder: (context, state) {
              printDebug("ScheduleBloc state $state");
              final scheduleBloc = BlocProvider.of<ScheduleBloc>(context);
              final changeTaskSuccessfully = state.changedTaskSuccessfully;
              if ((Globals.isSpaceAppWide == false && state.isInitial) ||
                  (Globals.isSpaceAppWide == true &&
                      state.startGetTasks(
                          startGetTasks: startUpCurrentState.startGetTasks,
                          waitForStartGetTasks: waitForStartGetTasks)) ||
                  changeTaskSuccessfully) {
                if (changeTaskSuccessfully) {
                  Navigator.maybePop(context);
                }
                scheduleBloc.add(GetTasksForSingleWorkspaceScheduleEvent(
                    GetTasksInWorkspaceParams(
                        workspaceId:
                            startUpCurrentState.selectedClickupWorkspace?.id ??
                                Globals.clickupWorkspaces?.first.id ??
                                "",
                        filtersParams: scheduleBloc
                            .state.defaultTasksInWorkspaceFiltersParams)));
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
                          startUpCurrentState.isLoading),
                  pageActions: [
                    ///TODO Bulk actions on tasks
                    // CustomDropDownItem.text(
                    //   title: appLocalization.translate("filterBy") +
                    //       appLocalization.translate("Lists").toLowerCase(),
                    //   onTap: () {
                    //     ///TODO filter by lists in schedule page
                    //   },
                    // ),
                    // CustomDropDownItem.text(
                    //   title: appLocalization.translate("filterBy") +
                    //       appLocalization.translate("Tags").toLowerCase(),
                    //   onTap: () {
                    //     ///TODO filter by tags in schedule page
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
                        selectedClickupWorkspaceId:
                            startUpCurrentState.selectedClickupWorkspace?.id),
                    large: _SchedulePageContent(
                        scheduleBloc: scheduleBloc,
                        selectedClickupWorkspaceId:
                            startUpCurrentState.selectedClickupWorkspace?.id),
                  ),
                  context: context, onRefresh: ()async {
                var selectedWorkspace =
                    Globals.selectedWorkspace ?? Globals.defaultWorkspace;
                scheduleBloc.add(GetTasksForSingleWorkspaceScheduleEvent(
                    GetTasksInWorkspaceParams(
                        workspaceId: selectedWorkspace?.id ?? "",
                        filtersParams:
                        scheduleBloc.state.defaultTasksInWorkspaceFiltersParams)));
                startupBloc.add(SelectWorkspaceAndGetSpacesTagsLists(
                    clickupWorkspace: selectedWorkspace!,
                    clickupAccessToken: Globals.AccessToken));
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
      {Key? key, required this.scheduleBloc, this.selectedClickupWorkspaceId})
      : super(key: key);
  final ScheduleBloc scheduleBloc;
  final String? selectedClickupWorkspaceId;

  @override
  Widget build(BuildContext context) {
    return TasksCalendar(
      tasksDataSource: ClickupTasksDataSource(
          clickupTasks: scheduleBloc.state.clickupTasks
                  ?.where((element) => element.dueDateUtcTimestamp != null)
                  .toList() ??
              []),
      controller: scheduleBloc.controller,
      scheduleBloc: scheduleBloc,
      selectedClickupWorkspaceId: selectedClickupWorkspaceId,
    );
  }
}
