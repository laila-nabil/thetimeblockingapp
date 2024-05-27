import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/features/task_popup/presentation/views/task_popup.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_clickup_list_and_its_tasks_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/presentation/widgets/task_component.dart';
import 'package:thetimeblockingapp/features/tasks/presentation/widgets/toggleable_section.dart';

import '../../../../common/widgets/add_item_floating_action_button.dart';
import '../../../../common/widgets/responsive/responsive.dart';
import '../../../../common/widgets/responsive/responsive_scaffold.dart';
import '../../../../core/localization/localization.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_design.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../startup/presentation/bloc/startup_bloc.dart';
import '../bloc/lists_page_bloc.dart';

class ListPage extends StatelessWidget {
  const ListPage(
      {super.key, required this.listId, required this.listsPageBloc});

  static const routeName = "/List";
  static const queryParametersList = ["list"];
  final String listId;
  final ListsPageBloc listsPageBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: listsPageBloc,
      child: BlocBuilder<StartupBloc, StartupState>(
        builder: (context, state) {
          final startupBloc = BlocProvider.of<StartupBloc>(context);
          return BlocConsumer<ListsPageBloc, ListsPageState>(
            listener: (context, state) {},
            builder: (context, state) {
              final listsPageBloc = BlocProvider.of<ListsPageBloc>(context);
              printDebug(
                  "state.listsPageStatus rebuild ${state.listsPageStatus}");
              printDebug("state rebuild $state");
              if (state.listsPageStatus == ListsPageStatus.navigateList) {
                listsPageBloc.add(GetListDetailsAndTasksInListEvent(
                    getClickupListAndItsTasksParams:
                        GetClickupListAndItsTasksParams(
                            listId: listId,
                            clickupAccessToken:
                                Globals.clickupAuthAccessToken)));
              }
              return ResponsiveScaffold(
                ///TODO Bulk actions on tasks
                // pageActions: null,
                floatingActionButton: AddItemFloatingActionButton(
                  onPressed: () {
                    showTaskPopup(
                        context: context,
                        taskPopupParams: TaskPopupParams.addToList(
                            list: state.currentList,
                            bloc: listsPageBloc,
                            onSave: (params) {
                              listsPageBloc
                                  .add(CreateClickupTaskEvent(params: params));
                              Navigator.maybePop(context);
                            },
                            isLoading: (state) => state is! ListsPageState
                                ? false
                                : state.isLoading));
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
                                            e, context, listsPageBloc))
                                        .toList()),
                              if (state.getCurrentListTasksUpcoming.isNotEmpty)
                                ToggleableSection(
                                    title:
                                        appLocalization.translate("Upcoming"),
                                    titleColor: AppColors.warning(context.isDarkMode).shade500,
                                    children: state.getCurrentListTasksUpcoming
                                        .map<Widget>((e) => buildTaskWidget(
                                            e, context, listsPageBloc))
                                        .toList()),
                              if (state
                                  .getCurrentListTasksUnscheduled.isNotEmpty)
                                ToggleableSection(
                                    title: appLocalization
                                        .translate("Unscheduled"),
                                    children: state
                                        .getCurrentListTasksUnscheduled
                                        .map<Widget>((e) => buildTaskWidget(
                                            e, context, listsPageBloc))
                                        .toList()),
                              if (state.getCurrentListTasksCompleted.isNotEmpty)
                                ToggleableSection(
                                    title:
                                        appLocalization.translate("Completed"),
                                    titleColor: AppColors.success(context.isDarkMode).shade500,
                                    children: state.getCurrentListTasksCompleted
                                        .map<Widget>((e) => buildTaskWidget(
                                            e, context, listsPageBloc))
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
                  listsPageBloc.add(GetListDetailsAndTasksInListEvent(
                      getClickupListAndItsTasksParams:
                          GetClickupListAndItsTasksParams(
                              listId: listId,
                              clickupAccessToken:
                                  Globals.clickupAuthAccessToken)));
                  startupBloc.add(SelectClickupWorkspaceAndGetSpacesTagsLists(
                      clickupWorkspace: Globals.selectedWorkspace!,
                      clickupAccessToken: Globals.clickupAuthAccessToken));
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget buildTaskWidget(
      ClickupTask e, BuildContext context, ListsPageBloc listsPageBloc) {
    // return Container();
    return TaskComponent(
      clickupTask: e,
      bloc: listsPageBloc,
      showListChip: false,
      isLoading: (state) => state is! ListsPageState ? false : state.isLoading,
      onDelete: (params) {
        listsPageBloc.add(DeleteClickupTaskEvent(params: params));
        Navigator.maybePop(context);
      },
      onSave: (params) {
        listsPageBloc.add(UpdateClickupTaskEvent(params: params));
        Navigator.maybePop(context);
      }, onDuplicate: (params ) {
        listsPageBloc.add(DuplicateClickupTaskEvent(
          params: params,));
    },
    );
  }
}
