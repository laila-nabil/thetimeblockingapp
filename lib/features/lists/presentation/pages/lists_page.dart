import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive_scaffold.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/features/lists/presentation/pages/list_page.dart';

import '../../../../common/widgets/responsive/responsive.dart';
import '../../../../core/localization/localization.dart';
import '../../../startup/presentation/bloc/startup_bloc.dart';
import '../../../tasks/domain/entities/clickup_space.dart';
import '../bloc/lists_page_bloc.dart';

class ListsPage extends StatelessWidget {
  const ListsPage({super.key});

  static const routeName = "/Lists";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<ListsPageBloc>(),
      child: BlocBuilder<StartupBloc, StartupState>(
          builder: (context, startupState) {
        return BlocConsumer<ListsPageBloc, ListsPageState>(
          listener: (context, state) {
            final listsPageBloc = BlocProvider.of<ListsPageBloc>(context);
            if (state.listsPageStatus == ListsPageStatus.navigateList &&
                state.navigateList != null) {
              context.push(Uri(path: ListPage.routeName, queryParameters: {
                ListPage.queryParametersList.first: state.navigateList?.id ?? ""
              }).toString(),extra: listsPageBloc);
            }
          },
          builder: (context, state) {
            final listsPageBloc = BlocProvider.of<ListsPageBloc>(context);
            final startupBloc = BlocProvider.of<StartupBloc>(context);
            return ResponsiveScaffold(
                responsiveScaffoldLoading: ResponsiveScaffoldLoading(
                    responsiveScaffoldLoadingEnum:
                        ResponsiveScaffoldLoadingEnum.contentLoading,
                    isLoading: state.isLoading || startupState.isLoading),
                responsiveBody: ResponsiveTParams(
                    mobile: BlocConsumer<ListsPageBloc, ListsPageState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        if (state.isInit && Globals.isSpaceAppWide) {
                          listsPageBloc.add(GetListAndFoldersInListsPageEvent.inWorkSpace(
                            clickupAccessToken: Globals.clickupAuthAccessToken,
                            clickupWorkspace: Globals.selectedWorkspace!,
                          ));
                        }
                        return SingleChildScrollView(
                          child: Column(
                              children: <Widget>[
                                if (Globals.isSpaceAppWide == false &&
                                    Globals.clickupSpaces?.isNotEmpty == true)
                                  DropdownButton<ClickupSpace?>(
                                    value: Globals.selectedSpace,
                                    onChanged: (selected) {
                                      if (selected != null && state.isLoading == false) {
                                        startupBloc.add(SelectClickupSpace(
                                            clickupSpace: selected,
                                            clickupAccessToken:
                                            Globals.clickupAuthAccessToken));
                                        listsPageBloc.add(
                                            GetListAndFoldersInListsPageEvent.inSpace(
                                                clickupAccessToken:
                                                Globals.clickupAuthAccessToken,
                                                clickupWorkspace:
                                                Globals.selectedWorkspace!,
                                                clickupSpace: selected));
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
                              ] +
                                  (Globals.selectedSpace?.folders
                                      .map((e) => ExpansionTile(
                                    title: Text(e.name ?? ""),
                                    children: e.lists
                                        ?.map((e) => ListTile(
                                        onTap: () {
                                          listsPageBloc.add(NavigateToListPageEvent(e));
                                        },
                                        title: Text(e.name ?? "")))
                                        .toList() ??
                                        [],
                                  ))
                                      .toList() ??
                                      []) +
                                  (Globals.selectedSpace?.lists
                                      .map((e) => ListTile(
                                      onTap: () {
                                        listsPageBloc.add(NavigateToListPageEvent(e));
                                      },
                                      title: Text(e.name ?? "")))
                                      .toList() ??
                                      [])),
                        );
                      },
                    )),
                context: context);
          },
        );
      }),
    );
  }
}
