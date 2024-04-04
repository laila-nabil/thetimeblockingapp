import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/extensions.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/core/resources/app_icons.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:thetimeblockingapp/features/tasks/presentation/widgets/list_chip.dart';
import 'package:thetimeblockingapp/features/tasks/presentation/widgets/tag_chip.dart';

import '../../../../common/widgets/custom_alert_dialog.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_pop_up_menu.dart';
import '../../../../core/localization/localization.dart';
import '../../../../core/resources/assets_paths.dart';
import '../../../task_popup/presentation/views/task_popup.dart';
import '../../domain/entities/task_parameters.dart';
import '../../domain/use_cases/delete_clickup_task_use_case.dart';

class TaskComponent extends StatelessWidget {
  const TaskComponent({
    super.key,
    required this.clickupTask,
    required this.bloc,
    required this.isLoading,
    required this.onDelete,
    required this.onSave,
    this.showListChip = true,
  });

  final ClickupTask clickupTask;
  final Bloc<dynamic, dynamic> bloc;
  final bool Function(Object?) isLoading;
  final void Function(DeleteClickupTaskParams) onDelete;
  final void Function(ClickupTaskParams) onSave;
  final bool showListChip;

  @override
  Widget build(BuildContext context) {
    return TaskWidget(
        actions: [
          CustomPopupItem.text(
              title: appLocalization.translate("delete"),
              onTap: () {
                //showDialog is not shown on PopupMenuItem tap
                //
                // That's because onTap of popupMenuItem tries to use Navigator.pop
                // to close the popup but at same time you are trying to show the dialog,
                // So it closes the dialog and leaves the popup so, you can wait till
                // the all the animations or ongoing things complete then show dialog

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return CustomAlertDialog(
                          loading: false,
                          actions: [
                            CustomButton.noIcon(
                                label: appLocalization.translate("delete"),
                                onPressed: () {
                                  onDelete(DeleteClickupTaskParams(
                                      task: clickupTask,
                                      clickupAccessToken:
                                          Globals.clickupAuthAccessToken));
                                  Navigator.pop(ctx);
                                }),
                            CustomButton.noIcon(
                                label: appLocalization.translate("cancel"),
                                onPressed: () {
                                  Navigator.pop(ctx);
                                }),
                          ],
                          content: Text(
                              "${appLocalization.translate("areYouSureDelete")} ${clickupTask.name}?"),
                        );
                      });
                });
              })
        ],
        showList: showListChip,
        onTap: () {
          showTaskPopup(
              context: context,
              taskPopupParams: TaskPopupParams.open(
                  task: clickupTask,
                  bloc: bloc,
                  onDelete: onDelete,
                  onSave: onSave,
                  isLoading: (state) => isLoading(state)));
        },
        clickupTask: clickupTask);
  }
}

class TaskWidget extends StatefulWidget {
  const TaskWidget(
      {super.key,
      required this.onTap,
      required this.clickupTask,
      required this.showList,
      this.actions});

  final void Function() onTap;
  final ClickupTask clickupTask;
  final bool showList;
  final List<CustomPopupItem>? actions;

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  bool onHover = false;
  static const iconSize = 12.0;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.grey(context.isDarkMode).shade500;
    final dateTextStyle = AppTextStyle.getTextStyle(AppTextStyleParams(
        appFontSize: AppFontSize.paragraphX2Small,
        color: AppColors.grey(context.isDarkMode).shade400,
        appFontWeight: AppFontWeight.semiBold));
    final folderName = widget.clickupTask.folder?.name;
    final listName = widget.clickupTask.list?.name;
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
                          widget.clickupTask.status ==
                                  Globals.selectedSpace?.statuses?.last
                              ? AppIcons.checkboxchecked
                              : AppIcons.checkbox,
                          color: widget.clickupTask.status?.getColor ??
                              AppColors.text(context.isDarkMode),
                          size: 20,
                        ),
                        SizedBox(
                          width: AppSpacing.xSmall8.value,
                        ),
                        Expanded(
                          child: Text(
                            widget.clickupTask.name ?? "",
                            style: AppTextStyle.getTextStyle(AppTextStyleParams(
                                    appFontSize: AppFontSize.paragraphSmall,
                                    color: AppColors.grey(context.isDarkMode).shade900,
                                    appFontWeight: AppFontWeight.semiBold))
                                .copyWith(
                                    decoration: widget.clickupTask.isCompleted
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
            if (widget.clickupTask.startDateUtc != null &&
                widget.clickupTask.dueDateUtc != null)
              Text(
                  "🕑 ${DateTimeExtensions.customToString(widget.clickupTask.startDateUtc)} => ${DateTimeExtensions.customToString(widget.clickupTask.dueDateUtc)}",
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
                children: widget.clickupTask.tags
                        ?.map((e) => TagChip(
                            tagName: e.name ?? "", color: e.getTagFgColor))
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
