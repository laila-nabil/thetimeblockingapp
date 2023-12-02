import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/task_popup/presentation/views/task_popup.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_clickup_list_and_its_tasks_use_case.dart';

import '../../../../common/widgets/add_item_floating_action_button.dart';
import '../../../../common/widgets/responsive/responsive.dart';
import '../../../../common/widgets/responsive/responsive_scaffold.dart';
import '../../../../core/localization/localization.dart';
import '../bloc/lists_page_bloc.dart';

///TODO V1 have task widget & with details about status,priority,list,tags,due date ,start date viewed

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
      child: BlocConsumer<ListsPageBloc, ListsPageState>(
        listener: (context, state) {},
        builder: (context, state) {
          final listsPageBloc = BlocProvider.of<ListsPageBloc>(context);
          printDebug("state.listsPageStatus rebuild ${state.listsPageStatus}");
          printDebug("state rebuild $state");
          if (state.listsPageStatus == ListsPageStatus.navigateList) {
            listsPageBloc.add(GetListDetailsAndTasksInListEvent(
                getClickupListAndItsTasksParams:
                    GetClickupListAndItsTasksParams(
                        listId: listId,
                        clickupAccessToken: Globals.clickupAuthAccessToken)));
          }
          return ResponsiveScaffold(
              ///TODO V2 select multiple tasks to perform bulk actions
              ///TODO V2 bulk move tasks to another list
              ///TODO V2 bulk delete tasks
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
                  mobile: Column(
                children: [
                  Text(state.currentList?.name ?? ""),
                  Expanded(
                    child: ListView(
                      children: [
                        if (state.getCurrentListTasksOverdue.isNotEmpty)
                          Text(appLocalization.translate("Overdue")),
                        if (state.getCurrentListTasksOverdue.isNotEmpty)
                          Column(
                            children: state.getCurrentListTasksOverdue
                                    .map((e) => buildTaskWidget(
                                        e, context, listsPageBloc))
                                    .toList(),
                          ),
                        if (state.getCurrentListTasksUpcoming.isNotEmpty)
                          Text(appLocalization.translate("Upcoming")),
                        if (state.getCurrentListTasksUpcoming.isNotEmpty)
                          Column(
                            children: state.getCurrentListTasksUpcoming
                                    .map((e) => buildTaskWidget(
                                        e, context, listsPageBloc))
                                    .toList(),
                          ),
                        if (state.getCurrentListTasksUnscheduled.isNotEmpty)
                          Text(appLocalization.translate("Unscheduled")),
                        if (state.getCurrentListTasksUnscheduled.isNotEmpty)
                          Column(
                            children: state.getCurrentListTasksUnscheduled
                                    .map((e) => buildTaskWidget(
                                        e, context, listsPageBloc))
                                    .toList(),
                          ),
                      ],
                    ),
                  ),
                ],
              )),
              context: context);
        },
      ),
    );
  }

  ListTile buildTaskWidget(
      ClickupTask e, BuildContext context, ListsPageBloc listsPageBloc) {
    return ListTile(
      title: Text(e.name ?? ""),
      onTap: () {
        showTaskPopup(
            context: context,
            taskPopupParams: TaskPopupParams.open(
                task: e,
                bloc: listsPageBloc,
                onDelete: (params) {
                  listsPageBloc.add(DeleteClickupTaskEvent(params: params));
                  Navigator.maybePop(context);
                },
                onSave: (params) {
                  listsPageBloc.add(UpdateClickupTaskEvent(params: params));
                  Navigator.maybePop(context);
                },
                isLoading: (state) =>
                    state is! ListsPageState ? false : state.isLoading));
      },
    );
  }
}
