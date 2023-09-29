import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';

import '../../../../common/widgets/responsive/responsive.dart';
import '../../../../common/widgets/responsive/responsive_scaffold.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({Key? key}) : super(key: key);
  static const routeName = "/Schedule";


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<ScheduleBloc>(),
      child: BlocConsumer<ScheduleBloc, ScheduleState>(
        listener: (context, state) {

        },
        builder: (context, state) {
          final scheduleBloc = BlocProvider.of<ScheduleBloc>(context);
          if (state.isInitial) {
            scheduleBloc.add(GetTasksForSingleWorkspaceScheduleEvent(
                GetClickUpTasksInWorkspaceParams(
                    workspaceId: Globals.clickUpWorkspaces?.first.id ?? "",
                    filtersParams: GetClickUpTasksInWorkspaceFiltersParams(
                        clickUpAccessToken:
                        Globals.clickUpAuthAccessToken))));
          }
          return ResponsiveScaffold(
              showSmallDesign: Responsive.showSmallDesign(context),
              responsiveBody: ResponsiveTParams(
                mobile: _SchedulePageContent(scheduleBloc: scheduleBloc),
                laptop: _SchedulePageContent(scheduleBloc: scheduleBloc),
              ),
              context: context);
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
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(Globals.clickUpUser.toString()),
          Text(Globals.clickUpWorkspaces.toString()),
          Text(scheduleBloc.state.toString()),
          Text(scheduleBloc.state.clickUpTasks.toString())
        ],
      ),
    );
  }
}
