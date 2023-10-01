import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:thetimeblockingapp/common/widgets/custom_calendar.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';

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
                      clickUpAccessToken:
                      Globals.clickUpAuthAccessToken))));
        },
        builder: (context, startUpCurrentState) {
          return BlocConsumer<ScheduleBloc, ScheduleState>(
            listener: (context, state) {

            },
            builder: (context, state) {
              final scheduleBloc = BlocProvider.of<ScheduleBloc>(context);
              if (state.isInitial) {
                scheduleBloc.add(GetTasksForSingleWorkspaceScheduleEvent(
                    GetClickUpTasksInWorkspaceParams(
                        workspaceId:
                        startUpCurrentState.selectedClickupWorkspace?.id ??
                            Globals.clickUpWorkspaces?.first.id ??
                            "",
                        filtersParams: GetClickUpTasksInWorkspaceFiltersParams(
                            clickUpAccessToken:
                            Globals.clickUpAuthAccessToken))));
              }
              return ResponsiveScaffold(
                  responsiveScaffoldLoading: ResponsiveScaffoldLoading(
                      responsiveScaffoldLoadingEnum:
                          ResponsiveScaffoldLoadingEnum.overlayLoading,
                      isLoading: state.scheduleStates
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
                    mobile: _SchedulePageContent(scheduleBloc: scheduleBloc),
                    laptop: _SchedulePageContent(scheduleBloc: scheduleBloc),
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
  const _SchedulePageContent({Key? key, required this.scheduleBloc})
      : super(key: key);
  final ScheduleBloc scheduleBloc;

  @override
  Widget build(BuildContext context) {
    return CustomCalendar(tasksDataSource: TasksDataSource(tasks: scheduleBloc.state.clickUpTasks
        ?.where((element) =>
    element.startDate != null &&
        element.dueDate != null ).map((e) => Appointment(
        id: e.id,
        notes: e.description,
        subject: e.name??'',
        startTime: e.startDate !,
        endTime:e.dueDate!))
        .toList() ??
        []),);
  }
}