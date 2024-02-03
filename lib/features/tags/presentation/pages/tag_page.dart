import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/features/tags/presentation/bloc/tags_page_bloc.dart';
import 'package:thetimeblockingapp/features/tasks/presentation/widgets/task_widget.dart';

import '../../../../common/widgets/add_item_floating_action_button.dart';
import '../../../../common/widgets/custom_drop_down.dart';
import '../../../../common/widgets/custom_text_input_field.dart';
import '../../../../common/widgets/responsive/responsive.dart';
import '../../../../common/widgets/responsive/responsive_scaffold.dart';
import '../../../../core/localization/localization.dart';
import '../../../../core/print_debug.dart';
import '../../../task_popup/presentation/views/task_popup.dart';
import '../../../tasks/domain/use_cases/delete_clickup_tag_use_case.dart';
import '../../../tasks/domain/use_cases/update_clickup_tag_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';



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
        listener: (context, state) {
          printDebug("listener state.updateTagResult ${state.updateTagResult}");
          if (state.tagsPageStatus == TagsPageStatus.refreshTag) {
            context.go(Uri(path: TagPage.routeName, queryParameters: {
              TagPage.queryParametersList.first:
              state.updateTagResult?.name ?? ""
            }).toString(),
                extra: tagsPageBloc);
          }
        },
        builder: (context, state) {
          final tagsPageBloc = BlocProvider.of<TagsPageBloc>(context);
          printDebug("state.tagsPageStatus rebuild ${state.tagsPageStatus}");
          printDebug("state rebuild $state");
          if (state.tagsPageStatus == TagsPageStatus.updateTagSuccess &&
              state.updateTagResult != null) {
            tagsPageBloc.add(NavigateToTagPageEvent(
                tag: state.updateTagResult!, insideTagPage: true));
          }
          else if (state.tagsPageStatus == TagsPageStatus.navigateTag) {
            tagsPageBloc.add(GetClickupTasksForTagEvent(
                clickupAccessToken: Globals.clickupAuthAccessToken,
                workspace: Globals.selectedWorkspace!,
                tag: state.navigateTag!,
                space: Globals.selectedSpace!));
          }
          return ResponsiveScaffold(
              ///TODO V2 select multiple tasks to perform bulk actions
              ///TODO V2 bulk delete tasks
              pageActions: [
                CustomDropDownItem.widget(
                    onTap: () {
                      tagsPageBloc.add(UpdateClickupTagEvent.tryUpdate(
                          insideTagPage: true,
                          params: UpdateClickupTagParams(
                              space: Globals
                                  .selectedSpace!,
                              newTag: state.navigateTag!.getModel,
                              originalTagName: state.navigateTag!.name??"",
                              clickupAccessToken:
                              Globals
                                  .clickupAuthAccessToken)));
                    },
                    titleWidget: Row(
                      children: [
                        const Icon(
                            Icons.edit),
                        Text(appLocalization
                            .translate(
                            "edit")),
                      ],
                    )),
                CustomDropDownItem.widget(
                    onTap: () {
                      tagsPageBloc.add(DeleteClickupTagEvent.tryDelete(
                          DeleteClickupTagParams(
                              space: Globals
                                  .selectedSpace!,
                              tag: state.navigateTag!,
                              clickupAccessToken:
                              Globals
                                  .clickupAuthAccessToken)));
                    },
                    titleWidget: Row(
                      children: [
                        const Icon(
                            Icons.delete),
                        Text(appLocalization
                            .translate(
                            "delete")),
                      ],
                    ))
              ],
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
                  small: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  state.updateTagTry(state.navigateTag!)
                      ? Expanded(
                    child: _CreateEditField(
                        text: state.navigateTag!.name,
                        onAdd: (text) {
                          printDebug("text now $text");
                          tagsPageBloc.add(
                              UpdateClickupTagEvent
                                  .submit(
                                insideTagPage: true,
                                params: UpdateClickupTagParams(
                                    clickupAccessToken:
                                    Globals
                                        .clickupAuthAccessToken,
                                    newTag: state.navigateTag!.copyWith(name: text).getModel,
                                    originalTagName: state.navigateTag!.name??"",
                                    space: Globals
                                        .selectedSpace!),
                              ));
                        },
                        onCancel: () {
                          tagsPageBloc.add(
                              UpdateClickupTagEvent
                                  .cancel(insideTagPage: true));
                        }),
                  )
                      : Text(state.navigateTag?.name ?? ""),
                  Expanded(
                    child: ListView(
                      children: [
                        if(state.getCurrentTagTasksResultOverdue.isNotEmpty)Text(appLocalization.translate("Overdue")),
                        if(state.getCurrentTagTasksResultOverdue.isNotEmpty)Column(
                          children: state.getCurrentTagTasksResultOverdue
                              .map((e) => buildTaskWidget(e, context, tagsPageBloc))
                              .toList(),
                        ),
                        if(state.getCurrentTagTasksResultUpcoming.isNotEmpty)Text(appLocalization.translate("Upcoming")),
                        if(state.getCurrentTagTasksResultUpcoming.isNotEmpty)Column(
                          children: state.getCurrentTagTasksResultUpcoming
                              .map((e) => buildTaskWidget(e, context, tagsPageBloc))
                              .toList(),
                        ),
                        if(state.getCurrentTagTasksResultUnscheduled.isNotEmpty)Text(appLocalization.translate("Unscheduled")),
                        if(state.getCurrentTagTasksResultUnscheduled.isNotEmpty)Column(
                          children: state.getCurrentTagTasksResultUnscheduled
                              .map((e) => buildTaskWidget(e, context, tagsPageBloc))
                              .toList(),
                        ),
                      ],
                    ),
                  )

                ],
              )),
              context: context);
        },
      ),
    );
  }

  StatelessWidget buildTaskWidget(
      ClickupTask e, BuildContext context, TagsPageBloc tagsPageBloc) {
    return TaskWidget(
      clickupTask: e,
      bloc: tagsPageBloc,
      isLoading: (state) => state is! TagsPageState ? false : state.isLoading,
      onDelete: (params) {
        tagsPageBloc.add(DeleteClickupTaskEvent(
            params: params, workspace: Globals.selectedWorkspace!));
        Navigator.maybePop(context);
      },
      onSave: (params) {
        tagsPageBloc.add(UpdateClickupTaskEvent(
            params: params, workspace: Globals.selectedWorkspace!));
        Navigator.maybePop(context);
      },
    );
  }
}

class _CreateEditField extends StatefulWidget {
  const _CreateEditField(
      {required this.onAdd, this.text, required this.onCancel});
  final String? text;
  final void Function(String text) onAdd;
  final void Function() onCancel;

  @override
  State<_CreateEditField> createState() => _CreateEditFieldState();
}

class _CreateEditFieldState extends State<_CreateEditField> {

  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: CustomTextInputField(focusNode: FocusNode(),
              controller: controller,
            )),
        IconButton(icon: const Icon(Icons.cancel), onPressed: widget.onCancel),
        IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                widget.onAdd(controller.text);
              }
            })
      ],
    );
  }
}