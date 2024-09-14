import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/common/entities/status.dart';
import 'package:thetimeblockingapp/common/entities/tasks_list.dart';
import 'package:thetimeblockingapp/common/enums/backend_mode.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';

import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/features/task_popup/presentation/views/task_popup.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task_parameters.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_tasks_in_single_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/presentation/widgets/task_component.dart';
import 'package:thetimeblockingapp/features/tasks/presentation/widgets/toggleable_section.dart';

import '../../../../common/widgets/add_item_floating_action_button.dart';
import '../../../../common/widgets/responsive/responsive.dart';
import '../../../../common/widgets/responsive/responsive_scaffold.dart';
import '../../../../core/localization/localization.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_design.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../global/presentation/bloc/global_bloc.dart';
import '../bloc/lists_page_bloc.dart';


class ListPage extends StatelessWidget {
  const ListPage(
      {super.key, required this.list, required this.listsPageBloc});

  static const routeName = "/List";
  final TasksList list;
  final ListsPageBloc listsPageBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: listsPageBloc,
      child: BlocBuilder<GlobalBloc, GlobalState>(
        builder: (context, state) {
          final globalBloc = BlocProvider.of<GlobalBloc>(context);
          return BlocConsumer<ListsPageBloc, ListsPageState>(
            listener: (context, state) {},
            builder: (context, state) {
              final listsPageBloc = BlocProvider.of<ListsPageBloc>(context);
              final authBloc = BlocProvider.of<AuthBloc>(context);
              final globalBloc = BlocProvider.of<GlobalBloc>(context);
              printDebug(
                  "state.listsPageStatus rebuild ${state.listsPageStatus}");
              printDebug("state rebuild $state");
              if (state.listsPageStatus == ListsPageStatus.navigateList) {
                listsPageBloc.add(GetTasksInListEvent(
                    params: GetTasksInWorkspaceParams(
                        workspaceId: globalBloc.state.selectedWorkspace!.id!,
                        filtersParams: GetTasksInWorkspaceFiltersParams(
                            filterByList: list,
                            accessToken: authBloc.state.accessToken!),
                        backendMode: BackendMode.supabase), list: list));
              }
              return ResponsiveScaffold(
                ///TODO D Bulk actions on tasks
                // pageActions: null,
                floatingActionButton: AddItemFloatingActionButton(
                  onPressed: () {
                    showTaskPopup(
                        context: context,
                        taskPopupParams: TaskPopupParams.addToList(
                            list: state.currentList,
                            folder: globalBloc.state.selectedWorkspace?.folders
                                ?.where((f) =>
                                    f.lists?.contains(state.currentList) ==
                                    true)
                                .firstOrNull,
                            bloc: listsPageBloc,
                            onSave: (params) {
                              listsPageBloc.add(CreateTaskEvent(
                                  params: params,
                                  workspaceId:
                                      BlocProvider.of<GlobalBloc>(context)
                                          .state
                                          .selectedWorkspace!
                                          .id!, onSuccess: () {listsPageBloc.add(GetTasksInListEvent(
                                  params: GetTasksInWorkspaceParams(
                                      workspaceId: globalBloc.state.selectedWorkspace!.id!,
                                      filtersParams: GetTasksInWorkspaceFiltersParams(
                                          filterByList: list,
                                          accessToken: authBloc.state.accessToken!),
                                      backendMode: BackendMode.supabase), list: list));  }));
                              Navigator.maybePop(context);
                            },
                            isLoading: (state) => state is! ListsPageState
                                ? false
                                : state.isLoading, space: globalBloc.state.selectedSpace));
                  },
                ),
                responsiveScaffoldLoading: ResponsiveScaffoldLoading(
                    responsiveScaffoldLoadingEnum:
                        ResponsiveScaffoldLoadingEnum.contentLoading,
                    isLoading: state.isLoading),
                responsiveBody: ResponsiveTParams(
                    small: Padding(
                  padding: EdgeInsets.all(AppSpacing.medium16.value),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(AppSpacing.medium16.value),
                        margin:
                            EdgeInsets.only(bottom: AppSpacing.medium16.value),
                        child: Text(
                          state.currentList?.name ?? "",
                          style: AppTextStyle.getTextStyle(AppTextStyleParams(
                              color: AppColors.grey(context.isDarkMode).shade900,
                              appFontWeight: AppFontWeight.medium,
                              appFontSize: AppFontSize.heading4)),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              if (state.getCurrentListTasksOverdue.isNotEmpty)
                                ToggleableSection(
                                    title: appLocalization.translate("Overdue"),
                                    titleColor: AppColors.error(context.isDarkMode).shade500,
                                    children: state.getCurrentListTasksOverdue
                                        .map<Widget>((e) => buildTaskWidget(
                                            e, context, listsPageBloc,globalBloc,authBloc))
                                        .toList()),
                              if (state.getCurrentListTasksUpcoming.isNotEmpty)
                                ToggleableSection(
                                    title:
                                        appLocalization.translate("Upcoming"),
                                    titleColor: AppColors.warning(context.isDarkMode).shade500,
                                    children: state.getCurrentListTasksUpcoming
                                        .map<Widget>((e) => buildTaskWidget(
                                            e, context, listsPageBloc,globalBloc,authBloc))
                                        .toList()),
                              if (state
                                  .getCurrentListTasksUnscheduled.isNotEmpty)
                                ToggleableSection(
                                    title: appLocalization
                                        .translate("Unscheduled"),
                                    children: state
                                        .getCurrentListTasksUnscheduled
                                        .map<Widget>((e) => buildTaskWidget(
                                            e, context, listsPageBloc,globalBloc,authBloc))
                                        .toList()),
                              if (state.getCurrentListTasksCompleted.isNotEmpty)
                                ToggleableSection(
                                    isOpenInStart: false,
                                    title:
                                        appLocalization.translate("Completed"),
                                    titleColor: AppColors.success(context.isDarkMode).shade500,
                                    children: state.getCurrentListTasksCompleted
                                        .map<Widget>((e) => buildTaskWidget(
                                            e, context, listsPageBloc,globalBloc,authBloc))
                                        .toList()),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
                context: context,
                onRefresh: () async {
                  globalBloc.add(
                      GetAllInWorkspaceEvent(
                          accessToken: authBloc.state.accessToken!,
                          workspace: BlocProvider.of<GlobalBloc>(context).state.selectedWorkspace!));
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget buildTaskWidget(
      Task task, BuildContext context, ListsPageBloc listsPageBloc,GlobalBloc globalBloc, AuthBloc authBloc) {
    // return Container();
    return TaskComponent(
      task: task,
      bloc: listsPageBloc,
      showListChip: false,
      isLoading: (state) => state is! ListsPageState ? false : state.isLoading,
      onDelete: (params) {
        listsPageBloc.add(DeleteTaskEvent(params: params, onSuccess: () { listsPageBloc.add(GetTasksInListEvent(
            params: GetTasksInWorkspaceParams(
                workspaceId: globalBloc.state.selectedWorkspace!.id!,
                filtersParams: GetTasksInWorkspaceFiltersParams(
                    filterByList: list,
                    accessToken: authBloc.state.accessToken!),
                backendMode: BackendMode.supabase), list: list)); }));
        Navigator.maybePop(context);
      },
      onSave: (params) {
        listsPageBloc.add(UpdateTaskEvent(params: params, onSuccess: () { listsPageBloc.add(GetTasksInListEvent(
            params: GetTasksInWorkspaceParams(
                workspaceId: globalBloc.state.selectedWorkspace!.id!,
                filtersParams: GetTasksInWorkspaceFiltersParams(
                    filterByList: list,
                    accessToken: authBloc.state.accessToken!),
                backendMode: BackendMode.supabase), list: list)); }));
        Navigator.maybePop(context);
      }, onDuplicate: (params ) {
        listsPageBloc.add(DuplicateTaskEvent(
          params: params,
          workspace: BlocProvider.of<GlobalBloc>(context)
              .state
              .selectedWorkspace!, onSuccess: () { listsPageBloc.add(GetTasksInListEvent(
            params: GetTasksInWorkspaceParams(
                workspaceId: globalBloc.state.selectedWorkspace!.id!,
                filtersParams: GetTasksInWorkspaceFiltersParams(
                    filterByList: list,
                    accessToken: authBloc.state.accessToken!),
                backendMode: BackendMode.supabase), list: list)); },
        ));
      },
      onDeleteConfirmed: () {
        listsPageBloc.add(DeleteTaskEvent(
            params: DeleteTaskParams(task: task, accessToken: authBloc.state.accessToken!),
            onSuccess: () {
              listsPageBloc.add(GetTasksInListEvent(
                  params: GetTasksInWorkspaceParams(
                      workspaceId: globalBloc.state.selectedWorkspace!.id!,
                      filtersParams: GetTasksInWorkspaceFiltersParams(
                          filterByList: list,
                          accessToken: authBloc.state.accessToken!),
                      backendMode: BackendMode.supabase), list: list)); }));
      },
      onCompleteConfirmed: () {
        final newTask = task.copyWith(status: globalBloc.state.statuses!.completedStatus);
        listsPageBloc.add(UpdateTaskEvent(params:  CreateTaskParams.startUpdateTask(
            accessToken: authBloc.state.accessToken!,
            task: newTask,
            backendMode: serviceLocator<BackendMode>(),
            user: authBloc.state.user!,
            space: newTask.space,
            tags: newTask.tags), onSuccess: () { listsPageBloc.add(GetTasksInListEvent(
            params: GetTasksInWorkspaceParams(
                workspaceId: globalBloc.state.selectedWorkspace!.id!,
                filtersParams: GetTasksInWorkspaceFiltersParams(
                    filterByList: list,
                    accessToken: authBloc.state.accessToken!),
                backendMode: BackendMode.supabase), list: list)); }));
      },
    );
  }
}
