import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/common/entities/status.dart';
import 'package:thetimeblockingapp/common/entities/tag.dart';
import 'package:thetimeblockingapp/common/enums/backend_mode.dart';
import 'package:thetimeblockingapp/common/widgets/custom_button.dart';
import 'package:thetimeblockingapp/common/widgets/custom_text_input_field.dart';
import 'package:thetimeblockingapp/core/extensions.dart';

import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/core/resources/app_icons.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';
import 'package:thetimeblockingapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:thetimeblockingapp/features/global/presentation/bloc/global_bloc.dart';
import 'package:thetimeblockingapp/features/task_popup/presentation/bloc/task_pop_up_bloc.dart';
import 'package:thetimeblockingapp/common/entities/tasks_list.dart';
import 'package:thetimeblockingapp/common/entities/space.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_task_use_case.dart';
import '../../../../common/dialogs/show_date_time_picker.dart';
import '../../../../common/widgets/custom_alert_dialog.dart';
import '../../../../common/widgets/custom_drop_down.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../tasks/domain/entities/task_parameters.dart';
import '../../../tasks/presentation/widgets/tag_chip.dart';

///TODO B task view as full page instead of popup

///TODO Z smart auto complete like Notion's / to select a list,tags,due date and start date
///TODO D once start date is selected when creating task from floating button,end date is start + Globals.defaultTaskDuration
///TODO Z input task duration

