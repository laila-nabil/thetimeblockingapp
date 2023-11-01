import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/widgets/tasks_calendar.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:thetimeblockingapp/features/task_popup/presentation/views/task_popup.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';

import '../../../../common/widgets/add_item_floating_action_button.dart';
import '../../../../common/widgets/responsive/responsive.dart';
import '../../../../common/widgets/responsive/responsive_scaffold.dart';
import '../../../startup/presentation/bloc/startup_bloc.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({Key? key}) : super(key: key);
  static const routeName = "/Schedule";

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
                  startUpCurrentState.getTasks != false) {
                startupBloc.add(const GetTasksEvent(getTasks: false));
              }
            },
            builder: (context, state) {
              final scheduleBloc = BlocProvider.of<ScheduleBloc>(context);
              final changeTaskSuccessfully = state.changedTaskSuccessfully;
              if ((Globals.isSpaceAppWide == false && state.isInitial) ||
                  (Globals.isSpaceAppWide == true &&
                      startUpCurrentState.getTasks == true) ||
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
                                scheduleBloc.add(
                                    CreateClickupTaskEvent(params: params));
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
                    PopupMenuItem(
                      child: Text(appLocalization.translate("filterBy") +
                          appLocalization.translate("Lists").toLowerCase()),
                      onTap: () {},
                    ),
                    PopupMenuItem(
                      child: Text(appLocalization.translate("filterBy") +
                          appLocalization.translate("Tags").toLowerCase()),
                      onTap: () {},
                    ),
                    PopupMenuItem(
                      child: Text(appLocalization.translate("autoSchedule")),
                      onTap: () {},
                    ),
                    PopupMenuItem(
                      child: Text(appLocalization.translate("showCompleted")),
                      onTap: () {},
                    ),
                  ],
                  responsiveBody: ResponsiveTParams(
                    mobile: _SchedulePageContent(
                        scheduleBloc: scheduleBloc,
                        selectedClickupWorkspaceId:
                            startUpCurrentState.selectedClickupWorkspace?.id),
                    laptop: _SchedulePageContent(
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
                filtersParams: scheduleBloc
                    .state.defaultTasksInWorkspaceFiltersParams)));
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
