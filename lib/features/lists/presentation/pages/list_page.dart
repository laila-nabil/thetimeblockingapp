import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';

import '../../../../common/widgets/responsive/responsive.dart';
import '../../../../common/widgets/responsive/responsive_scaffold.dart';
import '../../../tasks/domain/entities/clickup_list.dart';
import '../bloc/lists_page_bloc.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key, required this.listId});

  static const routeName = "/List";
  static const queryParametersList = ["list"];
  final String listId;

  @override
  Widget build(BuildContext context) {
    final list = Globals.selectedSpace?.lists
        .where((element) => element.id == listId)
        .firstOrNull;
    List<ClickupTask> tasks = [];
    return BlocConsumer<ListsPageBloc, ListsPageState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ResponsiveScaffold(
            responsiveScaffoldLoading: ResponsiveScaffoldLoading(
                responsiveScaffoldLoadingEnum:
                    ResponsiveScaffoldLoadingEnum.contentLoading,
                isLoading: state.isLoading),
            responsiveBody: ResponsiveTParams(
                laptop: ListPageContent(list: list, tasks: tasks),
                mobile: ListPageContent(list: list, tasks: tasks)),
            context: context);
      },
    );
  }
}

class ListPageContent extends StatelessWidget {
  const ListPageContent({Key? key, required this.list, required this.tasks})
      : super(key: key);
  final ClickupList? list;
  final List<ClickupTask> tasks;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(list?.name ?? ""),
        Expanded(
          child: ListView(
            children: tasks
                .map((e) => ListTile(
                      title: Text(e.name ?? ""),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
