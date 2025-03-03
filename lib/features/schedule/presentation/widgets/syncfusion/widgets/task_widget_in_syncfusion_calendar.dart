import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:thetimeblockingapp/common/enums/backend_mode.dart';
import 'package:thetimeblockingapp/core/extensions.dart';

import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/core/resources/app_icons.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';
import 'package:thetimeblockingapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:thetimeblockingapp/features/global/presentation/bloc/global_bloc.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/widgets/task_widget_in_calendar.dart';
import 'package:thetimeblockingapp/features/tasks/presentation/widgets/tag_chip.dart';

import '../../../../../../common/widgets/custom_alert_dialog.dart';
import '../../../../../../common/widgets/custom_button.dart';
import '../../../../../../common/widgets/custom_pop_up_menu.dart';
import '../../../../../../core/localization/localization.dart';
import '../../../../../task_popup/presentation/views/task_popup.dart';
import '../../../../../tasks/domain/entities/task_parameters.dart';
import '../../../../../tasks/domain/use_cases/delete_task_use_case.dart';

class TaskWidgetInSyncfusionCalendar extends StatelessWidget {
  const TaskWidgetInSyncfusionCalendar({
    super.key,
    required this.task,
    required this.bloc,
    required this.isLoading,
    required this.onDelete,
    required this.onSave,
    required this.onDuplicate,
    required this.onDeleteConfirmed,
    required this.onCompleteConfirmed,
    required this.calendarView,
    required this.bounds,
  });

  final Task task;
  final Bloc<dynamic, dynamic> bloc;
  final bool Function(Object?) isLoading;
  final void Function(DeleteTaskParams) onDelete;
  final void Function(CreateTaskParams) onSave;
  final void Function(CreateTaskParams) onDuplicate;
  final void Function() onCompleteConfirmed;
  final void Function() onDeleteConfirmed;
  final CalendarView? calendarView;
  final Rect bounds;
  @override
  Widget build(BuildContext context) {
    final durationLongerThanDay = task.duration!.inDays >= 1;
    printDebug("task ${task.title} durationLongerThanDay $durationLongerThanDay");
    final authState = BlocProvider.of<AuthBloc>(context).state;
    return TaskWidgetInCalendar(
        task: task,
        taskLocation: durationLongerThanDay? TaskLocation.header : TaskLocation.body,
        onCompleteConfirmed: onCompleteConfirmed,
        onDeleteConfirmed: onDeleteConfirmed,
        onEventTapped: () {
          showTaskPopup(
              context: context,
              taskPopupParams: TaskPopupParams.open(
                  task: task,
                  bloc: bloc,
                  onDelete: onDelete,
                  onSave: onSave,
                  onDuplicate: () {
                    onDuplicate(CreateTaskParams.createNewTask(
                        defaultList: BlocProvider.of<GlobalBloc>(context).state.selectedWorkspace!.defaultList!,
                        list: task.list!,
                        title: task.title ?? "",
                        description: task.description,
                        dueDate: task.dueDate,
                        folder: task.folder,
                        workspace: task.workspace,
                        tags: task.tags,
                        taskPriority: task.priority,
                        startDate: task.startDate,
                        backendMode: serviceLocator<BackendMode>().mode,
                        user: authState.user!));
                    Navigator.pop(context);
                  },
                  isLoading: (state) => isLoading(state)));
        },
        calendarViewType: calendarView?.getCalendarViewType ?? CalendarViewType.day,
        //not sure why bounds.height is not accurate
        heightPerMinute: null,
        onDelete: onDelete,
        onSave: onSave,
        onDuplicate: onDuplicate);
    return _TaskCalendarWidget(
        bounds: bounds,
        calendarView: calendarView,
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
                        ));
                        Navigator.pop(context);
                      },
                      type: CustomButtonType.destructiveFilledLabel),
                  CustomButton.noIcon(
                      type: CustomButtonType.greyTextLabel,
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
              onTap: () => onDuplicate(CreateTaskParams.fromTask(
                    task,
                    serviceLocator<BackendMode>().mode,
                    BlocProvider.of<AuthBloc>(context).state.user!,
                    BlocProvider.of<GlobalBloc>(context).state.selectedWorkspace!.defaultList!,
                  )))
        ],
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
                        defaultList: BlocProvider.of<GlobalBloc>(context).state.selectedWorkspace!.defaultList!,
                        list: task.list!,
                        title: task.title ?? "",
                        description: task.description,
                        dueDate: task.dueDate,
                        folder: task.folder,
                        workspace: task.workspace,
                        tags: task.tags,
                        taskPriority: task.priority,
                        startDate: task.startDate,
                        backendMode: serviceLocator<BackendMode>().mode,
                        user: authState.user!));
                    Navigator.pop(context);
                  },
                  isLoading: (state) => isLoading(state)));
        },
        onDeleteConfirmed: onDeleteConfirmed,
        onCompleteConfirmed: onCompleteConfirmed,
        task: task);
  }
}

