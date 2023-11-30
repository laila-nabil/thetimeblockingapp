import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/features/all/presentation/bloc/all_tasks_bloc.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';

import '../../../../common/widgets/add_item_floating_action_button.dart';
import '../../../../common/widgets/responsive/responsive.dart';
import '../../../../common/widgets/responsive/responsive_scaffold.dart';
import '../../../../core/globals.dart';
import '../../../../core/injection_container.dart';
import '../../../../core/localization/localization.dart';
import '../../../startup/presentation/bloc/startup_bloc.dart';
import '../../../task_popup/presentation/views/task_popup.dart';
import '../../../tasks/domain/entities/clickup_space.dart';

class AllTasksPage extends StatelessWidget {
  const AllTasksPage({super.key});

  static const routeName = "/All_Tasks";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<AllTasksBloc>(),
      child: BlocBuilder<StartupBloc, StartupState>(
        builder: (context, startupState) {
          final startupBloc = BlocProvider.of<StartupBloc>(context);
          return BlocConsumer<AllTasksBloc, AllTasksState>(
            listener: (context, state) {
            },
            builder: (context, state) {
              final allTasksBloc = BlocProvider.of<AllTasksBloc>(context);
              return ResponsiveScaffold(
                  floatingActionButton: AddItemFloatingActionButton(
                    onPressed: () {
                      showTaskPopup(
                          context: context,
                          taskPopupParams: TaskPopupParams.notAllDayTask(
                              bloc: allTasksBloc,
                              onSave: (params) {
                                allTasksBloc.add(CreateClickupTaskEvent(
                                    params: params,
                                    workspace: Globals.selectedWorkspace!));
                                Navigator.maybePop(context);
                              },
                              isLoading: (state) => state is! AllTasksState
                                  ? false
                                  : state.isLoading));
                    },
                  ),
                  responsiveScaffoldLoading: ResponsiveScaffoldLoading(
                      responsiveScaffoldLoadingEnum:
                          ResponsiveScaffoldLoadingEnum.contentLoading,
                      isLoading: state.isLoading || startupState.isLoading),
                  responsiveBody: ResponsiveTParams(
                      mobile: BlocConsumer<AllTasksBloc, AllTasksState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state.isInit && Globals.isSpaceAppWide) {
                        getAllTasksInSpace(allTasksBloc);
                      }
                      return Column(children: <Widget>[
                        if (Globals.isSpaceAppWide == false &&
                            Globals.clickupSpaces?.isNotEmpty == true)
                          DropdownButton<ClickupSpace?>(
                            value: Globals.selectedSpace,
                            onChanged: (selected) {
                              if (selected != null &&
                                  state.isLoading == false) {
                                startupBloc.add(SelectClickupSpace(
                                    clickupSpace: selected,
                                    clickupAccessToken:
                                        Globals.clickupAuthAccessToken));
                                getAllTasksInSpace(allTasksBloc);
                              }
                            },
                            items: Globals.clickupSpaces
                                    ?.map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e.name ?? ""),
                                        ))
                                    .toList() ??
                                [],
                            hint: Text(appLocalization.translate("spaces")),
                          ),
                        Expanded(
                          child: ListView(
                            children: [
                              if (state.getAllTasksResultOverdue.isNotEmpty)
                                Text(appLocalization.translate("Overdue")),
                              if (state.getAllTasksResultOverdue.isNotEmpty)
                                Column(
                                  children: state.getAllTasksResultOverdue
                                          .map((e) => buildTaskWidget(
                                              e, context, allTasksBloc))
                                          .toList(),
                                ),
                              if (state.getAllTasksResultUpcoming.isNotEmpty)
                                Text(appLocalization.translate("Upcoming")),
                              if (state.getAllTasksResultUpcoming.isNotEmpty)
                                Column(
                                  children: state.getAllTasksResultUpcoming
                                          .map((e) => buildTaskWidget(
                                              e, context, allTasksBloc))
                                          .toList(),
                                ),
                              if (state.getAllTasksResultUnscheduled.isNotEmpty)
                                Text(appLocalization.translate("Unscheduled")),
                              if (state.getAllTasksResultUnscheduled.isNotEmpty)
                                Column(
                                  children: state.getAllTasksResultUnscheduled
                                          .map((e) => buildTaskWidget(
                                              e, context, allTasksBloc))
                                          .toList(),
                                ),
                            ],
                          ),
                        )
                      ]);
                    },
                  )),
                  context: context);
            },
          );
        },
      ),
    );
  }

  ListTile buildTaskWidget(
      ClickupTask e, BuildContext context, AllTasksBloc allTasksBloc) {
    return ListTile(
      title: Text(e.name ?? ""),
      onTap: () {
        showTaskPopup(
            context: context,
            taskPopupParams: TaskPopupParams.open(
                task: e,
                bloc: allTasksBloc,
                onDelete: (params) {
                  allTasksBloc.add(DeleteClickupTaskEvent(
                      params: params, workspace: Globals.selectedWorkspace!));
                  Navigator.maybePop(context);
                },
                onSave: (params) {
                  allTasksBloc.add(UpdateClickupTaskEvent(
                      params: params, workspace: Globals.selectedWorkspace!));
                  Navigator.maybePop(context);
                },
                isLoading: (state) =>
                    state is! AllTasksState ? false : state.isLoading));
      },
    );
  }

  void getAllTasksInSpace(AllTasksBloc allTasksBloc) {
    allTasksBloc.add(GetClickupTasksInSpaceEvent(
        clickupAccessToken: Globals.clickupAuthAccessToken,
        workspace: Globals.selectedWorkspace!,
        space: Globals.selectedSpace!));
  }
}