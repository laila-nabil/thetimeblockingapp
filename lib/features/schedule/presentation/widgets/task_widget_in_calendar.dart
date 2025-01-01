import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:thetimeblockingapp/features/tasks/domain/entities/task_parameters.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/presentation/widgets/tag_chip.dart';

enum CalendarViewType {
  day,
  twoDays,
  week,
  multiWeek,
  month,
  scheduleDynamicTaskHeight,
  scheduleFixedTaskHeight;

  bool get isSchedule => this == scheduleDynamicTaskHeight || this == scheduleFixedTaskHeight ;
}

enum TileType { selected, ghost, normal }

enum TaskLocation { body, header }

class TaskWidgetInCalendar extends StatelessWidget {
  const TaskWidgetInCalendar({
    super.key,
    required this.task,
    this.tileType = TileType.normal,
    this.taskLocation = TaskLocation.body,
    required this.onCompleteConfirmed,
    required this.onDeleteConfirmed,
    required this.calendarViewType,
    required this.heightPerMinute,
    required this.onDelete,
    required this.onSave,
    required this.onDuplicate, this.onEventTapped,
  });

  const TaskWidgetInCalendar.schedule({
    super.key,
    required this.task,
    required this.tileType,
    this.taskLocation = TaskLocation.body,
    required this.onCompleteConfirmed,
    required this.onDeleteConfirmed,
    required this.calendarViewType,
    required this.heightPerMinute,
    required this.onDelete,
    required this.onSave,
    required this.onDuplicate, required this.onEventTapped,
  });

  final Task task;
  final TileType tileType;
  final TaskLocation taskLocation;
  final void Function() onCompleteConfirmed;
  final void Function() onDeleteConfirmed;
  final CalendarViewType calendarViewType;
  final double? heightPerMinute;