class _TaskCalendarWidget extends StatelessWidget {
  const _TaskCalendarWidget(
      {super.key,
      required this.onTap,
      required this.task,
      required this.onDeleteConfirmed,
      required this.onCompleteConfirmed,
      required this.calendarView,
      required this.bounds,
      this.actions});

  final void Function() onTap;
  final void Function() onCompleteConfirmed;
  final void Function() onDeleteConfirmed;
  final Task task;
  final List<CustomPopupItem>? actions;
  final CalendarView? calendarView;
  final Rect bounds;

  bool showList(CalendarView? calendarView) =>
      calendarView == CalendarView.schedule;

  bool showTags(CalendarView? calendarView) =>
      calendarView == CalendarView.schedule;

  bool showTime(CalendarView? calendarView) =>
      calendarView == CalendarView.schedule;

  int maxLines(Rect bounds, CalendarView? calendarView) =>
      (calendarView != CalendarView.schedule && bounds.height > 70) ? 2 : 1;

  bool showCheckIcon(CalendarView? calendarView) =>
      calendarView == CalendarView.schedule || bounds.width > 400;

  bool isDismissible(CalendarView? calendarView) =>
      calendarView == CalendarView.schedule ||
      calendarView == CalendarView.month;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.grey(context.isDarkMode).shade500;
    final dateTextStyle = AppTextStyle.getTextStyle(AppTextStyleParams(
        appFontSize: AppFontSize.paragraphX2Small,
        color: AppColors.grey(context.isDarkMode).shade400,
        appFontWeight: AppFontWeight.semiBold));
    final folderName = task.folder?.name;
    final listName = task.list?.name;
    final isListInsideFolder = folderName?.isNotEmpty == true;
    var taskLocationTextStyle = AppTextStyle.getTextStyle(AppTextStyleParams(
        appFontSize: AppFontSize.paragraphX2Small,
        color: colors,
        appFontWeight: AppFontWeight.medium));
    if (isDismissible(calendarView)) {
      return Dismissible(
        key: Key(task.id.toString()),
        background: Container(
          color: AppColors.success(context.isDarkMode),
          padding: EdgeInsets.all(AppSpacing.xSmall8.value),
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            appLocalization.translate("complete"),
            style: AppTextStyle.getTextStyle(AppTextStyleParams(
                appFontSize: AppFontSize.paragraphSmall,
                color: AppColors.white(false),
                appFontWeight: AppFontWeight.medium)),
          ),
        ),
        secondaryBackground: Container(
          color: AppColors.error(context.isDarkMode),
          padding: EdgeInsets.all(AppSpacing.xSmall8.value),
          alignment: AlignmentDirectional.centerEnd,
          child: Text(
            appLocalization.translate("delete"),
            style: AppTextStyle.getTextStyle(AppTextStyleParams(
                appFontSize: AppFontSize.paragraphSmall,
                color: AppColors.white(false),
                appFontWeight: AppFontWeight.medium)),
          ),
        ),
        confirmDismiss: (dismissDirection) async {
          if (dismissDirection == DismissDirection.endToStart) {
            final res = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return CustomAlertDialog(
                    loading: false,
                    actions: [
                      CustomButton.noIcon(
                          label: appLocalization.translate("delete"),
                          onPressed: () {
                            onDeleteConfirmed();
                            Navigator.pop(context);
                          },
                          type: CustomButtonType.destructiveFilledLabel),
                      CustomButton.noIcon(
                          type: CustomButtonType.greyTextLabel,
                          label: appLocalization.translate("cancel"),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ],
                    content: Text(
                        "${appLocalization.translate("areYouSureDelete")} ${task.title}?"),
                  );
                });
            return res;
          }
          if (task.isCompleted == false &&
              dismissDirection == DismissDirection.startToEnd) {
            final res = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return CustomAlertDialog(
                    loading: false,
                    actions: [
                      CustomButton.noIcon(
                          type: CustomButtonType.greyTextLabel,
                          label: appLocalization.translate("cancel"),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      CustomButton.noIcon(
                          label: appLocalization.translate("complete"),
                          onPressed: () {
                            onCompleteConfirmed();
                            Navigator.pop(context);
                          },
                          type: CustomButtonType.primaryLabel),

                    ],
                    content: Text(
                        "${appLocalization.translate("areYouSureComplete")} ${task.title}?"),
                  );
                });
            return res;
          }
          return null;
        },
        child: buildInkWell(context, isListInsideFolder, folderName,
            taskLocationTextStyle, listName, dateTextStyle),
      );
    }
    return buildInkWell(context, isListInsideFolder, folderName,
        taskLocationTextStyle, listName, dateTextStyle);
  }

  InkWell buildInkWell(
      BuildContext context,
      bool isListInsideFolder,
      String? folderName,
      TextStyle taskLocationTextStyle,
      String? listName,
      TextStyle dateTextStyle) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.xSmall8.value),
        decoration: BoxDecoration(
            color: task.color.withOpacity(0.1),
            border: Border(
                left: BorderSide(
                    color:
                    task.color,width: 1),
                bottom: BorderSide(
                    color:
                        AppColors.grey(context.isDarkMode).withOpacity(0.1)))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showList(calendarView))
              Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.xSmall8.value),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (isListInsideFolder)
                      Text(
                        folderName ?? "",
                        style: taskLocationTextStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (isListInsideFolder)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1.0),
                        child: Text(
                          "/",
                          style: taskLocationTextStyle,
                        ),
                      ),
                    Text(
                      listName ?? '',
                      style: taskLocationTextStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showCheckIcon(calendarView))
                          Icon(
                            task.isCompleted
                                ? AppIcons.checkboxchecked
                                : AppIcons.checkbox,
                            color: task.status?.getColor ??
                                AppColors.text(context.isDarkMode),
                            size: 15,
                          ),
                        if (showCheckIcon(calendarView))
                          SizedBox(
                            width: AppSpacing.x2Small4.value,
                          ),
                        Expanded(
                          child: Text(
                            task.title ?? "",
                            style: AppTextStyle.getTextStyle(AppTextStyleParams(
                                    appFontSize: AppFontSize.paragraphXSmall,
                                    color: AppColors.grey(context.isDarkMode)
                                        .shade900,
                                    appFontWeight: AppFontWeight.semiBold))
                                .copyWith(
                                    decoration: task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null),
                            maxLines: maxLines(bounds, calendarView),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (false && actions?.isNotEmpty == true)
                    CustomPopupMenu(
                      items: actions ?? [],
                    ),
                ],
              ),
            ),
            if (showTime(calendarView) &&
                task.startDate != null &&
                task.dueDate != null)
              Text(
                "🕑 ${DateTimeExtensions.customToString(task.startDate, includeDayMonthYear: false)}"
                    " => ${DateTimeExtensions.customToString(task.dueDate, includeDayMonthYear: false)}",
                style: dateTextStyle,
              )
            else if (showTime(calendarView))
              Text("", style: dateTextStyle),
            if (showTags(calendarView) && task.tags.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: AppSpacing.xSmall8.value),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: AppSpacing.x2Small4.value,
                  runSpacing: AppSpacing.x2Small4.value,
                  direction: Axis.horizontal,
                  verticalDirection: VerticalDirection.down,
                  children: task.tags
                      .map((e) =>
                          TagChip(tagName: e.name ?? "", color: e.getColor))
                      .toList(),
                ),
              )
            else if (showTags(calendarView))
              Padding(
                padding: EdgeInsets.only(top: AppSpacing.xSmall8.value),
                child: Text(''),
              )
          ],
        ),
      ),
    );
  }
}
