import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/extensions.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:thetimeblockingapp/features/tasks/presentation/widgets/list_chip.dart';
import 'package:thetimeblockingapp/features/tasks/presentation/widgets/tag_chip.dart';

import '../../../../core/localization/localization.dart';
import '../../../task_popup/presentation/views/task_popup.dart';
import '../../domain/entities/task_parameters.dart';
import '../../domain/use_cases/delete_clickup_task_use_case.dart';

class TaskComponent extends StatelessWidget {
  const TaskComponent(
      {super.key,
      required this.clickupTask,
      required this.bloc,
      required this.isLoading,
      required this.onDelete,
      required this.onSave,
      this.showList = true});

  final ClickupTask clickupTask;
  final Bloc<dynamic, dynamic> bloc;
  final bool Function(Object?) isLoading;
  final void Function(DeleteClickupTaskParams) onDelete;
  final void Function(ClickupTaskParams) onSave;
  final bool showList;

  @override
  Widget build(BuildContext context) {
    return TaskWidget(
        showList: showList,
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
      required this.showList});

  final void Function() onTap;
  final ClickupTask clickupTask;
  final bool showList;

  @override
  Widget build(BuildContext context) {
    final dateTextStyle = AppTextStyle.getTextStyle(AppTextStyleParams(
        appFontSize: AppFontSize.paragraphX2Small,
        color: AppColors.grey.shade400,
        appFontWeight: AppFontWeight.semiBold));
    return Container(
      constraints: const BoxConstraints(minHeight: 68),
      padding: EdgeInsets.all(AppSpacing.xSmall.value),
      decoration: BoxDecoration(
        color: AppColors.background,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.xSmall.value),
            child: Text(
              clickupTask.name ?? "",
              style: AppTextStyle.getTextStyle(AppTextStyleParams(
                  appFontSize: AppFontSize.paragraphSmall,
                  color: AppColors.grey.shade900,
                  appFontWeight: AppFontWeight.semiBold)),
            ),
          ),
          if (clickupTask.startDateUtc != null &&
              clickupTask.dueDateUtc != null)
            Text(
                "🕑 ${DateTimeExtensions.customToString(clickupTask.startDateUtc)} => ${DateTimeExtensions.customToString(clickupTask.dueDateUtc)}",
                style: dateTextStyle)
          else
            Text("", style: dateTextStyle),
          Padding(
            padding: EdgeInsets.only(top: AppSpacing.xSmall.value),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: AppSpacing.x2Small.value,
                    runSpacing: AppSpacing.x2Small.value,
                    direction: Axis.horizontal,
                    verticalDirection: VerticalDirection.down,
                    children: clickupTask.tags
                            ?.map((e) => TagChip(
                                tagName: e.name ?? "", color: e.getTagFgColor))
                            .toList() ??
                        [],
                  ),
                ),
                SizedBox(
                  width: AppSpacing.small.value,
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
    );
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            IconButton(onPressed: onTap, icon: const Icon(Icons.more_horiz))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(clickupTask.status?.status ?? "",
                  style: TextStyle(
                      textBaseline: TextBaseline.alphabetic,
                      color: clickupTask.status?.getColor)),
            ),
            if (Globals.selectedSpace?.isPrioritiesEnabled == true)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text((clickupTask.priority?.isNum == true
                        ? clickupTask.priority?.priorityNum.toString()
                        : clickupTask.priority?.priority.toString()) ??
                    ""),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(clickupTask.name ?? ""),
            ),
          ],
        ),
        Text(clickupTask.description ?? ""),
        Text(
            "${clickupTask.folder?.name ?? ""}/${clickupTask.list?.name ?? ""}"),
        Text(
            "${clickupTask.startDateUtc.toString()} to ${clickupTask.dueDateUtc.toString()}"),
        Text(
            "${clickupTask.tags?.map((e) => e.name) ?? appLocalization.translate("tags")}"),
      ],
    );
  }
}
