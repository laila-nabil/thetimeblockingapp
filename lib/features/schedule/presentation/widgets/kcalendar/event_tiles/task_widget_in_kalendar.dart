import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalender/kalender.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';
import 'package:thetimeblockingapp/common/enums/backend_mode.dart';
import 'package:thetimeblockingapp/common/widgets/custom_alert_dialog.dart';
import 'package:thetimeblockingapp/common/widgets/custom_button.dart';
import 'package:thetimeblockingapp/common/widgets/custom_pop_up_menu.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';
import 'package:thetimeblockingapp/core/extensions.dart' as extensions;
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/core/resources/app_icons.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';
import 'package:thetimeblockingapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:thetimeblockingapp/features/global/presentation/bloc/global_bloc.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/pages/schedule_page.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/widgets/kalendar_tasks_calendar.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task_parameters.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/presentation/widgets/tag_chip.dart';

enum CalendarViewType { day, twoDays, week, multiWeek, month, schedule }

class TaskWidgetInKalendar extends StatelessWidget {
  const TaskWidgetInKalendar({
    super.key,
    required this.event,
    required this.tileType,
    this.drawOutline = false,
    this.continuesBefore = false,
    this.continuesAfter = false,
    this.date,
    required this.onCompleteConfirmed,
    required this.onDeleteConfirmed,
    required this.viewConfiguration,
    required this.heightPerMinute,
    required this.onDelete,
    required this.onSave,
    required this.onDuplicate,
  });

  final CalendarEvent<Task> event;
  final TileType tileType;
  final bool drawOutline;
  final bool continuesBefore;
  final bool continuesAfter;
  final DateTime? date;
  final void Function() onCompleteConfirmed;
  final void Function() onDeleteConfirmed;
  final ViewConfiguration viewConfiguration;
  final double? heightPerMinute;

  final void Function(DeleteTaskParams) onDelete;
  final void Function(CreateTaskParams) onSave;
  final void Function(CreateTaskParams) onDuplicate;

