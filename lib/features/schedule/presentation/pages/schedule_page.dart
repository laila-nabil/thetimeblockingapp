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
        listener: (context, startUpCurrentState) {
          final scheduleBloc = BlocProvider.of<ScheduleBloc>(context);
          scheduleBloc.add(GetTasksForSingleWorkspaceScheduleEvent(
              GetClickUpTasksInWorkspaceParams(
                  workspaceId:
                      startUpCurrentState.selectedClickupWorkspace?.id ??
                          Globals.clickUpWorkspaces?.first.id ??
                          "",
                  filtersParams: GetClickUpTasksInWorkspaceFiltersParams(
                      clickUpAccessToken: Globals.clickUpAuthAccessToken))));
        },
        builder: (context, startUpCurrentState) {
          return BlocConsumer<ScheduleBloc, ScheduleState>(
            listener: (context, state) {},
            builder: (context, state) {
              final scheduleBloc = BlocProvider.of<ScheduleBloc>(context);
              final changeTaskSuccessfully = state.nonPersistingScheduleState ==
                      ScheduleStateEnum.createTaskSuccess ||
                  state.nonPersistingScheduleState ==
                      ScheduleStateEnum.updateTaskSuccess ||
                  state.nonPersistingScheduleState ==
                      ScheduleStateEnum.deleteTaskSuccess;
              if (state.isInitial || changeTaskSuccessfully) {
                if (changeTaskSuccessfully) {
                  Navigator.maybePop(context);
                }
                scheduleBloc.add(GetTasksForSingleWorkspaceScheduleEvent(
                    GetClickUpTasksInWorkspaceParams(
                        workspaceId:
                            startUpCurrentState.selectedClickupWorkspace?.id ??
                                Globals.clickUpWorkspaces?.first.id ??
                                "",
                        filtersParams: GetClickUpTasksInWorkspaceFiltersParams(
                            clickUpAccessToken: Globals.clickUpAuthAccessToken,
                            filterByAssignees: [
                              Globals.clickUpUser?.id.toString() ?? ""
                            ],
                            filterByDueDateGreaterThanUnixTimeMilliseconds:
                                scheduleBloc.state.tasksDueDateEarliestDate
                                    .millisecondsSinceEpoch,
                            filterByDueDateLessThanUnixTimeMilliseconds:
                                scheduleBloc.state.tasksDueDateLatestDate
                                    .millisecondsSinceEpoch))));
              }
              return ResponsiveScaffold(
                  floatingActionButton: AddItemFloatingActionButton(
                    onPressed: () {
                      showTaskPopup(context: context,
                        taskPopupParams: TaskPopupParams(
                            onSave: (params) {
                              scheduleBloc.add(CreateClickUpTaskEvent(params: params));
                            },
                            scheduleBloc: scheduleBloc),);
                    },
                  ),
                  responsiveScaffoldLoading: ResponsiveScaffoldLoading(
                      responsiveScaffoldLoadingEnum:
                          ResponsiveScaffoldLoadingEnum.overlayLoading,
                      isLoading: state.persistingScheduleStates
                          .contains(ScheduleStateEnum.loading)),
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
    return TasksCalendar(
      tasksDataSource: ClickupTasksDataSource(
          clickupTasks: scheduleBloc.state.clickUpTasks
                  ?.where((element) => element.dueDateUtcTimestamp != null)
                  .toList() ??
              []),
      controller: scheduleBloc.controller,
      scheduleBloc: scheduleBloc,
      selectedClickupWorkspaceId: selectedClickupWorkspaceId,
    );
  }
}
