import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/task_popup/presentation/views/task_popup.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_clickup_list_and_its_tasks_use_case.dart';

import '../../../../common/widgets/responsive/responsive.dart';
import '../../../../common/widgets/responsive/responsive_scaffold.dart';
import '../../../../core/injection_container.dart';
import '../../../tasks/domain/entities/clickup_list.dart';
import '../bloc/lists_page_bloc.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key, required this.listId, required this.listsPageBloc});

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
              responsiveScaffoldLoading: ResponsiveScaffoldLoading(
                  responsiveScaffoldLoadingEnum:
                      ResponsiveScaffoldLoadingEnum.contentLoading,
                  isLoading: state.isLoading),
              responsiveBody: ResponsiveTParams(
                  laptop: ListPageContent(
                      state: state,
                      list: state.currentList,
                      tasks: state.currentListTasks ?? []),
                  mobile: ListPageContent(
                      state: state,
                      list: state.currentList,
                      tasks: state.currentListTasks ?? [])),
              context: context);
        },
      ),
    );
  }
}

class ListPageContent extends StatelessWidget {
  const ListPageContent({Key? key, required this.list, required this.tasks, required this.state})
      : super(key: key);
  final ClickupList? list;
  final List<ClickupTask> tasks;
  final ListsPageState state;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(state.toString()),
        Text(list?.name ?? ""),
        Expanded(
          child: ListView(
            children: tasks
                .map((e) => ListTile(
                      title: Text(e.name ?? ""),
                      onTap: () {},
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
