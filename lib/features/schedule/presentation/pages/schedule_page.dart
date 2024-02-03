import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/widgets/tasks_calendar.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:thetimeblockingapp/features/task_popup/presentation/views/task_popup.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';

import '../../../../common/widgets/add_item_floating_action_button.dart';
import '../../../../common/widgets/custom_drop_down.dart';
import '../../../../common/widgets/responsive/responsive.dart';
import '../../../../common/widgets/responsive/responsive_scaffold.dart';
import '../../../startup/presentation/bloc/startup_bloc.dart';

///TODO V1.5 in web, month calendar view in drawer like SORTED for MAC

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
                    GetClickupTasksInWorkspaceParams(
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
                                  .add(CreateClickupTaskEvent(params: params));
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
                    ///TODO V2 select multiple tasks to perform bulk actions
                    ///TODO V2 bulk move tasks to another list
                    ///TODO V2 bulk delete tasks
                    CustomDropDownItem.text(
                      title: appLocalization.translate("filterBy") +
                          appLocalization.translate("Lists").toLowerCase(),
                      onTap: () {
                        ///TODO V2 filter by lists
                      },
                    ),
                    CustomDropDownItem.text(
                      title: appLocalization.translate("filterBy") +
                          appLocalization.translate("Tags").toLowerCase(),
                      onTap: () {
                        ///TODO V2 filter by tags
                      },
                    ),

                    ///TODO V3 auto Schedule
                    // ignore: dead_code
                    if (false)
                      CustomDropDownItem.text(
                        title: appLocalization.translate("autoSchedule"),
                        onTap: () {},
                      ),

                    ///TODO V2 show completed tasks
                    // ignore: dead_code
                    if (false)
                      CustomDropDownItem.text(
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
                  context: context);
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
    final startupBloc = BlocProvider.of<StartupBloc>(context);
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        var selectedWorkspace =
            Globals.selectedWorkspace ?? Globals.defaultWorkspace;
        scheduleBloc.add(GetTasksForSingleWorkspaceScheduleEvent(
            GetClickupTasksInWorkspaceParams(
                workspaceId: selectedWorkspace?.id ?? "",
                filtersParams:
                    scheduleBloc.state.defaultTasksInWorkspaceFiltersParams)));
        startupBloc.add(SelectClickupWorkspace(
            clickupWorkspace: selectedWorkspace!,
            clickupAccessToken: Globals.clickupAuthAccessToken));
      },
      child: TasksCalendar(
        tasksDataSource: ClickupTasksDataSource(
            clickupTasks: scheduleBloc.state.clickupTasks
                    ?.where((element) => element.dueDateUtcTimestamp != null)
                    .toList() ??
                []),
        controller: scheduleBloc.controller,
        scheduleBloc: scheduleBloc,
        selectedClickupWorkspaceId: selectedClickupWorkspaceId,
      ),
    );
  }
}
