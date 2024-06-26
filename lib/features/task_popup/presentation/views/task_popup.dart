import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/common/widgets/custom_button.dart';
import 'package:thetimeblockingapp/common/widgets/custom_pop_up_menu.dart';
import 'package:thetimeblockingapp/common/widgets/custom_text_input_field.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';
import 'package:thetimeblockingapp/core/extensions.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/core/resources/app_icons.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';
import 'package:thetimeblockingapp/features/task_popup/presentation/bloc/task_pop_up_bloc.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_folder.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_list.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_space.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_task_use_case.dart';
import '../../../../common/dialogs/show_date_time_picker.dart';
import '../../../../common/widgets/custom_alert_dialog.dart';
import '../../../../common/widgets/custom_drop_down.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../tasks/domain/entities/task_parameters.dart';
import '../../../tasks/presentation/widgets/tag_chip.dart';

///TODO task view as full page instead of popup

///TODO smart auto complete like Notion's / to select a list,tags,due date and start date
///TODO once start date is selected when creating task from floating button,end date is start + Globals.defaultTaskDuration
///TODO input task duration

// ignore: must_be_immutable
class TaskPopupParams extends Equatable {
  ClickupTask? task;
  final void Function(ClickupTaskParams params)? onSave;
  void Function()? onDuplicate;
  final void Function(DeleteClickupTaskParams params)? onDelete;
  final Bloc bloc;
  final bool Function(Object? state) isLoading;
  DateTime? cellDate;
  DateTime? startDate;
  DateTime? dueDate;
  late bool isAllDay;
  ClickupList? list;
  ClickupTag? tag;

  TaskPopupParams.openNotAllDayTask({
    required this.task,
    required this.onSave,
    required this.onDelete,
    required this.onDuplicate,
    this.cellDate,
    required this.bloc,
    required this.isLoading,
  }) {
    startDate = task?.startDateUtc ?? cellDate;
    dueDate = task?.dueDateUtc ?? cellDate?.add(Globals.defaultTaskDuration);
    isAllDay = false;
    list = null;
  }
  TaskPopupParams.notAllDayTask({
    this.task,
    this.onSave,
    this.onDelete,
    this.cellDate,
    required this.bloc,
    required this.isLoading,
  }) {
    startDate = task?.startDateUtc ?? cellDate;
    dueDate = task?.dueDateUtc ?? cellDate?.add(Globals.defaultTaskDuration);
    isAllDay = false;
    list = null;
  }

  TaskPopupParams.allDayTask({
    this.task,
    this.onSave,
    this.onDelete,
    this.cellDate,
    required this.bloc,
    required this.isLoading,
  }) {
    if (cellDate != null) {
      startDate = DateTime(cellDate!.year, cellDate!.month, cellDate!.day, 4);
      dueDate = startDate;
    }
    isAllDay = true;
    list = null;
  }

  TaskPopupParams.addToList({
    this.onSave,
    this.onDelete,
    required this.list,
    required this.bloc,
    required this.isLoading,
  }) {
    task = null;
    isAllDay = false;
    cellDate = null;
  }

  TaskPopupParams.open({
    required this.task,
    required this.onSave,
    required this.onDelete,
    required this.bloc,
    required this.isLoading, this.onDuplicate,
  }) {
    startDate = task?.startDateUtc;
    dueDate = task?.dueDateUtc;
    isAllDay = task?.isAllDay ?? false;
    cellDate = null;
    list = task?.list;
  }

  TaskPopupParams.addToTag({
    required this.onSave,
    this.onDelete,
    required this.tag,
    required this.bloc,
    required this.isLoading,
  }) {
    task = null;
    isAllDay = false;
    cellDate = null;
    list = null;
  }

  TaskPopupParams.openFromTag({
    required this.task,
    required this.onSave,
    required this.onDelete,
    required this.bloc,
    required this.isLoading,
  }) {
    startDate = task?.startDateUtc;
    dueDate = task?.dueDateUtc;
    isAllDay = task?.isAllDay ?? false;
    cellDate = null;
    list = task?.list;
  }

  TaskPopupParams._(
      {this.task,
      this.onSave,
      this.onDelete,
      required this.bloc,
      required this.isLoading,
      this.cellDate,
      this.list,
      this.startDate,
      this.dueDate});