  List<CustomPopupItem> actions(BuildContext context) => [
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
                        task: event.data!,
                      ));
                      Navigator.pop(context);
                    },
                    type: CustomButtonType.destructiveFilledLabel),
                CustomButton.noIcon(
                    label: appLocalization.translate("cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
              content: Text(
                  "${appLocalization.translate("areYouSureDelete")} ${event.data!.title}?"),
            )),
        CustomPopupItem(
            icon: AppIcons.copy,
            title: appLocalization.translate("duplicate"),
            onTap: () => onDuplicate(CreateTaskParams.fromTask(
                  event.data!,
                  serviceLocator<BackendMode>().mode,
                  BlocProvider.of<AuthBloc>(context).state.user!,
                  BlocProvider.of<GlobalBloc>(context)
                      .state
                      .selectedWorkspace!
                      .defaultList!,
                )))
      ];

  double get height {
    printDebug(
        'height of task ${(heightPerMinute! * event.data!.duration!.inMinutes)}');
    return (heightPerMinute! * event.data!.duration!.inMinutes);
  }

  bool showActions(CalendarViewType? taskWidgetInKalendarType) =>
      taskWidgetInKalendarType == CalendarViewType.schedule ||
      (taskWidgetInKalendarType != CalendarViewType.month &&
          taskWidgetInKalendarType != CalendarViewType.multiWeek &&
          taskWidgetInKalendarType != CalendarViewType.week &&
          height > 250);

  bool showList(CalendarViewType? taskWidgetInKalendarType) =>
      taskWidgetInKalendarType == CalendarViewType.schedule ||
      (
          taskWidgetInKalendarType != CalendarViewType.multiWeek &&
          taskWidgetInKalendarType != CalendarViewType.month &&
          height > 250);

  bool showTags(CalendarViewType? taskWidgetInKalendarType) =>
      taskWidgetInKalendarType == CalendarViewType.schedule ||
      (taskWidgetInKalendarType != CalendarViewType.month &&
          taskWidgetInKalendarType != CalendarViewType.multiWeek &&
          taskWidgetInKalendarType != CalendarViewType.week &&
          height > 400);

  bool showTime(CalendarViewType? taskWidgetInKalendarType) =>
      taskWidgetInKalendarType == CalendarViewType.schedule;

  int maxLines(
          Rect bounds, CalendarViewType? taskWidgetInKalendarType) =>
      (taskWidgetInKalendarType != CalendarViewType.schedule &&
              bounds.height > 70)
          ? 2
          : 1;

  bool showCheckIcon(CalendarViewType? taskWidgetInKalendarType,
          bool showSmallDesign) =>
      taskWidgetInKalendarType == CalendarViewType.schedule ||
      (taskWidgetInKalendarType != CalendarViewType.month &&
          taskWidgetInKalendarType != CalendarViewType.multiWeek &&
          taskWidgetInKalendarType != CalendarViewType.week &&
          showSmallDesign == false);

  bool isDismissible(CalendarViewType? taskWidgetInKalendarType) =>
      taskWidgetInKalendarType == CalendarViewType.schedule;

  @override
  Widget build(BuildContext context) {
    final task = event.data!;
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

    if (isDismissible(viewConfiguration.getCalendarViewType)) {
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
                          label: appLocalization.translate("complete"),
                          onPressed: () {
                            onCompleteConfirmed();
                            Navigator.pop(context);
                          },
                          type: CustomButtonType.secondaryLabel),
                      CustomButton.noIcon(
                          label: appLocalization.translate("cancel"),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ],
                    content: Text(
                        "${appLocalization.translate("areYouSureComplete")} ${task.title}?"),
                  );
                });
            return res;
          }
          return null;
        },
        child: true
            ? buildTaskWidgetInKalendar(
                context: context,
                taskWidgetInKalendarType: viewConfiguration.getCalendarViewType!,
                isListInsideFolder: isListInsideFolder,
                listName: listName,
                folderName: folderName,
                taskLocationTextStyle: taskLocationTextStyle,
                showSmallDesign: context.showSmallDesign)
            : Card(
                color: event.data?.color ?? Colors.blue,
                elevation: 0,
                child: ListTile(
                  title: Text(event.data?.title ?? ''),
                  subtitle: Text(
                    event.data?.description ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  mouseCursor: SystemMouseCursors.click,
                  dense: true,
                ),
              ),
      );
      return Card(
        color: event.data?.color ?? Colors.blue,
        elevation: 0,
        child: ListTile(
          title: Text(event.data?.title ?? ''),
          subtitle: Text(
            event.data?.description ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          mouseCursor: SystemMouseCursors.click,
          dense: true,
        ),
      );
    }

    return buildTaskWidgetInKalendar(
        context: context,
        taskWidgetInKalendarType: viewConfiguration.getCalendarViewType!,
        isListInsideFolder: isListInsideFolder,
        listName: listName,
        folderName: folderName,
        taskLocationTextStyle: taskLocationTextStyle,
        showSmallDesign: context.showSmallDesign);
  }

  DecoratedBox buildTaskWidgetInKalendar(
      {required BuildContext context,
      required CalendarViewType taskWidgetInKalendarType,
      required bool isListInsideFolder,
      required String? listName,
      required String? folderName,
      required TextStyle taskLocationTextStyle,
      required bool showSmallDesign}) {
    var task = event.data!;
    final dateTextStyle = AppTextStyle.getTextStyle(AppTextStyleParams(
        appFontSize: AppFontSize.paragraphX2Small,
        color: AppColors.grey(context.isDarkMode).shade400,
        appFontWeight: AppFontWeight.semiBold));
    var mainContent = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (showCheckIcon(taskWidgetInKalendarType, showSmallDesign))
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Icon(
              task.isCompleted ? AppIcons.checkboxchecked : AppIcons.checkbox,
              color:
                  task.status?.getColor ?? AppColors.text(context.isDarkMode),
              size: 15,
            ),
          ),
        if (showCheckIcon(taskWidgetInKalendarType, showSmallDesign))
          SizedBox(
            width: AppSpacing.x2Small4.value,
          ),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: task.title ?? '',
                  style: AppTextStyle.getTextStyle(AppTextStyleParams(
                          appFontSize: AppFontSize.paragraphXSmall,
                          color: AppColors.grey(context.isDarkMode).shade900,
                          appFontWeight: AppFontWeight.semiBold))
                      .copyWith(
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null),
                ),
                if (taskWidgetInKalendarType ==
                    CalendarViewType.schedule)
                  const TextSpan(text: '\n'),
                if (taskWidgetInKalendarType ==
                    CalendarViewType.schedule)
                  TextSpan(
                    text: task.description ?? '',
                    style: AppTextStyle.getTextStyle(AppTextStyleParams(
                            appFontSize: AppFontSize.paragraphX2Small,
                            color: AppColors.grey(context.isDarkMode).shade900,
                            appFontWeight: AppFontWeight.semiBold))
                        .copyWith(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null),
                  ),
              ],
            ),
          ),
        ),
        if (showActions(taskWidgetInKalendarType) &&
            actions(context).isNotEmpty)
          CustomPopupMenu(
            items: actions(context),
          )
      ],
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _color(task.color ?? Colors.blue).withOpacity(0.2),
        borderRadius: BorderRadius.circular(continuesBefore ? 0 : 8),
        border: true
            ? Border(
                left: BorderSide(
                    color: _color(task.color ?? Colors.blue), width: 2),
              )
            : null,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showList(taskWidgetInKalendarType))
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
            taskWidgetInKalendarType == CalendarViewType.schedule
                ? mainContent
                : Expanded(
                    child: mainContent,
                  ),
            if (showTime(taskWidgetInKalendarType) &&
                task.startDate != null &&
                task.dueDate != null)
              Text(
                "🕑 ${extensions.DateTimeExtensions.customToString(task.startDate, includeDayMonthYear: false)}"
                " => ${extensions.DateTimeExtensions.customToString(task.dueDate, includeDayMonthYear: false)}",
                style: dateTextStyle,
              )
            else if (showTime(taskWidgetInKalendarType))
              Text("", style: dateTextStyle),
            if (showTags(taskWidgetInKalendarType) && task.tags.isNotEmpty)
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
            else if (showTags(taskWidgetInKalendarType))
              Padding(
                padding: EdgeInsets.only(top: AppSpacing.xSmall8.value),
                child: Text(''),
              )
          ],
        ),
      ),
    );
  }

  Color _color(Color color) {
    if (tileType == TileType.ghost) {
      return color.withAlpha(100);
    }
    return color;
  }
}
