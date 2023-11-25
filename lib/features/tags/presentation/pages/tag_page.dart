import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/features/tags/presentation/bloc/tags_page_bloc.dart';

import '../../../../common/widgets/add_item_floating_action_button.dart';
import '../../../../common/widgets/responsive/responsive.dart';
import '../../../../common/widgets/responsive/responsive_scaffold.dart';
import '../../../../core/print_debug.dart';
import '../../../task_popup/presentation/views/task_popup.dart';

class TagPage extends StatelessWidget {
  const TagPage({super.key, required this.tagName, required this.tagsPageBloc});

  static const routeName = "/Tag";
  static const queryParametersList = ["Tag"];
  final String tagName;
  final TagsPageBloc tagsPageBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: tagsPageBloc,
      child: BlocConsumer<TagsPageBloc, TagsPageState>(
        listener: (context, state) {},
        builder: (context, state) {
          final tagsPageBloc = BlocProvider.of<TagsPageBloc>(context);
          printDebug("state.tagsPageStatus rebuild ${state.tagsPageStatus}");
          printDebug("state rebuild $state");
          if (state.tagsPageStatus == TagsPageStatus.navigateTag) {
            tagsPageBloc.add(GetClickupTasksForTagEvent(
                clickupAccessToken: Globals.clickupAuthAccessToken,
                workspace: Globals.selectedWorkspace!,
                tag: state.navigateTag!,
                space: Globals.selectedSpace!));
          }
          return ResponsiveScaffold(
              floatingActionButton: AddItemFloatingActionButton(
                onPressed: () {
                  showTaskPopup(
                      context: context,
                      taskPopupParams: TaskPopupParams.addToTag(
                          tag: state.navigateTag,
                          bloc: tagsPageBloc,
                          onSave: (params) {
                            tagsPageBloc.add(CreateClickupTaskEvent(
                                params: params,
                                workspace: Globals.selectedWorkspace!));
                            Navigator.maybePop(context);
                          },
                          isLoading: (state) => state is! TagsPageState
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
                  Text(state.navigateTag?.name ?? ""),
                  Expanded(
                    child: ListView(
                      children: state.currentTagTasksResult
                              ?.map((e) => ListTile(
                                    title: Text(e.name ?? ""),
                                    onTap: () {
                                      showTaskPopup(
                                          context: context,
                                          taskPopupParams:
                                              TaskPopupParams.openFromList(
                                                  task: e,
                                                  bloc: tagsPageBloc,
                                                  onDelete: (params) {
                                                    tagsPageBloc.add(
                                                        DeleteClickupTaskEvent(
                                                            params: params,
                                                            workspace: Globals
                                                                .selectedWorkspace!));
                                                    Navigator.maybePop(context);
                                                  },
                                                  onSave: (params) {
                                                    tagsPageBloc.add(
                                                        UpdateClickupTaskEvent(
                                                            params: params,
                                                            workspace: Globals
                                                                .selectedWorkspace!));
                                                    Navigator.maybePop(context);
                                                  },
                                                  isLoading: (state) =>
                                                      state is! TagsPageState
                                                          ? false
                                                          : state.isLoading));
                                    },
                                  ))
                              .toList() ??
                          [],
                    ),
                  ),
                ],
              )),
              context: context);
        },
      ),
    );
  }
}