// ignore: must_be_immutable
class TaskPopupParams extends Equatable {
  Task? task;
  final void Function(CreateTaskParams params)? onSave;
  void Function()? onDuplicate;
  final void Function(DeleteTaskParams params)? onDelete;
  final Bloc bloc;
  final bool Function(Object? state) isLoading;
  DateTime? cellDate;
  DateTime? startDate;
  DateTime? dueDate;
  late bool isAllDay;
  TasksList? list;
  Tag? tag;

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
    dueDate = task?.dueDateUtc ??
        cellDate?.add(
            serviceLocator<Duration>(instanceName: "defaultTaskDuration"));
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
    dueDate = task?.dueDateUtc ?? cellDate?.add(serviceLocator<Duration>(instanceName: "defaultTaskDuration"));
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
    Task? task,
    void Function(CreateTaskParams params)? onSave,
    void Function(DeleteTaskParams params)? onDelete,
    Bloc? bloc,
    DateTime? cellDate,
    DateTime? startDate,
    DateTime? dueDate,
    TasksList? list,
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
    final authState = BlocProvider.of<AuthBloc>(context).state;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            return serviceLocator<TaskPopUpBloc>(param1: taskPopupParams)
              ..add(UpdateTaskParamsEvent(
                  taskParams: task == null
                      ? CreateTaskParams.startCreateNewTask(
                          accessToken: authState.accessToken!,
                          dueDate: taskPopupParams.dueDate,
                          startDate: taskPopupParams.startDate,
                          space: serviceLocator<bool>(instanceName: "isWorkspaceAndSpaceAppWide")
                              ? BlocProvider.of<GlobalBloc>(context).state.selectedSpace
                              : null,
                          list: taskPopupParams.list,
                          tag: taskPopupParams.tag,
                      backendMode: serviceLocator<BackendMode>().mode, user: authState.user!)
                      : CreateTaskParams.startUpdateTask(
                        accessToken: authState.accessToken!,
                          task: task,
                      backendMode: serviceLocator<BackendMode>().mode, user: authState.user!, space: null
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
              final taskParams = state.taskParams ??
                  (task == null
                      ? CreateTaskParams.startCreateNewTask(
                      accessToken: authState.accessToken!,
                          user: authState.user!,
                          dueDate: taskPopupParams.dueDate,
                          list: taskPopupParams.list,
                          startDate: taskPopupParams.startDate,
                      backendMode: serviceLocator<BackendMode>().mode)
                      : CreateTaskParams.startUpdateTask(
                      accessToken: authState.accessToken!,
                      user: authState.user!,
                          task: task,
                      backendMode: serviceLocator<BackendMode>().mode, space: null
                        ));
              printDebug("taskParams $taskParams");
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
              final globalState = BlocProvider.of<GlobalBloc>(context).state ;
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
                                                    DeleteTaskParams(
                                                        task: taskPopupParams
                                                            .task!,
                                                      accessToken: authState.accessToken!,
                                                      ));
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
                                            "${appLocalization.translate("areYouSureDelete")} ${taskPopupParams.task?.title}?"),
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
                                taskPopupParams.onSave!(state.onSaveTaskParams(
                                    taskPopupParams.dueDate,
                                    BlocProvider.of<AuthBloc>(context)
                                        .state
                                        .accessToken!,BlocProvider.of<AuthBloc>(context)
                                    .state
                                    .user!));
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
                                ///TODO D create a new Folder in task view
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
                                        UpdateTaskParamsEvent(
                                            taskParams:
                                            taskParams
                                                .copyWith(
                                                clearFolder:
                                                true)))
                                        : taskPopUpBloc.add(
                                        UpdateTaskParamsEvent(
                                            taskParams:
                                            taskParams
                                                .copyWith(
                                                folder:
                                                folder))),
                                    items: (state.taskParams?.space
                                        ?.folders
                                        ?.map((e) =>
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

                                ///TODO D create a new list in task view
                                ///List
                                if ((state.taskParams?.getAvailableLists
                                    .isNotEmpty ==
                                    true))
                                  CustomDropDown(
                                    isDense: true,
                                    style: taskLocationTextStyle,
                                    hint: Text(
                                        appLocalization.translate("list")),
                                    value: state.taskParams?.list,
                                    onChanged: (list) => taskPopUpBloc.add(
                                        UpdateTaskParamsEvent(
                                            taskParams:
                                            taskParams.copyWith(
                                                list: list))),
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
                            ///TODO D create a new Workspace/Space in task view
                            if (serviceLocator<bool>(instanceName: "isWorkspaceAndSpaceAppWide") == false)
                              (task == null
                                  ? DropdownButton<Space>(
                                hint: Text(
                                    appLocalization.translate("space")),
                                value: state.taskParams?.space,
                                onChanged: (space) => taskPopUpBloc.add(
                                    UpdateTaskParamsEvent(
                                        taskParams:
                                        taskParams.copyWith(
                                            space: space))),
                                items:
                                // (BlocProvider.of<GlobalBloc>(context).state.spaces)
                                //     ?.map((e) => DropdownMenuItem(
                                //     value: e,
                                //     child: Text(e.name ?? "")))
                                //     .toList() ??
                                    [],
                              )
                                  : Text(" ${task.space?.name ?? ""} ")),

                            ///Status && Priority
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ///Status
                               if(globalState.statuses?.isNotEmpty == true)
                                 CustomDropDown(
                                  value: state.taskParams?.taskStatus,
                                  style:  CustomDropDown
                                      .textStyle(context.isDarkMode),
                                  hint: Text(
                                      appLocalization.translate("status")),
                                  onChanged: (status) => taskPopUpBloc.add(
                                      UpdateTaskParamsEvent(
                                          taskParams:
                                          taskParams.copyWith(
                                              taskStatus: status))),
                                  items: globalState.statuses
                                      ?.map<
                                      DropdownMenuItem<
                                          TaskStatus>>((e) =>
                                      DropdownMenuItem(
                                          value: e,
                                          child: false ? Text(
                                              e.name ?? "",
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
                                                  e == globalState.statuses?.firstWhere((s) => s.isDone == true)
                                                                        ? AppIcons.checkboxchecked
                                                      : AppIcons.checkbox,
                                                  color: e.getColor ??
                                                      AppColors.text(context.isDarkMode)),
                                              const SizedBox(width: 2,),
                                              Text(
                                                  e.name ?? "",
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
                                if(globalState.priorities?.isNotEmpty == true)
                                  CustomDropDown(
                                    value: state.taskParams?.taskPriority,
                                    hint: Text(appLocalization
                                        .translate("priority")),
                                    onChanged: (priority) => priority ==
                                        null
                                        ? taskPopUpBloc.add(
                                        UpdateTaskParamsEvent(
                                            taskParams:
                                            taskParams
                                                .copyWith(
                                                clearPriority:
                                                true)))
                                        : taskPopUpBloc.add(
                                        UpdateTaskParamsEvent(
                                            taskParams:
                                            taskParams
                                                .copyWith(
                                                taskPriority:
                                                priority))),
                                    items: (globalState.priorities?.map((e) =>
                                      DropdownMenuItem(
                                      value: e,
                                      child: Row(
                                        children: [
                                          Icon(AppIcons.flagbold,
                                              color: e.getColor ??
                                                  AppColors.text(context.isDarkMode)),
                                          const SizedBox(width: 2,),
                                          Text(
                                            e.name ??
                                                e.id?.toStringOrNull() ??
                                                "",
                                            style: TextStyle(
                                                textBaseline:
                                                TextBaseline
                                                    .alphabetic,
                                                color: e
                                                    .getColor),
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
                                    UpdateTaskParamsEvent(
                                        taskParams: taskParams
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
                                taskPopUpBloc.add(UpdateTaskParamsEvent(
                                    taskParams: taskParams.copyWith(
                                        description: change)));
                              },
                            ),
                            spacerV,
                            spacerV,
                            Wrap(
                              spacing: AppSpacing.xSmall8.value,
                              children: [
                                ///TODO D is all day checkbox
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
                                          UpdateTaskParamsEvent(
                                              taskParams: taskParams
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
                                              UpdateTaskParamsEvent(
                                                  taskParams: taskParams
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
                                          UpdateTaskParamsEvent(
                                              taskParams: taskParams
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
                                              UpdateTaskParamsEvent(
                                                  taskParams: taskParams
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
                                          UpdateTaskParamsEvent(
                                              taskParams: taskParams
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
                            ///TODO D create new tags in task view
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
                                              .getColor,
                                          onDelete: () {
                                            List<Tag>?
                                            tags =
                                            List.from(
                                                state.taskParams?.tags ??
                                                    [],
                                                growable:
                                                true);
                                            tags.remove(e);
                                            taskPopUpBloc.add(
                                                UpdateTaskParamsEvent(
                                                    taskParams:
                                                    taskParams.copyWith(tags: tags)));
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
                                                                      ?.space
                                                                      ?.tags
                                                                      ?.map((e) => CheckboxListTile(
                                                                      title: Row(
                                                                        children: [
                                                                          Icon(
                                                                            AppIcons.hashtag,
                                                                            color: e.getColor,
                                                                          ),
                                                                          Text(
                                                                            e.name ?? "",
                                                                            style: TagChip.textStyle(AppColors.text(context.isDarkMode)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      value: state.taskParams?.tags?.contains(e) == true,
                                                                      onChanged: (value) {
                                                                        List<Tag>? tags = List.from(state.taskParams?.tags ?? [], growable: true);
                                                                        if (value == true) {
                                                                          tags.add(e);
                                                                        } else {
                                                                          tags.remove(e);
                                                                        }
                                                                        taskPopUpBloc.add(UpdateTaskParamsEvent(taskParams: taskParams.copyWith(tags: tags)));
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
                                                          ?.space
                                                          ?.tags
                                                          ?.map((e) =>
                                                          CheckboxListTile(
                                                              title:
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.tag,
                                                                    color: e.getColor,
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
                                                                List<Tag>?
                                                                tags =
                                                                List.from(state.taskParams?.tags ?? [], growable: true);
                                                                if (value ==
                                                                    true) {
                                                                  tags.add(e);
                                                                } else {
                                                                  tags.remove(e);
                                                                }
                                                                taskPopUpBloc
                                                                    .add(UpdateTaskParamsEvent(taskParams: taskParams.copyWith(tags: tags)));
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
