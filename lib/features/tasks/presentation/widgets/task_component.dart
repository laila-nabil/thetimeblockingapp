import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/extensions.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/core/resources/app_icons.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:thetimeblockingapp/features/tasks/presentation/widgets/list_chip.dart';
import 'package:thetimeblockingapp/features/tasks/presentation/widgets/tag_chip.dart';

import '../../../../common/widgets/custom_drop_down.dart';
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
          CustomDropDownItem.text(
              title: appLocalization.translate("delete"),
              onTap:(){})
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

class TaskWidget extends StatelessWidget {
  const TaskWidget(
      {super.key,
      required this.onTap,
      required this.clickupTask,
      required this.showList,
      this.actions});

  final void Function() onTap;
  final ClickupTask clickupTask;
  final bool showList;
  final List<CustomDropDownItem>? actions;

  @override
  Widget build(BuildContext context) {
    final dateTextStyle = AppTextStyle.getTextStyle(AppTextStyleParams(
        appFontSize: AppFontSize.paragraphX2Small,
        color: AppColors.grey.shade400,
        appFontWeight: AppFontWeight.semiBold));
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 68),
        padding: EdgeInsets.all(AppSpacing.xSmall8.value),
        decoration: BoxDecoration(
          color: AppColors.background,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.xSmall8.value),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        clickupTask.status ==
                            Globals.selectedSpace
                                ?.statuses?.last
                            ? AppIcons.checkboxchecked
                            : AppIcons.checkbox,
                        color: clickupTask.status
                            ?.getColor ??
                            AppColors.text,
                        size: 20,
                      ),
                      SizedBox(width: AppSpacing.xSmall8.value ,),
                      Text(
                        clickupTask.name ?? "",
                        style: AppTextStyle.getTextStyle(AppTextStyleParams(
                            appFontSize: AppFontSize.paragraphSmall,
                            color: AppColors.grey.shade900,
                            appFontWeight: AppFontWeight.semiBold)),
                      ),
                    ],
                  ),
                ),
                if (actions?.isNotEmpty == true)
                  CustomDropDownMenu(
                      items: actions ?? [],
                      listButton: Icon(
                        AppIcons.dotsv,
                        size: 16,
                        color: AppColors.grey.shade500,
                      )),
              ],
            ),
            if (clickupTask.startDateUtc != null &&
                clickupTask.dueDateUtc != null)
              Text(
                  "🕑 ${DateTimeExtensions.customToString(clickupTask.startDateUtc)} => ${DateTimeExtensions.customToString(clickupTask.dueDateUtc)}",
                  style: dateTextStyle)
            else
              Text("", style: dateTextStyle),
            Padding(
              padding: EdgeInsets.only(top: AppSpacing.xSmall8.value),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      spacing: AppSpacing.x2Small4.value,
                      runSpacing: AppSpacing.x2Small4.value,
                      direction: Axis.horizontal,
                      verticalDirection: VerticalDirection.down,
                      children: clickupTask.tags
                          ?.map((e) => TagChip(
                          tagName: e.name ?? "",
                          color: e.getTagFgColor))
                          .toList() ??
                          [],
                    ),
                  ),
                  SizedBox(
                    width: AppSpacing.small12.value,
                  ),
                  if (showList)
                    ListChip(
                        listName: clickupTask.list?.name ?? "",
                        folderName: clickupTask.folder?.name ?? "")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