  TaskPopupParams copyWith({
    ClickupTask? task,
    void Function(ClickupTaskParams params)? onSave,
    void Function(DeleteClickupTaskParams params)? onDelete,
    Bloc? bloc,
    DateTime? cellDate,
    DateTime? startDate,
    DateTime? dueDate,
    ClickupList? list,
  }) {
    return TaskPopupParams._(
      task: task ?? this.task,
      onSave: onSave ?? this.onSave,
      onDelete: onDelete ?? this.onDelete,
      bloc: bloc ?? this.bloc,
      list: list ?? this.list,
      isLoading: isLoading,
      cellDate: cellDate ?? this.cellDate,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  @override
  List<Object?> get props => [
        task,
        onSave,
        onDelete,
        bloc,
        isLoading,
        cellDate,
        list,
        startDate,
        dueDate
      ];
}

Future showTaskPopup({
  required BuildContext context,
  required TaskPopupParams taskPopupParams,
}) {
  return showDialog(
      context: context,
      builder: (ctx) {
        return TaskPopup(
          taskPopupParams: taskPopupParams,
        );
      });
}

class TaskPopup extends StatelessWidget {
  const TaskPopup({super.key, required this.taskPopupParams});

  final TaskPopupParams taskPopupParams;

  @override
  Widget build(BuildContext context) {
    final radius = AppBorderRadius.xLarge.value;
    final borderRadius = BorderRadius.circular(radius);
    final task = taskPopupParams.task;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            return serviceLocator<TaskPopUpBloc>(param1: taskPopupParams)
              ..add(UpdateClickupTaskParamsEvent(
                  taskParams: task == null
                      ? ClickupTaskParams.startCreateNewTask(
                          clickupAccessToken: Globals.clickupAuthAccessToken,
                          dueDate: taskPopupParams.dueDate,
                          startDate: taskPopupParams.startDate,
                          space: Globals.isSpaceAppWide
                              ? Globals.selectedSpace
                              : null,
                          list: taskPopupParams.list,
                          tag: taskPopupParams.tag)
                      : ClickupTaskParams.startUpdateTask(
                          clickupAccessToken: Globals.clickupAuthAccessToken,
                          task: task,
                        )));
          },
        ),
        BlocProvider.value(
          value: taskPopupParams.bloc,
        ),
      ],
      child: BlocBuilder(
        bloc: taskPopupParams.bloc,
        builder: (context, blocState) {
          return BlocBuilder<TaskPopUpBloc, TaskPopUpState>(
            builder: (context, state) {
              final taskPopUpBloc = BlocProvider.of<TaskPopUpBloc>(context);
              printDebug("state.taskParams ${state.taskParams}");
              final clickupTaskParams = state.taskParams ??
                  (task == null
                      ? ClickupTaskParams.startCreateNewTask(
                          clickupAccessToken: Globals.clickupAuthAccessToken,
                          dueDate: taskPopupParams.dueDate,
                          list: taskPopupParams.list,
                          startDate: taskPopupParams.startDate)
                      : ClickupTaskParams.startUpdateTask(
                          clickupAccessToken: Globals.clickupAuthAccessToken,
                          task: task,
                        ));
              printDebug("clickupTaskParams $clickupTaskParams");
              final firstDate =
                  DateTime.now().subtract(const Duration(days: 1000));
              final lastDate = DateTime.now().add(const Duration(days: 1000));
              final initialDueDate =
                  task?.dueDateUtc ?? taskPopupParams.dueDate;
              final initialStartDate =
                  task?.startDateUtc ?? taskPopupParams.startDate;
              final loading = taskPopupParams.isLoading(blocState);
              final spacerV = SizedBox(
                height: AppSpacing.medium16.value,
              );
              final taskLocationTextStyle = AppTextStyle.getTextStyle(
                  AppTextStyleParams(
                      appFontSize: AppFontSize.paragraphSmall,
                      appFontWeight: AppFontWeight.medium,
                      color: AppColors.grey(context.isDarkMode).shade800));
              final sectionTitle = AppTextStyle.getTextStyle(AppTextStyleParams(
                  appFontSize: AppFontSize.paragraphSmall,
                  color: AppColors.grey(context.isDarkMode).shade900,
                  appFontWeight: AppFontWeight.medium));
              return CustomAlertDialog(
                  loading: loading,
                  shape: RoundedRectangleBorder(borderRadius: borderRadius),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.medium16.value,
                      vertical: AppSpacing.small12.value),
                  actions: [
                    if (task != null)
                         CustomButton.iconOnly(
                        icon: AppIcons.bin,
                        onPressed: taskPopupParams.onDelete == null
                            ? null
                            : () {
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return CustomAlertDialog(
                                        loading: false,
                                        actions: [
                                          CustomButton.noIcon(
                                              label: appLocalization
                                                  .translate("delete"),
                                              onPressed: () {
                                                taskPopupParams.onDelete!(
                                                    DeleteClickupTaskParams(
                                                        task: taskPopupParams
                                                            .task!,
                                                        clickupAccessToken: Globals
                                                            .clickupAuthAccessToken));
                                                Navigator.pop(ctx);
                                              },
                                              type: CustomButtonType
                                                  .destructiveFilledLabel),
                                          CustomButton.noIcon(
                                              label: appLocalization
                                                  .translate("cancel"),
                                              onPressed: () {
                                                Navigator.pop(ctx);
                                              }),
                                        ],
                                        content: Text(
                                            "${appLocalization.translate("areYouSureDelete")} ${taskPopupParams.task?.name}?"),
                                      );
                                    });
                              },
                           size: CustomButtonSize.large,
                           type: CustomButtonType.destructiveTextIcon,
                      ),
                    if (task != null && taskPopupParams.onDuplicate!=null)
                      CustomButton.iconOnly(
                          icon: AppIcons.copy,
                          onPressed: () {
                            taskPopupParams.onDuplicate!();
                          },
                          type: CustomButtonType.primaryTextIcon,
                        size: CustomButtonSize.large,
                      ),
                    CustomButton.noIcon(
                        onPressed: () => Navigator.maybePop(context),
                        label: appLocalization.translate("cancel")),
                    CustomButton.noIcon(
                        onPressed: loading ||
                                taskPopupParams.onSave == null ||
                                state.readyToSubmit == false
                            ? null
                            : () {
                                taskPopupParams.onSave!(state
                                    .onSaveTaskParams(taskPopupParams.dueDate));
                              },
                        label: appLocalization.translate("save")),
                  ],
                  content: SingleChildScrollView(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child : SizedBox(
                        width: double.maxFinite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                ///TODO create a new Folder in task view
                                ///Folder
                                if (state.isFoldersListAvailable)
                                  CustomDropDown(
                                    isDense: true,
                                    hint: Text(appLocalization
                                        .translate("folder")),
                                    style: taskLocationTextStyle,
                                    value: state.taskParams?.folder,
                                    icon: const Padding(
                                      padding:  EdgeInsets.all(4.0),
                                      child: Icon(AppIcons.chevrondown,size: 14),
                                    ),

                                    onChanged: (folder) => folder == null
                                        ? taskPopUpBloc.add(
                                        UpdateClickupTaskParamsEvent(
                                            taskParams:
                                            clickupTaskParams
                                                .copyWith(
                                                clearFolder:
                                                true)))
                                        : taskPopUpBloc.add(
                                        UpdateClickupTaskParamsEvent(
                                            taskParams:
                                            clickupTaskParams
                                                .copyWith(
                                                folder:
                                                folder))),
                                    items: (state.taskParams?.clickupSpace
                                        ?.folders
                                        .map((e) =>
                                        DropdownMenuItem(
                                            value: e,
                                            child: Text(
                                                e.name ?? "")))
                                        .toList() ??
                                        []) +
                                        [
                                          DropdownMenuItem(
                                              value: null,
                                              child: Text(appLocalization
                                                  .translate("clear")))
                                        ], isDarkMode: (context.isDarkMode),
                                  ),
                                Text(
                                  "/",
                                  style: taskLocationTextStyle,
                                ),

                                ///TODO create a new list in task view
                                ///List
                                if ((state.taskParams?.getAvailableLists
                                    .isNotEmpty ==
                                    true))
                                  CustomDropDown(
                                    isDense: true,
                                    style: taskLocationTextStyle,
                                    hint: Text(
                                        appLocalization.translate("list")),
                                    value: state.taskParams?.clickupList,
                                    onChanged: (list) => taskPopUpBloc.add(
                                        UpdateClickupTaskParamsEvent(
                                            taskParams:
                                            clickupTaskParams.copyWith(
                                                clickupList: list))),
                                    items: state
                                        .taskParams?.getAvailableLists
                                        .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e.name ?? "")))
                                        .toList() ??
                                        [], isDarkMode: (context.isDarkMode),
                                  ),
                              ],
                            ),
                            spacerV,

                            ///Space
                            ///TODO create a new Workspace/Space in task view
                            if (Globals.isSpaceAppWide == false)
                              (task == null
                                  ? DropdownButton<ClickupSpace>(
                                hint: Text(
                                    appLocalization.translate("space")),
                                value: state.taskParams?.clickupSpace,
                                onChanged: (space) => taskPopUpBloc.add(
                                    UpdateClickupTaskParamsEvent(
                                        taskParams:
                                        clickupTaskParams.copyWith(
                                            clickupSpace: space))),
                                items: (Globals.clickupSpaces)
                                    ?.map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name ?? "")))
                                    .toList() ??
                                    [],
                              )
                                  : Text(" ${task.space?.name ?? ""} ")),

                            ///Status && Priority
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ///Status
                               CustomDropDown(
                                  value: state.taskParams?.taskStatus,
                                  style:  CustomDropDown
                                      .textStyle(context.isDarkMode),
                                  hint: Text(
                                      appLocalization.translate("status")),
                                  onChanged: (status) => taskPopUpBloc.add(
                                      UpdateClickupTaskParamsEvent(
                                          taskParams:
                                          clickupTaskParams.copyWith(
                                              taskStatus: status))),
                                  items: state.taskParams?.clickupSpace
                                      ?.statuses
                                      ?.map<
                                      DropdownMenuItem<
                                          ClickupStatus>>((e) =>
                                      DropdownMenuItem(
                                          value: e,
                                          child: false ? Text(
                                              e.status ?? "",
                                              style: CustomDropDown
                                                  .textStyle(context.isDarkMode)
                                                  .copyWith(
                                                  color: e
                                                      .getColor,
                                                  fontWeight: state
                                                      .taskParams
                                                      ?.taskStatus ==
                                                      e
                                                      ? AppFontWeight
                                                      .semiBold
                                                      .value
                                                      : null)):Row(
                                            children: [
                                              Icon(
                                                  e ==
                                                      state.taskParams?.clickupSpace
                                                          ?.statuses?.last
                                                      ? AppIcons.checkboxchecked
                                                      : AppIcons.checkbox,
                                                  color: e.getColor ??
                                                      AppColors.text(context.isDarkMode)),
                                              const SizedBox(width: 2,),
                                              Text(
                                                  e.status ?? "",
                                                  style: CustomDropDown
                                                      .textStyle(context.isDarkMode)
                                                      .copyWith(
                                                      color: e
                                                          .getColor,
                                                      fontWeight: state
                                                          .taskParams
                                                          ?.taskStatus ==
                                                          e
                                                          ? AppFontWeight
                                                          .semiBold
                                                          .value
                                                          : null)),
                                            ],
                                          )))
                                      .toList() ??
                                      [], isDarkMode: (context.isDarkMode),
                                ),

                                ///Priority
                                if (state.isPrioritiesEnabled)
                                  CustomDropDown(
                                    value: state.taskParams?.taskPriority,
                                    hint: Text(appLocalization
                                        .translate("priority")),
                                    onChanged: (priority) => priority ==
                                        null
                                        ? taskPopUpBloc.add(
                                        UpdateClickupTaskParamsEvent(
                                            taskParams:
                                            clickupTaskParams
                                                .copyWith(
                                                clearPriority:
                                                true)))
                                        : taskPopUpBloc.add(
                                        UpdateClickupTaskParamsEvent(
                                            taskParams:
                                            clickupTaskParams
                                                .copyWith(
                                                taskPriority:
                                                priority))),
                                    items: (state
                                        .taskParams
                                        ?.clickupSpace
                                        ?.features
                                        ?.priorities
                                        ?.priorities
                                        ?.map((e) => e.isNum
                                        ? DropdownMenuItem(
                                      value: e,
                                      child: Row(
                                        children: [
                                          Icon(
                                              e.priorityNum ==
                                                  null
                                                  ? AppIcons.flag
                                                  : AppIcons.flagbold,
                                              color: e.getPriorityColor ??
                                                  AppColors.text(context.isDarkMode)),
                                          const SizedBox(width: 2,),
                                          Text(
                                            e.priorityNum
                                                .toString(),
                                          ),
                                        ],
                                      ),
                                    )
                                        : DropdownMenuItem(
                                      value: e,
                                      child: Row(
                                        children: [
                                          Icon(
                                              e.priority ==
                                                  null
                                                  ? AppIcons.flag
                                                  : AppIcons.flagbold,
                                              color: e.getPriorityColor ??
                                                  AppColors.text(context.isDarkMode)),
                                          const SizedBox(width: 2,),
                                          Text(
                                            e.priority ??
                                                e.id?.toStringOrNull() ??
                                                "",
                                            style: TextStyle(
                                                textBaseline:
                                                TextBaseline
                                                    .alphabetic,
                                                color: e
                                                    .getPriorityColor),
                                          ),
                                        ],
                                      ),
                                    ))
                                        .toList() ??
                                        []) +
                                        [
                                          DropdownMenuItem(
                                              value: null,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                       AppIcons.flag,
                                                      color: AppColors.grey(context.isDarkMode).shade50),
                                                  const SizedBox(width: 2,),
                                                  Text(appLocalization
                                                      .translate("clear")),
                                                ],
                                              ))
                                        ], isDarkMode: (context.isDarkMode),
                                  ),
                              ],
                            ),
                            SizedBox(
                              height: AppSpacing.xSmall8.value,
                            ),
                            ///Title
                            CustomTextInputField(
                              buttonStyle: CustomTextInputFieldStyle.line,
                              focusNode: taskPopUpBloc.titleFocusNode,
                              controller: taskPopUpBloc.titleController,
                              hintText: appLocalization.translate("taskName"),
                              onChanged: (change) {
                                taskPopUpBloc.add(
                                    UpdateClickupTaskParamsEvent(
                                        taskParams: clickupTaskParams
                                            .copyWith(title: change)));
                              },
                            ),
                            spacerV,

                            ///Description
                            CustomTextInputField(
                              buttonStyle: CustomTextInputFieldStyle.line,
                              focusNode: taskPopUpBloc.descriptionFocusNode,
                              controller: taskPopUpBloc.descriptionController,
                              hintText: appLocalization.translate("description"),
                              maxLines: 3,
                              minLines: 1,
                              onChanged: (change) {
                                taskPopUpBloc.add(UpdateClickupTaskParamsEvent(
                                    taskParams: clickupTaskParams.copyWith(
                                        description: change)));
                              },
                            ),
                            spacerV,
                            spacerV,
                            Wrap(
                              spacing: AppSpacing.xSmall8.value,
                              children: [
                                ///TODO is all day checkbox
                                ///isAllDay
                                if(false)Checkbox(
                                    value: taskPopupParams.isAllDay,
                                    onChanged: null),

                                ///All day Date
                                if (false && taskPopupParams.isAllDay)
                                  CustomButton.noIcon(
                                    onPressed: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime(
                                            initialStartDate?.year ??
                                                DateTime.now().year,
                                            initialStartDate?.month ??
                                                DateTime.now().month,
                                            initialStartDate?.day ??
                                                DateTime.now().day),
                                        firstDate: firstDate,
                                        lastDate: lastDate,
                                      ).then((value) => taskPopUpBloc.add(
                                          UpdateClickupTaskParamsEvent(
                                              taskParams: clickupTaskParams
                                                  .copyWith(startDate: value))));
                                    },
                                    type: CustomButtonType.secondaryLabel,
                                    label: " ${appLocalization.translate("date")}"
                                        " ${DateTimeExtensions.customToString(state.taskParams?.startDate, includeTime: false) ?? ""} ",
                                  ),

                                ///Start DATE
                                if (taskPopupParams.isAllDay == false)
                                  true
                                      ? Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        appLocalization
                                            .translate("startDate"),
                                        style: sectionTitle,
                                      ),
                                      SizedBox(
                                        height: AppSpacing.x2Small4.value,
                                      ),
                                      CustomButton.noIcon(
                                        onPressed: () {
                                          showDateTimePicker(
                                            context: context,
                                            initialDate: initialStartDate ??
                                                DateTime.now(),
                                            firstDate: firstDate,
                                            lastDate: lastDate,
                                          ).then((value) => taskPopUpBloc.add(
                                              UpdateClickupTaskParamsEvent(
                                                  taskParams: clickupTaskParams
                                                      .copyWith(
                                                      startDate: value))));
                                        },
                                        type: CustomButtonType.greyOutlinedLabel,
                                        label:
                                        DateTimeExtensions.customToString(state.taskParams?.startDate) ?? "YYYY-MM-DD HH:MM AM",
                                      )
                                    ],
                                  )
                                      : CustomButton.noIcon(
                                    onPressed: () {
                                      showDateTimePicker(
                                        context: context,
                                        initialDate: initialStartDate ??
                                            DateTime.now(),
                                        firstDate: firstDate,
                                        lastDate: lastDate,
                                      ).then((value) => taskPopUpBloc.add(
                                          UpdateClickupTaskParamsEvent(
                                              taskParams: clickupTaskParams
                                                  .copyWith(
                                                  startDate: value))));
                                    },
                                    type: CustomButtonType.secondaryLabel,
                                    label:
                                    " ${appLocalization.translate("startDate")}"
                                        " ${DateTimeExtensions.customToString(state.taskParams?.startDate) ?? ""} ",
                                  ),
                                ///DUE DATE
                                if (taskPopupParams.isAllDay == false)
                                  true
                                      ? Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        appLocalization
                                            .translate("dueDate"),
                                        style: sectionTitle,
                                      ),
                                      SizedBox(
                                        height: AppSpacing.x2Small4.value,
                                      ),
                                      CustomButton.noIcon(
                                        onPressed: () {
                                          showDateTimePicker(
                                            context: context,
                                            initialDate:
                                            initialDueDate ?? DateTime.now(),
                                            firstDate: firstDate,
                                            lastDate: lastDate,
                                          ).then((value) => taskPopUpBloc.add(
                                              UpdateClickupTaskParamsEvent(
                                                  taskParams: clickupTaskParams
                                                      .copyWith(dueDate: value))));
                                        },
                                        type: CustomButtonType.greyOutlinedLabel,
                                        label:
                                        DateTimeExtensions.customToString(state.taskParams?.dueDate) ?? "YYYY-MM-DD HH:MM AM",
                                      ),
                                    ],
                                  )
                                      :  CustomButton.noIcon(
                                    onPressed: () {
                                      showDateTimePicker(
                                        context: context,
                                        initialDate:
                                        initialDueDate ?? DateTime.now(),
                                        firstDate: firstDate,
                                        lastDate: lastDate,
                                      ).then((value) => taskPopUpBloc.add(
                                          UpdateClickupTaskParamsEvent(
                                              taskParams: clickupTaskParams
                                                  .copyWith(dueDate: value))));
                                    },
                                    type: CustomButtonType.secondaryLabel,
                                    label:
                                    " ${appLocalization.translate("dueDate")}"
                                        " ${DateTimeExtensions.customToString(state.taskParams?.dueDate) ?? ""} ",
                                  ),
                              ],
                            ),
                            spacerV,

                            ///Tags
                            ///TODO create new tags in task view
                            if (state.viewTagsButton)
                              true
                                  ? Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    appLocalization.translate("Tags"),
                                    style: sectionTitle,
                                  ),
                                  SizedBox(
                                    height: AppSpacing.x2Small4.value,
                                  ),
                                  Wrap(
                                    spacing: 2,
                                    runSpacing: 2,
                                    children: (state.taskParams?.tags
                                        ?.map<Widget>(
                                            (e) => TagChip(
                                          tagName:
                                          e.name ?? '',
                                          color: e
                                              .getTagFgColor,
                                          onDelete: () {
                                            List<ClickupTag>?
                                            tags =
                                            List.from(
                                                state.taskParams?.tags ??
                                                    [],
                                                growable:
                                                true);
                                            tags.remove(e);
                                            taskPopUpBloc.add(
                                                UpdateClickupTaskParamsEvent(
                                                    taskParams:
                                                    clickupTaskParams.copyWith(tags: tags)));
                                          },
                                        ))
                                        .toList() ??
                                        []) +
                                        [
                                          CustomButton.trailingIcon(
                                              type: CustomButtonType
                                                  .greyTextLeadingIcon,
                                              label: appLocalization
                                                  .translate("addTag"),
                                              icon: Icons.add,
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (ctx) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            appLocalization
                                                                .translate(
                                                                "tags")),
                                                        scrollable: true,
                                                        content:
                                                        BlocProvider
                                                            .value(
                                                          value:
                                                          taskPopUpBloc,
                                                          child: BlocBuilder<
                                                              TaskPopUpBloc,
                                                              TaskPopUpState>(
                                                            builder:
                                                                (context,
                                                                state) {
                                                              return SizedBox(
                                                                height: 400,
                                                                width: 400,
                                                                child:
                                                                ListView(
                                                                  children: state
                                                                      .taskParams
                                                                      ?.clickupSpace
                                                                      ?.tags
                                                                      .map((e) => CheckboxListTile(
                                                                      title: Row(
                                                                        children: [
                                                                          Icon(
                                                                            AppIcons.hashtag,
                                                                            color: e.getTagFgColor,
                                                                          ),
                                                                          Text(
                                                                            e.name ?? "",
                                                                            style: TagChip.textStyle(AppColors.text(context.isDarkMode)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      value: state.taskParams?.tags?.contains(e) == true,
                                                                      onChanged: (value) {
                                                                        List<ClickupTag>? tags = List.from(state.taskParams?.tags ?? [], growable: true);
                                                                        if (value == true) {
                                                                          tags.add(e);
                                                                        } else {
                                                                          tags.remove(e);
                                                                        }
                                                                        taskPopUpBloc.add(UpdateClickupTaskParamsEvent(taskParams: clickupTaskParams.copyWith(tags: tags)));
                                                                      }))
                                                                      .toList() ??
                                                                      [],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              })
                                        ],
                                  )
                                ],
                              )
                                  : CustomButton.noIcon(
                                  type: CustomButtonType.secondaryLabel,
                                  label:
                                  "${state.taskParams?.tags?.map((e) => e.name) ?? appLocalization.translate("tags")}",
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) {
                                          return AlertDialog(
                                            title: Text(appLocalization
                                                .translate("tags")),
                                            scrollable: true,
                                            content: BlocProvider.value(
                                              value: taskPopUpBloc,
                                              child: BlocBuilder<
                                                  TaskPopUpBloc,
                                                  TaskPopUpState>(
                                                builder: (context, state) {
                                                  return SizedBox(
                                                    height: 400,
                                                    width: 400,
                                                    child: ListView(
                                                      children: state
                                                          .taskParams
                                                          ?.clickupSpace
                                                          ?.tags
                                                          .map((e) =>
                                                          CheckboxListTile(
                                                              title:
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.tag,
                                                                    color: e.getTagFgColor,
                                                                  ),
                                                                  Text(
                                                                    e.name ?? "",
                                                                  ),
                                                                ],
                                                              ),
                                                              value: state.taskParams?.tags?.contains(e) ==
                                                                  true,
                                                              onChanged:
                                                                  (value) {
                                                                List<ClickupTag>?
                                                                tags =
                                                                List.from(state.taskParams?.tags ?? [], growable: true);
                                                                if (value ==
                                                                    true) {
                                                                  tags.add(e);
                                                                } else {
                                                                  tags.remove(e);
                                                                }
                                                                taskPopUpBloc
                                                                    .add(UpdateClickupTaskParamsEvent(taskParams: clickupTaskParams.copyWith(tags: tags)));
                                                              }))
                                                          .toList() ??
                                                          [],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        });
                                  }),
                          ],
                        ),
                      )
                    ),
                  ));
            },
          );
        },
      ),
    );
  }
}
