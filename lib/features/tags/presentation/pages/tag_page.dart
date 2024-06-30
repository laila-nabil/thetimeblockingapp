import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/features/tags/presentation/bloc/tags_page_bloc.dart';
import 'package:thetimeblockingapp/features/tasks/presentation/widgets/task_component.dart';

import '../../../../common/widgets/add_item_floating_action_button.dart';
import '../../../../common/widgets/custom_pop_up_menu.dart';
import '../../../../common/widgets/custom_text_input_field.dart';
import '../../../../common/widgets/responsive/responsive.dart';
import '../../../../common/widgets/responsive/responsive_scaffold.dart';
import '../../../../core/localization/localization.dart';
import '../../../../core/print_debug.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_design.dart';
import '../../../../core/resources/app_icons.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../startup/presentation/bloc/startup_bloc.dart';
import '../../../task_popup/presentation/views/task_popup.dart';
import '../../../tasks/domain/use_cases/delete_clickup_tag_use_case.dart';
import '../../../tasks/domain/use_cases/update_clickup_tag_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';

import '../../../tasks/presentation/widgets/toggleable_section.dart';

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
      child: BlocBuilder<StartupBloc, StartupState>(
        builder: (context, state) {
          final startupBloc = BlocProvider.of<StartupBloc>(context);
          return BlocConsumer<TagsPageBloc, TagsPageState>(
            listener: (context, state) {
              printDebug(
                  "listener state.updateTagResult ${state.updateTagResult}");
              if (state.tagsPageStatus == TagsPageStatus.refreshTag) {
                context.go(
                    Uri(path: TagPage.routeName, queryParameters: {
                      TagPage.queryParametersList.first:
                          state.updateTagResult?.name ?? ""
                    }).toString(),
                    extra: tagsPageBloc);
              }
            },
            builder: (context, state) {
              final tagsPageBloc = BlocProvider.of<TagsPageBloc>(context);
              printDebug(
                  "state.tagsPageStatus rebuild ${state.tagsPageStatus}");
              printDebug("state rebuild $state");
              if (state.tagsPageStatus == TagsPageStatus.updateTagSuccess &&
                  state.updateTagResult != null) {
                tagsPageBloc.add(NavigateToTagPageEvent(
                    tag: state.updateTagResult!, insideTagPage: true));
              } else if (state.tagsPageStatus == TagsPageStatus.navigateTag) {
                tagsPageBloc.add(GetClickupTasksForTagEvent(
                    clickupAccessToken: Globals.clickupGlobals!.clickupAuthAccessToken,
                    workspace: Globals.clickupGlobals!.selectedWorkspace!,
                    tag: state.navigateTag!,
                    space: Globals.clickupGlobals!.selectedSpace!));
              }
              return ResponsiveScaffold(
                ///TODO Bulk actions on tasks
                pageActions: [
                  CustomPopupItem.custom(
                      onTap: () {
                        tagsPageBloc.add(UpdateClickupTagEvent.tryUpdate(
                            insideTagPage: true,
                            params: UpdateClickupTagParams(
                                space: Globals.clickupGlobals!.selectedSpace!,
                                newTag: state.navigateTag!.getModel,
                                originalTagName: state.navigateTag!.name ?? "",
                                clickupAccessToken:
                                    Globals.clickupGlobals!.clickupAuthAccessToken)));
                      },
                      titleWidget: Row(
                        children: [
                          const Icon(Icons.edit),
                          Text(appLocalization.translate("edit")),
                        ],
                      )),
                  CustomPopupItem.custom(
                      onTap: () {
                        tagsPageBloc.add(DeleteClickupTagEvent.tryDelete(
                            DeleteClickupTagParams(
                                space: Globals.clickupGlobals!.selectedSpace!,
                                tag: state.navigateTag!,
                                clickupAccessToken:
                                    Globals.clickupGlobals!.clickupAuthAccessToken)));
                      },
                      titleWidget: Row(
                        children: [
                          const Icon(AppIcons.bin),
                          Text(appLocalization.translate("delete")),
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
                                  workspace: Globals.clickupGlobals!.selectedWorkspace!));
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
                    small: Padding(
                  padding: EdgeInsets.all(AppSpacing.medium16.value),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(AppSpacing.medium16.value),
                        margin:
                            EdgeInsets.only(bottom: AppSpacing.medium16.value),
                        child: state.updateTagTry(state.navigateTag!)
                            ? Expanded(
                                child: _CreateEditField(
                                    text: state.navigateTag!.name,
                                    onAdd: (text) {
                                      printDebug("text now $text");
                                      tagsPageBloc
                                          .add(UpdateClickupTagEvent.submit(
                                        insideTagPage: true,
                                        params: UpdateClickupTagParams(
                                            clickupAccessToken:
                                                Globals.clickupGlobals!.clickupAuthAccessToken,
                                            newTag: state.navigateTag!
                                                .copyWith(name: text)
                                                .getModel,
                                            originalTagName:
                                                state.navigateTag!.name ?? "",
                                            space: Globals.clickupGlobals!.selectedSpace!),
                                      ));
                                    },
                                    onCancel: () {
                                      tagsPageBloc.add(
                                          UpdateClickupTagEvent.cancel(
                                              insideTagPage: true));
                                    }),
                              )
                            : Text(
                                state.navigateTag?.name ?? "",
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
                            if (state
                                .getCurrentTagTasksResultOverdue.isNotEmpty)
                              ToggleableSection(
                                  title: appLocalization.translate("Overdue"),
                                  titleColor: AppColors.error(context.isDarkMode).shade500,
                                  children: state
                                      .getCurrentTagTasksResultOverdue
                                      .map<Widget>((e) => buildTaskWidget(
                                          e, context, tagsPageBloc))
                                      .toList()),
                            if (state
                                .getCurrentTagTasksResultUpcoming.isNotEmpty)
                              ToggleableSection(
                                  title: appLocalization.translate("Upcoming"),
                                  titleColor: AppColors.warning(context.isDarkMode).shade500,
                                  children: state
                                      .getCurrentTagTasksResultUpcoming
                                      .map<Widget>((e) => buildTaskWidget(
                                          e, context, tagsPageBloc))
                                      .toList()),
                            if (state
                                .getCurrentTagTasksResultUnscheduled.isNotEmpty)
                              ToggleableSection(
                                  title:
                                      appLocalization.translate("Unscheduled"),
                                  children: state
                                      .getCurrentTagTasksResultUnscheduled
                                      .map<Widget>((e) => buildTaskWidget(
                                          e, context, tagsPageBloc))
                                      .toList()),
                            if (state
                                .getCurrentTagTasksResultCompleted.isNotEmpty)
                              ToggleableSection(
                                  title: appLocalization.translate("Completed"),
                                  titleColor: AppColors.success(context.isDarkMode).shade500,
                                  children: state
                                      .getCurrentTagTasksResultCompleted
                                      .map<Widget>((e) => buildTaskWidget(
                                          e, context, tagsPageBloc))
                                      .toList()),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
                context: context,
                onRefresh: () async {
                  tagsPageBloc.add(GetClickupTasksForTagEvent(
                      clickupAccessToken: Globals.clickupGlobals!.clickupAuthAccessToken,
                      workspace: Globals.clickupGlobals!.selectedWorkspace!,
                      tag: state.navigateTag!,
                      space: Globals.clickupGlobals!.selectedSpace!));
                  startupBloc.add(SelectClickupWorkspaceAndGetSpacesTagsLists(
                      clickupWorkspace: Globals.clickupGlobals!.selectedWorkspace!,
                      clickupAccessToken: Globals.clickupGlobals!.clickupAuthAccessToken));
                },
              );
            },
          );
        },
      ),
    );
  }

  StatelessWidget buildTaskWidget(
      ClickupTask e, BuildContext context, TagsPageBloc tagsPageBloc) {
    return TaskComponent(
      clickupTask: e,
      bloc: tagsPageBloc,
      isLoading: (state) => state is! TagsPageState ? false : state.isLoading,
      onDelete: (params) {
        tagsPageBloc.add(DeleteClickupTaskEvent(
            params: params, workspace: Globals.clickupGlobals!.selectedWorkspace!));
        Navigator.maybePop(context);
      },
      onSave: (params) {
        tagsPageBloc.add(UpdateClickupTaskEvent(
            params: params, workspace: Globals.clickupGlobals!.selectedWorkspace!));
        Navigator.maybePop(context);
      }, onDuplicate: (params ) {
      tagsPageBloc.add(DuplicateClickupTaskEvent(
          params: params, workspace: Globals.clickupGlobals!.selectedWorkspace!));
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
            child: CustomTextInputField(
          focusNode: FocusNode(),
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
