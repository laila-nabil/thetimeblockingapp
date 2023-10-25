import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive_scaffold.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';

import '../../../../common/widgets/responsive/responsive.dart';
import '../bloc/lists_page_bloc.dart';

class ListsPage extends StatelessWidget {
  const ListsPage({super.key});
  static const routeName = "/Lists";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<ListsPageBloc>(),
      child: BlocConsumer<ListsPageBloc, ListsPageState>(
        listener: (context, state) {},
        builder: (context, state) {
          final listsPageBloc = BlocProvider.of<ListsPageBloc>(context);
          return ResponsiveScaffold(
              responsiveBody: ResponsiveTParams(
                  laptop: ListsPageContent(listsPageBloc: listsPageBloc),
                  mobile: ListsPageContent(listsPageBloc: listsPageBloc)),
              context: context);
        },
      ),
    );
  }
}

class ListsPageContent extends StatelessWidget {
  const ListsPageContent({Key? key, required this.listsPageBloc})
      : super(key: key);
  final ListsPageBloc listsPageBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: listsPageBloc,
      child: BlocConsumer<ListsPageBloc, ListsPageState>(
        listener: (context, state) {},
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
                children: (Globals.selectedSpace?.folders
                    .map((e) =>
                    ExpansionTile(
                      title: Text(e.name ?? ""),
                      children: e.lists?.map((e) =>
                          ExpansionTile(title: Text(e.name ?? "")))
                          .toList() ?? [],))
                    .toList() ??
                    [])+(Globals.selectedSpace?.lists
                    .map((e) =>
                    ExpansionTile(
                        title: Text(e.name ?? "")))
                    .toList() ??
                    [])),
          );
        },
      ),
    );
  }
}