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
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/duplicate_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/presentation/widgets/task_component.dart';

import '../../../../common/widgets/add_item_floating_action_button.dart';
import '../../../../common/widgets/responsive/responsive.dart';
import '../../../../common/widgets/responsive/responsive_scaffold.dart';

import '../../../../core/injection_container.dart';
import '../../../../core/localization/localization.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../global/presentation/bloc/global_bloc.dart';
import '../../../task_popup/presentation/views/task_popup.dart';

import '../../../tasks/presentation/widgets/toggleable_section.dart';

class AllTasksPage extends StatelessWidget {
  const AllTasksPage({super.key});

  static const routeName = "/All_Tasks";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<AllTasksBloc>(),
      child: BlocBuilder<GlobalBloc, GlobalState>(
        builder: (context, globalState) {
          final globalBloc = BlocProvider.of<GlobalBloc>(context);
          return BlocConsumer<AllTasksBloc, AllTasksState>(
            listener: (context, state) {
            },
            builder: (context, state) {
              final allTasksBloc = BlocProvider.of<AllTasksBloc>(context);
              return ResponsiveScaffold(
                  floatingActionButton: AddItemFloatingActionButton(
                    onPressed: () {
                      if(isLoading(
                          state: state,
                          globalState: globalState,
                          authBloc: BlocProvider.of<AuthBloc>(context)) == false){
                      showTaskPopup(
                          context: context,
                          taskPopupParams: TaskPopupParams.notAllDayTask(
                            bloc: allTasksBloc,
                            onSave: (params) {
                              allTasksBloc.add(CreateTaskEvent(
                                  params: params,
                                  workspace:
                                      BlocProvider.of<GlobalBloc>(context)
                                          .state
                                          .selectedWorkspace!));
                              Navigator.maybePop(context);
                            },
                            isLoading: (state) => state is! AllTasksState
                                ? false
                                : state.isLoading,
                          ));
                    }
                  },
                  ),
                  responsiveScaffoldLoading: ResponsiveScaffoldLoading(
                      responsiveScaffoldLoadingEnum:
                          ResponsiveScaffoldLoadingEnum.contentLoading,
                    isLoading: isLoading(
                        state: state,
                        globalState: globalState,
                        authBloc: BlocProvider.of<AuthBloc>(context))),
                responsiveBody: ResponsiveTParams(
                      small: BlocConsumer<AllTasksBloc, AllTasksState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state.isInit && serviceLocator<AppConfig>().isWorkspaceAppWide) {
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
                          Expanded(
                            child: ListView(
                              children: [
                                if (state.getAllTasksResultOverdue.isNotEmpty)
                                  true? ToggleableSection(
                                      title: appLocalization.translate("Overdue"),
                                      titleColor: AppColors.error(context.isDarkMode).shade500,
                                      children: state.getAllTasksResultOverdue
                                          .map<Widget>((e) => buildTaskWidget(
                                          e, context, allTasksBloc,globalState))
                                          .toList()):Column(
                                    children: state.getAllTasksResultOverdue
                                            .map((e) => buildTaskWidget(
                                                e, context, allTasksBloc,globalState))
                                            .toList(),
                                  ),
                                if (state.getAllTasksResultUpcoming.isNotEmpty)
                                  true? ToggleableSection(
                                      title: appLocalization.translate("Upcoming"),
                                      titleColor: AppColors.warning(context.isDarkMode).shade500,
                                      children: state.getAllTasksResultUpcoming
                                          .map<Widget>((e) => buildTaskWidget(
                                          e, context, allTasksBloc,globalState))
                                          .toList()):Column(
                                    children: state.getAllTasksResultUpcoming
                                            .map((e) => buildTaskWidget(
                                                e, context, allTasksBloc,globalState))
                                            .toList(),
                                  ),
                                if (state.getAllTasksResultUnscheduled.isNotEmpty)
                                  true ? ToggleableSection(
                                      title: appLocalization.translate("Unscheduled"),
                                      children: state.getAllTasksResultUnscheduled
                                          .map<Widget>((e) => buildTaskWidget(
                                          e, context, allTasksBloc,globalState))
                                          .toList()):Column(
                                    children: state.getAllTasksResultUnscheduled
                                            .map((e) => buildTaskWidget(
                                                e, context, allTasksBloc,globalState))
                                            .toList(),
                                  ),
                                if (state.getAllTasksResultCompleted.isNotEmpty)
                                  true ? ToggleableSection(
                                      isOpenInStart: false,
                                      title: appLocalization.translate("Completed"),
                                      titleColor: AppColors.success(context.isDarkMode).shade500,
                                      children: state.getAllTasksResultCompleted
                                          .map<Widget>((e) => buildTaskWidget(
                                          e, context, allTasksBloc,globalState))
                                          .toList()):Column(
                                    children: state.getAllTasksResultUnscheduled
                                        .map((e) => buildTaskWidget(
                                        e, context, allTasksBloc,globalState))
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
                      user: BlocProvider.of<AuthBloc>(context).state.user!));
                },);
            },
          );
        },
      ),
    );
  }

  bool isLoading(
      {required AllTasksState state, required GlobalState globalState, required AuthBloc authBloc}) {
    return state.isLoading ||
                      globalState.isLoading ||
                      authBloc.state.isLoading;
  }

  Widget buildTaskWidget(Task task, BuildContext context,
      AllTasksBloc allTasksBloc,GlobalState globalState) {
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
          params: DuplicateTaskParams(
              createTaskParams: params,
              todoTaskStatus: globalState.statuses?.todoStatus),
          workspace:
      BlocProvider.of<GlobalBloc>(context).state.selectedWorkspace!,
    ));
          }, onDeleteConfirmed: () {
      allTasksBloc.add(DeleteTaskEvent(
          params: DeleteTaskParams(
              task: task,
              ),
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
              defaultList: globalState.selectedWorkspace!.defaultList!,
              task: newTask,
              backendMode: serviceLocator<BackendMode>(),
              user: authState.user!,
              workspace: newTask.workspace,
              tags: newTask.tags),
          workspace: globalState.selectedWorkspace!)); },
        );
  }

  void getAllTasksInWorkspace(AllTasksBloc allTasksBloc,BuildContext context) {
    allTasksBloc.add(GetTasksInWorkspaceEvent(
        workspace: BlocProvider.of<GlobalBloc>(context).state.selectedWorkspace!,
        ));
  }
}
