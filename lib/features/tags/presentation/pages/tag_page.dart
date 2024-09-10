import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:thetimeblockingapp/features/tags/presentation/bloc/tags_page_bloc.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_tasks_in_single_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/presentation/widgets/task_component.dart';

import '../../../../common/enums/backend_mode.dart';
import '../../../../common/widgets/add_item_floating_action_button.dart';
import '../../../../common/widgets/custom_pop_up_menu.dart';
import '../../../../common/widgets/custom_text_input_field.dart';
import '../../../../common/widgets/responsive/responsive.dart';
import '../../../../common/widgets/responsive/responsive_scaffold.dart';
import '../../../../core/injection_container.dart';
import '../../../../core/localization/localization.dart';
import '../../../../core/print_debug.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_design.dart';
import '../../../../core/resources/app_icons.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../global/presentation/bloc/global_bloc.dart';
import '../../../task_popup/presentation/views/task_popup.dart';
import '../../../tasks/domain/use_cases/delete_tag_use_case.dart';
import '../../../tasks/domain/use_cases/update_tag_use_case.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';

import '../../../tasks/presentation/widgets/toggleable_section.dart';

///TODO A fix tasks not viewed

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
      child: BlocBuilder<GlobalBloc, GlobalState>(
        builder: (context, state) {
          final globalBloc = BlocProvider.of<GlobalBloc>(context);
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
              final authBloc = BlocProvider.of<AuthBloc>(context);
              printDebug(
                  "state.tagsPageStatus rebuild ${state.tagsPageStatus}");
              printDebug("state rebuild $state");
              if (state.tagsPageStatus == TagsPageStatus.updateTagSuccess &&
                  state.updateTagResult != null) {
                tagsPageBloc.add(NavigateToTagPageEvent(
                    tag: state.updateTagResult!, insideTagPage: true));
              } else if (state.tagsPageStatus == TagsPageStatus.navigateTag) {
                tagsPageBloc.add(GetTasksForTagEvent(
                    accessToken: authBloc.state.accessToken!,
                    workspace: BlocProvider.of<GlobalBloc>(context).state.selectedWorkspace!,
                    tag: state.navigateTag!,
                    space: BlocProvider.of<GlobalBloc>(context).state.selectedSpace!));
              }
              return ResponsiveScaffold(
                ///TODO Z Bulk actions on tasks
                pageActions: [
                  CustomPopupItem.custom(
                      onTap: () {
                        tagsPageBloc.add(UpdateTagEvent.tryUpdate(
                            insideTagPage: true,
                            params: UpdateTagParams(
                                workspace: BlocProvider.of<GlobalBloc>(context).state.selectedWorkspace!,
                                newTag: state.navigateTag!.getModel,
                                user: authBloc.state.user!,
                                accessToken:
                                    authBloc.state.accessToken!)));
                      },
                      titleWidget: Row(
                        children: [
                          const Icon(Icons.edit),
                          Text(appLocalization.translate("edit")),
                        ],
                      )),
                  CustomPopupItem.custom(
                      onTap: () {
                        tagsPageBloc.add(DeleteTagEvent.tryDelete(
                            DeleteTagParams(
                                workspace: BlocProvider.of<GlobalBloc>(context).state.selectedWorkspace!,
                                tag: state.navigateTag!,
                                accessToken:
                                    authBloc.state.accessToken!)));
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
                              tagsPageBloc.add(CreateTaskEvent(
                                  params: params,
                                  workspace: BlocProvider.of<GlobalBloc>(context).state.selectedWorkspace!));
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
                                          .add(UpdateTagEvent.submit(
                                        insideTagPage: true,
                                        params: UpdateTagParams(
                                            accessToken:
                                                authBloc.state.accessToken!,
                                            newTag: state.navigateTag!
                                                .copyWith(name: text)
                                                .getModel,
                                            user: authBloc.state.user!,
                                            workspace: BlocProvider.of<GlobalBloc>(context).state.selectedWorkspace!),
                                      ));
                                    },
                                    onCancel: () {
                                      tagsPageBloc.add(
                                          UpdateTagEvent.cancel(
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
                  tagsPageBloc.add(GetTasksForTagEvent(
                      accessToken: authBloc.state.accessToken!,
                      workspace: BlocProvider.of<GlobalBloc>(context).state.selectedWorkspace!,
                      tag: state.navigateTag!,
                      space: BlocProvider.of<GlobalBloc>(context).state.selectedSpace!));
                  globalBloc.add(GetAllInWorkspaceEvent(
                      workspace: BlocProvider.of<GlobalBloc>(context).state.selectedWorkspace!,
                      accessToken: authBloc.state.accessToken!));
                },
              );
            },
          );
        },
      ),
    );
  }

  StatelessWidget buildTaskWidget(
      Task e, BuildContext context, TagsPageBloc tagsPageBloc) {
    return TaskComponent(
      task: e,
      bloc: tagsPageBloc,
      isLoading: (state) => state is! TagsPageState ? false : state.isLoading,
      onDelete: (params) {
        tagsPageBloc.add(DeleteTaskEvent(
            params: params, workspace: BlocProvider.of<GlobalBloc>(context).state.selectedWorkspace!));
        Navigator.maybePop(context);
      },
      onSave: (params) {
        tagsPageBloc.add(UpdateTaskEvent(
            params: params, workspace: BlocProvider.of<GlobalBloc>(context).state.selectedWorkspace!));
        Navigator.maybePop(context);
      }, onDuplicate: (params ) {
      tagsPageBloc.add(DuplicateTaskEvent(
            params: params,
            workspace:
                BlocProvider.of<GlobalBloc>(context).state.selectedWorkspace!,
            ));
      },
      onDeleteConfirmed: () {
        //TODO B
      },
      onCompleteConfirmed: () {
        //TODO B
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