  final void Function(DeleteTaskParams) onDelete;
  final void Function(CreateTaskParams) onSave;
  final void Function(CreateTaskParams) onDuplicate;
  final void Function()? onEventTapped;

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
                        task: task,
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
                  "${appLocalization.translate("areYouSureDelete")} ${task.title}?"),
            )),
        CustomPopupItem(
            icon: AppIcons.copy,
            title: appLocalization.translate("duplicate"),
            onTap: () => onDuplicate(CreateTaskParams.fromTask(
                  task,
                  serviceLocator<BackendMode>().mode,
                  BlocProvider.of<AuthBloc>(context).state.user!,
                  BlocProvider.of<GlobalBloc>(context)
                      .state
                      .selectedWorkspace!
                      .defaultList!,
                )))
      ];

  double? get heightInCalendarBody {
    if(heightPerMinute ==null){
      return null;
    }
    printDebug(
        'height of task ${(heightPerMinute! * task.duration!.inMinutes)}');
    return (heightPerMinute! * task.duration!.inMinutes);
  }

  bool showActions(CalendarViewType? calendarViewType) =>
      taskLocation == TaskLocation.body &&
      (calendarViewType?.isSchedule == true ||
          (calendarViewType != CalendarViewType.month &&
              calendarViewType != CalendarViewType.multiWeek &&
              calendarViewType != CalendarViewType.week &&
              (heightInCalendarBody !=null && heightInCalendarBody! > 250)));

  bool showList(CalendarViewType? calendarViewType) =>
      taskLocation == TaskLocation.body &&
      (calendarViewType?.isSchedule == true  ||
          (calendarViewType != CalendarViewType.multiWeek &&
              calendarViewType != CalendarViewType.month &&
              (heightInCalendarBody !=null && heightInCalendarBody! > 250)));

  bool showTags(CalendarViewType? calendarViewType) =>
      taskLocation == TaskLocation.body &&
      (calendarViewType?.isSchedule == true  ||
          (calendarViewType != CalendarViewType.month &&
              calendarViewType != CalendarViewType.multiWeek &&
              calendarViewType != CalendarViewType.week &&
              (heightInCalendarBody !=null && heightInCalendarBody! > 400)));

  bool showTime(CalendarViewType? calendarViewType) =>
      taskLocation == TaskLocation.body &&
          calendarViewType?.isSchedule == true ;

  int? maxLines(double? height, CalendarViewType? calendarViewType) {
    if (calendarViewType == CalendarViewType.scheduleDynamicTaskHeight) {
      return null;
    } else if (calendarViewType == CalendarViewType.scheduleFixedTaskHeight ||
        (height !=null && height > 100)) {
      return 3;
    } else if(height !=null && height > 70) {
      return 2;
    } else {
      return 1;
    }
  }

  bool showCheckIcon(
          CalendarViewType? calendarViewType, bool showSmallDesign) =>
      calendarViewType?.isSchedule == true ||
      (calendarViewType != CalendarViewType.month &&
          calendarViewType != CalendarViewType.multiWeek &&
          calendarViewType != CalendarViewType.week &&
          showSmallDesign == false);

  bool isDismissible(CalendarViewType? calendarViewType) =>
      calendarViewType?.isSchedule == true;

  @override
  Widget build(BuildContext context) {
    printDebug("task ${task.title} ${taskLocation}");
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

    if (isDismissible(calendarViewType)) {
      return InkWell(
        onTap:onEventTapped == null ? null: ()=> onEventTapped!(),
        child: Dismissible(
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
                  taskLocation: taskLocation,
                  context: context,
                  calendarViewType:
                  calendarViewType,
                  isListInsideFolder: isListInsideFolder,
                  listName: listName,
                  folderName: folderName,
                  taskLocationTextStyle: taskLocationTextStyle,
                  showSmallDesign: context.showSmallDesign)
              : Card(
                  color: task.color ?? Colors.blue,
                  elevation: 0,
                  child: ListTile(
                    title: Text(task.title ?? ''),
                    subtitle: Text(
                      task.description ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    mouseCursor: SystemMouseCursors.click,
                    dense: true,
                  ),
                ),
        ),
      );
      return Card(
        color: task.color ?? Colors.blue,
        elevation: 0,
        child: ListTile(
          title: Text(task.title ?? ''),
          subtitle: Text(
            task.description ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          mouseCursor: SystemMouseCursors.click,
          dense: true,
        ),
      );
    }

    return buildTaskWidgetInKalendar(
        taskLocation: taskLocation,
        context: context,
        calendarViewType: calendarViewType,
        isListInsideFolder: isListInsideFolder,
        listName: listName,
        folderName: folderName,
        taskLocationTextStyle: taskLocationTextStyle,
        showSmallDesign: context.showSmallDesign);
  }

  DecoratedBox buildTaskWidgetInKalendar(
      {required BuildContext context,
      required CalendarViewType calendarViewType,
      required bool isListInsideFolder,
      required String? listName,
      required String? folderName,
      required TextStyle taskLocationTextStyle,
      required TaskLocation taskLocation,
      required bool showSmallDesign}) {
    final dateTextStyle = AppTextStyle.getTextStyle(AppTextStyleParams(
        appFontSize: AppFontSize.paragraphX2Small,
        color: AppColors.grey(context.isDarkMode).shade400,
        appFontWeight: AppFontWeight.semiBold));
    var mainContent = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (showCheckIcon(calendarViewType, showSmallDesign))
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Icon(
              task.isCompleted ? AppIcons.checkboxchecked : AppIcons.checkbox,
              color:
                  task.status?.getColor ?? AppColors.text(context.isDarkMode),
              size: 15,
            ),
          ),
        if (showCheckIcon(calendarViewType, showSmallDesign))
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
                if (calendarViewType.isSchedule)
                  const TextSpan(text: '\n'),
                if (calendarViewType.isSchedule)
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
            maxLines: maxLines(heightInCalendarBody,calendarViewType),
          ),
        ),
        if (showActions(calendarViewType) &&
            actions(context).isNotEmpty)
          CustomPopupMenu(
            items: actions(context),
          )
      ],
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _color(task.color ?? Colors.blue).withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: true
            ? Border.all(color: _color(task.color ?? Colors.blue), width: 1)
            : null,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: taskLocation == TaskLocation.header ? 0 : 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showList(calendarViewType))
              Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.xSmall8.value),
                child: Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        if (isListInsideFolder)
                        TextSpan(
                          text:folderName ?? "",

                          ),
                        if (isListInsideFolder)
                          const TextSpan(text: ' / '),
                        TextSpan(
                          text: listName ?? '',
                          style: taskLocationTextStyle,
                        )
                      ],
                      style: taskLocationTextStyle,
                    ),
                    maxLines: 2,
                  ),
                ),
              ),
            calendarViewType == CalendarViewType.scheduleDynamicTaskHeight
                ? mainContent
                : Expanded(
                    child: mainContent,
                  ),
            if (showTime(calendarViewType) &&
                task.startDate != null &&
                task.dueDate != null)
              Text(
                "🕑 ${extensions.DateTimeExtensions.customToString(task.startDate, includeDayMonthYear: false)}"
                " => ${extensions.DateTimeExtensions.customToString(task.dueDate, includeDayMonthYear: false)}",
                style: dateTextStyle,
              )
            else if (showTime(calendarViewType))
              Text("", style: dateTextStyle),
            if (showTags(calendarViewType) && task.tags.isNotEmpty)
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
            else if (showTags(calendarViewType))
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
