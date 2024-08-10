import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/common/entities/status.dart';
import 'package:thetimeblockingapp/core/extensions.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/core/resources/app_icons.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';
import 'package:thetimeblockingapp/features/tasks/presentation/widgets/tag_chip.dart';

import '../../../../common/widgets/custom_alert_dialog.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_pop_up_menu.dart';
import '../../../../core/localization/localization.dart';
import '../../../task_popup/presentation/views/task_popup.dart';
import '../../domain/entities/task_parameters.dart';
import '../../domain/use_cases/delete_task_use_case.dart';

class TaskComponent extends StatelessWidget {
  const TaskComponent({
    super.key,
    required this.task,
    required this.bloc,
    required this.isLoading,
    required this.onDelete,
    required this.onSave,
    required this.onDuplicate,
    this.showListChip = true,
  });

  final Task task;
  final Bloc<dynamic, dynamic> bloc;
  final bool Function(Object?) isLoading;
  final void Function(DeleteTaskParams) onDelete;
  final void Function(CreateTaskParams) onSave;
  final void Function(CreateTaskParams) onDuplicate;
  final bool showListChip;

  @override
  Widget build(BuildContext context) {
    return TaskWidget(
        actions: [
          CustomPopupItem(
              icon: AppIcons.bin,
              title: appLocalization.translate("delete"),
              alertDialog: CustomAlertDialog(
                loading: false,
                actions: [
                  CustomButton.noIcon(
                      label: appLocalization.translate("delete"),
                      onPressed: () {
                        onDelete(DeleteTaskParams(
                            task: task,
                            accessToken:
                            Globals.accessToken));
                        Navigator.pop(context);
                      },type: CustomButtonType.destructiveFilledLabel),
                  CustomButton.noIcon(
                      label: appLocalization.translate("cancel"),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ],
                content: Text(
                    "${appLocalization.translate("areYouSureDelete")} ${task.title}?"),
              )),
          CustomPopupItem(
              icon: AppIcons.copy,
              title: appLocalization.translate("duplicate"),
              onTap: () => onDuplicate(CreateTaskParams.fromTask(task,Globals.backendMode)))
        ],
        showList: showListChip,
        onTap: () {
          showTaskPopup(
              context: context,
              taskPopupParams: TaskPopupParams.open(
                  task: task,
                  bloc: bloc,
                  onDelete: onDelete,
                  onSave: onSave,
                  onDuplicate: () {
                    onDuplicate(CreateTaskParams.createNewTask(
                      accessToken: Globals.accessToken,
                      list: task.list!,
                      title: task.title ?? "",
                      description: task.description,
                      dueDate: task.dueDateUtc,
                      folder: task.folder,
                      space: task.space,
                      tags: task.tags,
                      taskPriority: task.priority,
                      startDate: task.startDateUtc,
                      backendMode: Globals.backendMode
                    ));
                    Navigator.pop(context);
                  },
                  isLoading: (state) => isLoading(state)));
        },
        task: task);
  }
}

class TaskWidget extends StatefulWidget {
  const TaskWidget(
      {super.key,
      required this.onTap,
      required this.task,
      required this.showList,
      this.actions});

  final void Function() onTap;
  final Task task;
  final bool showList;
  final List<CustomPopupItem>? actions;

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  bool onHover = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.grey(context.isDarkMode).shade500;
    final dateTextStyle = AppTextStyle.getTextStyle(AppTextStyleParams(
        appFontSize: AppFontSize.paragraphX2Small,
        color: AppColors.grey(context.isDarkMode).shade400,
        appFontWeight: AppFontWeight.semiBold));
    final folderName = widget.task.folder?.name;
    final listName = widget.task.list?.name;
    final isListInsideFolder =
        folderName?.isNotEmpty == true;
    return InkWell(
      onTap: widget.onTap,
      onHover: (hover) {
        if (hover != onHover) {
          setState(() {
            onHover = hover;
          });
        }
      },
      child: Container(
        constraints: const BoxConstraints(minHeight: 68),
        padding: EdgeInsets.all(AppSpacing.xSmall8.value),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppBorderRadius.large.value),
          color: onHover
              ? AppColors.primary(context.isDarkMode).shade50.withOpacity(0.5)
              : AppColors.background(context.isDarkMode),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.showList)
              Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.xSmall8.value),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (isListInsideFolder)
                      Text(
                        folderName ?? "",
                        style: AppTextStyle.getTextStyle(AppTextStyleParams(
                            appFontSize: AppFontSize.paragraphXSmall,
                            color: colors,
                            appFontWeight: AppFontWeight.medium)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (isListInsideFolder)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1.0),
                        child: Text(
                          "/",
                          style: AppTextStyle.getTextStyle(AppTextStyleParams(
                              appFontSize: AppFontSize.paragraphXSmall,
                              color: colors,
                              appFontWeight: AppFontWeight.medium)),
                        ),
                      ),
                    Text(
                      listName ?? '',
                      style: AppTextStyle.getTextStyle(AppTextStyleParams(
                          appFontSize: AppFontSize.paragraphXSmall,
                          color: colors,
                          appFontWeight: AppFontWeight.medium)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.xSmall8.value),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          widget.task.status ==
                                  Globals.statuses.completedStatus
                              ? AppIcons.checkboxchecked
                              : AppIcons.checkbox,
                          color: widget.task.status?.getColor ??
                              AppColors.text(context.isDarkMode),
                          size: 20,
                        ),
                        SizedBox(
                          width: AppSpacing.xSmall8.value,
                        ),
                        Expanded(
                          child: Text(
                            widget.task.title ?? "",
                            style: AppTextStyle.getTextStyle(AppTextStyleParams(
                                    appFontSize: AppFontSize.paragraphSmall,
                                    color: AppColors.grey(context.isDarkMode).shade900,
                                    appFontWeight: AppFontWeight.semiBold))
                                .copyWith(
                                    decoration: widget.task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.actions?.isNotEmpty == true)
                  CustomPopupMenu(
                    items: widget.actions ?? [],
                  ),
              ],
            ),
            if (widget.task.startDateUtc != null &&
                widget.task.dueDateUtc != null)
              Text(
                  "🕑 ${DateTimeExtensions.customToString(widget.task.startDateUtc)} => ${DateTimeExtensions.customToString(widget.task.dueDateUtc)}",
                  style: dateTextStyle)
            else
              Text("", style: dateTextStyle),
            Padding(
              padding: EdgeInsets.only(top: AppSpacing.xSmall8.value),
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: AppSpacing.x2Small4.value,
                runSpacing: AppSpacing.x2Small4.value,
                direction: Axis.horizontal,
                verticalDirection: VerticalDirection.down,
                children: widget.task.tags
                        ?.map((e) => TagChip(
                            tagName: e.name ?? "", color: e.getColor))
                        .toList() ??
                    [],
              ),
            )
          ],
        ),
      ),
    );
  }
}
