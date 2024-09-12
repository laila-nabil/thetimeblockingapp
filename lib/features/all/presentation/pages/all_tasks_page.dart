import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/common/entities/status.dart';
import 'package:thetimeblockingapp/common/enums/backend_mode.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';
import 'package:thetimeblockingapp/features/all/presentation/bloc/all_tasks_bloc.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task_parameters.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_tasks_in_single_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/presentation/widgets/task_component.dart';

import '../../../../common/widgets/add_item_floating_action_button.dart';
import '../../../../common/widgets/custom_alert_dialog.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/responsive/responsive.dart';
import '../../../../common/widgets/responsive/responsive_scaffold.dart';

import '../../../../core/injection_container.dart';
import '../../../../core/localization/localization.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../global/presentation/bloc/global_bloc.dart';
import '../../../task_popup/presentation/views/task_popup.dart';
import '../../../../common/entities/space.dart';
import '../../../tasks/presentation/widgets/toggleable_section.dart';

class AllTasksPage extends StatelessWidget {
  const AllTasksPage({super.key});

  static const routeName = "/All_Tasks";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<AllTasksBloc>(),
      child: BlocBuilder<GlobalBloc, GlobalState>(
        builder: (context, startupState) {
          final globalBloc = BlocProvider.of<GlobalBloc>(context);
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
                                allTasksBloc.add(CreateTaskEvent(
                                    params: params,
                                    workspace: BlocProvider.of<GlobalBloc>(context).state.selectedWorkspace!));
                                Navigator.maybePop(context);
                              },
                              isLoading: (state) => state is! AllTasksState
                                  ? false
                                  : state.isLoading, ));
                    },
                  ),
                  responsiveScaffoldLoading: ResponsiveScaffoldLoading(
                      responsiveScaffoldLoadingEnum:
                          ResponsiveScaffoldLoadingEnum.contentLoading,
                      isLoading: state.isLoading || startupState.isLoading),
                  responsiveBody: ResponsiveTParams(
                      small: BlocConsumer<AllTasksBloc, AllTasksState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state.isInit && serviceLocator<bool>(
                            instanceName:ServiceLocatorName.isWorkspaceAndSpaceAppWide.name)) {
                        getAllTasksInWorkspace(allTasksBloc,context);
                      }
                      return Padding(
                        padding: EdgeInsets.all(AppSpacing.medium16.value),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(AppSpacing.medium16.value),
                            margin: EdgeInsets.only(
                                bottom: AppSpacing.medium16.value),
                            child: Text(
                              appLocalization.translate("AllTasks"),
                              style: AppTextStyle.getTextStyle(
                                  AppTextStyleParams(
                                      color: AppColors.grey(context.isDarkMode).shade900,
                                      appFontWeight: AppFontWeight.medium,
                                      appFontSize: AppFontSize.heading4)),
                            ),
                          ),
                          if (serviceLocator<bool>(instanceName:ServiceLocatorName.isWorkspaceAndSpaceAppWide.name) == false
                              // &&
                              // BlocProvider.of<GlobalBloc>(context).state.spaces?.isNotEmpty == true
                          )
                            DropdownButton<Space?>(
                              value: BlocProvider.of<GlobalBloc>(context).state.selectedSpace,
                              onChanged: (selected) {
                                ///TODO C select space
                              },
                              items:
                              // BlocProvider.of<GlobalBloc>(context).state.spaces
                              //         ?.map((e) => DropdownMenuItem(
                              //               value: e,
                              //               child: Text(e.name ?? ""),
                              //             ))
                              //         .toList() ??
                                  const [],
                              hint: Text(appLocalization.translate("spaces")),
                            ),
                          Expanded(
                            child: ListView(
                              children: [
                                if (state.getAllTasksResultOverdue.isNotEmpty)
                                  true? ToggleableSection(
                                      title: appLocalization.translate("Overdue"),
                                      titleColor: AppColors.error(context.isDarkMode).shade500,
                                      children: state.getAllTasksResultOverdue
                                          .map<Widget>((e) => buildTaskWidget(
                                          e, context, allTasksBloc))
                                          .toList()):Column(
                                    children: state.getAllTasksResultOverdue
                                            .map((e) => buildTaskWidget(
                                                e, context, allTasksBloc))
                                            .toList(),
                                  ),
                                if (state.getAllTasksResultUpcoming.isNotEmpty)
                                  true? ToggleableSection(
                                      title: appLocalization.translate("Upcoming"),
                                      titleColor: AppColors.warning(context.isDarkMode).shade500,
                                      children: state.getAllTasksResultUpcoming
                                          .map<Widget>((e) => buildTaskWidget(
                                          e, context, allTasksBloc))
                                          .toList()):Column(
                                    children: state.getAllTasksResultUpcoming
                                            .map((e) => buildTaskWidget(
                                                e, context, allTasksBloc))
                                            .toList(),
                                  ),
                                if (state.getAllTasksResultUnscheduled.isNotEmpty)
                                  true ? ToggleableSection(
                                      title: appLocalization.translate("Unscheduled"),
                                      children: state.getAllTasksResultUnscheduled
                                          .map<Widget>((e) => buildTaskWidget(
                                          e, context, allTasksBloc))
                                          .toList()):Column(
                                    children: state.getAllTasksResultUnscheduled
                                            .map((e) => buildTaskWidget(
                                                e, context, allTasksBloc))
                                            .toList(),
                                  ),
                                if (state.getAllTasksResultCompleted.isNotEmpty)
                                  true ? ToggleableSection(
                                      isOpenInStart: false,
                                      title: appLocalization.translate("Completed"),
                                      titleColor: AppColors.success(context.isDarkMode).shade500,
                                      children: state.getAllTasksResultCompleted
                                          .map<Widget>((e) => buildTaskWidget(
                                          e, context, allTasksBloc))
                                          .toList()):Column(
                                    children: state.getAllTasksResultUnscheduled
                                        .map((e) => buildTaskWidget(
                                        e, context, allTasksBloc))
                                        .toList(),
                                  )
                              ],
                            ),
                          )
                        ]),
                      );
                    },
                  )),
                  context: context, onRefresh: ()async {
                getAllTasksInWorkspace(allTasksBloc,context);
                globalBloc.add(GetAllInWorkspaceEvent(
                    workspace: BlocProvider.of<GlobalBloc>(context).state.selectedWorkspace!,
                    accessToken: BlocProvider.of<AuthBloc>(context).state.accessToken!));
              },);
            },
          );
        },
      ),
    );
  }

  Widget buildTaskWidget(Task task, BuildContext context,
      AllTasksBloc allTasksBloc) {
    return TaskComponent(
          task: task,
          bloc: allTasksBloc,
          onDelete: (params) {
    allTasksBloc.add(DeleteTaskEvent(
        params: params, workspace: BlocProvider.of<GlobalBloc>(context).state.selectedWorkspace!));
    Navigator.maybePop(context);
          },
          onSave: (params) {
    allTasksBloc.add(UpdateTaskEvent(
        params: params, workspace: BlocProvider.of<GlobalBloc>(context).state.selectedWorkspace!));
    Navigator.maybePop(context);
          },
          isLoading: (state) => state is! AllTasksState ? false : state.isLoading,
          onDuplicate: (params) {
    allTasksBloc.add(DuplicateTaskEvent(
      params: params,
      workspace:
      BlocProvider.of<GlobalBloc>(context).state.selectedWorkspace!,
    ));
          }, onDeleteConfirmed: () {
      allTasksBloc.add(DeleteTaskEvent(
          params: DeleteTaskParams(
              task: task,
              accessToken:
              BlocProvider.of<AuthBloc>(context).state.accessToken!),
          workspace: BlocProvider.of<GlobalBloc>(context)
              .state
              .selectedWorkspace!));
    }, onCompleteConfirmed: () {
      var authState = BlocProvider.of<AuthBloc>(context).state;
      var globalState = BlocProvider.of<GlobalBloc>(context).state;
      final newTask = task.copyWith(status: globalState.statuses!.completedStatus);
      printDebug("newTask $newTask");
      allTasksBloc.add(UpdateTaskEvent(
          params: CreateTaskParams.startUpdateTask(
              accessToken: authState.accessToken!,
              task: newTask,
              backendMode: serviceLocator<BackendMode>(),
              user: authState.user!,
              space: newTask.space,
              tags: newTask.tags),
          workspace: globalState.selectedWorkspace!)); },
        );
  }

  void getAllTasksInWorkspace(AllTasksBloc allTasksBloc,BuildContext context) {
    allTasksBloc.add(GetTasksInWorkspaceEvent(
        accessToken: BlocProvider.of<AuthBloc>(context).state.accessToken!,
        workspace: BlocProvider.of<GlobalBloc>(context).state.selectedWorkspace!,
        ));
  }
}
