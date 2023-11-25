import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/common/widgets/custom_button.dart';
import 'package:thetimeblockingapp/common/widgets/custom_input_field.dart';
import 'package:thetimeblockingapp/core/extensions.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/task_popup/presentation/bloc/task_pop_up_bloc.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_folder.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_list.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_space.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_task_use_case.dart';
import '../../../../common/dialogs/show_date_time_picker.dart';
import '../../../../common/widgets/custom_alert_dialog.dart';
import '../../../tasks/domain/entities/task_parameters.dart';

///TODO create all day task from floating action button && control if task is all day or not

// ignore: must_be_immutable
class TaskPopupParams extends Equatable {
  ClickupTask? task;
  final void Function(ClickupTaskParams params)? onSave;
  final void Function(DeleteClickupTaskParams params)? onDelete;
  final Bloc bloc;
  final bool Function(Object? state) isLoading;
  DateTime? cellDate;
  DateTime? startDate;
  DateTime? dueDate;
  late bool isAllDay;
  ClickupList? list;
  ClickupTag? tag;
  TaskPopupParams.notAllDayTask({
    this.task,
    this.onSave,
    this.onDelete,
    this.cellDate,
    required this.bloc,
    required this.isLoading,
  }){
    startDate =task?.startDateUtc ?? cellDate;
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
  }){
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
  }){
    task = null;
    isAllDay = false;
    cellDate = null;
  }

  TaskPopupParams.openFromList({
    required this.task,
    required this.onSave,
    required this.onDelete,
    required this.bloc,
    required this.isLoading,
  }){
    startDate =task?.startDateUtc ;
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
  }){
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
  }){
    startDate =task?.startDateUtc ;
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
    const radius = 20.0;
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
                          space: Globals.isSpaceAppWide ? Globals.selectedSpace : null,
                          list: taskPopupParams.list,
                          tag: taskPopupParams.tag
                        )
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
              return CustomAlertDialog(
                  loading: loading,
                  shape: RoundedRectangleBorder(borderRadius: borderRadius),
                  contentPadding: const EdgeInsets.all(radius),
                  actions: [
                    if(task!=null)IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        onPressed: taskPopupParams.onDelete == null
                            ? null
                            : () => taskPopupParams.onDelete!(
                          DeleteClickupTaskParams(
                              task: taskPopupParams.task!,
                              clickupAccessToken: Globals
                                  .clickupAuthAccessToken)),
                    ),
                    CustomButton(
                        onPressed: () => Navigator.maybePop(context),
                        child: Text(appLocalization.translate("cancel"))),
                    CustomButton(
                        onPressed: loading ||
                                taskPopupParams.onSave == null ||
                                state.readyToSubmit == false
                            ? null
                            : () {
                                taskPopupParams.onSave!(state.onSaveTaskParams(
                                    taskPopupParams.dueDate));
                              },
                        child: Text(appLocalization.translate("save"))),
                  ],
                  content: SingleChildScrollView(
                    child: SizedBox(
                      width: double.maxFinite,
                      child: Column(
                        children: [
                          ///Space
                          ///TODO B create a new Space
                          ///TODO C default space is set in settings
                          if(Globals.isSpaceAppWide == false)(task == null
                              ? DropdownButton<ClickupSpace>(
                                  hint:
                                      Text(appLocalization.translate("space")),
                                  value: state.taskParams?.clickupSpace,
                                  onChanged: (space) => taskPopUpBloc.add(
                                      UpdateClickupTaskParamsEvent(
                                          taskParams: clickupTaskParams
                                              .copyWith(clickupSpace: space))),
                                  items: (Globals.clickupSpaces)
                                          ?.map((e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(e.name ?? "")))
                                          .toList() ??
                                      [],
                                )
                              : Text(" ${task.space?.name ?? ""} ")),

                          ///Status && Priority & Title
                          Row(
                            children: [
                              ///Status
                              DropdownButton<ClickupStatus>(
                                value: state.taskParams?.taskStatus,
                                hint: Text(
                                    appLocalization.translate("status")),
                                onChanged: (status) => taskPopUpBloc.add(
                                    UpdateClickupTaskParamsEvent(
                                        taskParams:
                                        clickupTaskParams.copyWith(
                                            taskStatus: status))),
                                items: state.taskParams?.clickupSpace?.statuses
                                        ?.map<DropdownMenuItem<ClickupStatus>>(
                                            (e) => DropdownMenuItem(
                                                value: e,
                                                child: Text(e.status ?? "",
                                                    style: TextStyle(
                                                        textBaseline:
                                                        TextBaseline.alphabetic,
                                                        color: e.getColor))))
                                        .toList() ??
                                    [],
                              ),
                              ///Priority
                              ///TODO add priorities in case of disabled
                              if (state.isPrioritiesEnabled)
                                DropdownButton<ClickupTaskPriority>(
                                  value: state.taskParams?.taskPriority,
                                  hint: Text(
                                      appLocalization.translate("priority")),
                                  onChanged: (priority) => priority == null
                                      ? taskPopUpBloc.add(
                                          UpdateClickupTaskParamsEvent(
                                              taskParams:
                                                  clickupTaskParams.copyWith(
                                                      clearPriority: true)))
                                      : taskPopUpBloc.add(
                                          UpdateClickupTaskParamsEvent(
                                              taskParams:
                                                  clickupTaskParams.copyWith(
                                                      taskPriority: priority))),
                                  items: (state.taskParams?.clickupSpace
                                      ?.features?.priorities?.priorities
                                      ?.map((e) => e.isNum
                                          ? DropdownMenuItem(
                                              value: e,
                                              child: Text(
                                                e.priorityNum.toString(),
                                              ),
                                            )
                                          : DropdownMenuItem(
                                              value: e,
                                              child: Text(
                                                e.priority??e.id?.toStringOrNull()??"",
                                                style: TextStyle(
                                                    textBaseline:
                                                        TextBaseline.alphabetic,
                                                    color: e.getPriorityColor),
                                              ),
                                            ))
                                      .toList() ?? [])+
                                      [
                                        DropdownMenuItem(
                                            value: null,
                                            child: Text(appLocalization
                                                .translate("clear")))
                                      ],
                                ),
                              Expanded(
                                  child: CustomTextInputField(
                                controller: taskPopUpBloc.titleController,
                                decoration: InputDecoration(
                                    hintText:
                                        appLocalization.translate("title")),
                                onChanged: (change) {
                                  taskPopUpBloc.add(
                                      UpdateClickupTaskParamsEvent(
                                          taskParams: clickupTaskParams
                                              .copyWith(title: change)));
                                },
                              ))
                            ],
                          ),

                          ///Description
                          CustomTextInputField(
                            controller: taskPopUpBloc.descriptionController,
                            decoration: InputDecoration(
                              hintText:
                                  appLocalization.translate("description"),
                            ),
                            maxLines: 3,
                            onChanged: (change) {
                              taskPopUpBloc.add(UpdateClickupTaskParamsEvent(
                                  taskParams: clickupTaskParams.copyWith(
                                      description: change)));
                            },
                          ),

                          ///Tags
                          ///TODO B TODO create new tags
                          if(state.viewTagsButton)CustomButton(
                            customButtonEnum: CustomButtonEnum.secondary,
                              child: Text(
                                  "${state.taskParams?.tags?.map((e) => e.name) ?? appLocalization.translate("tags")}"),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return AlertDialog(
                                        title: Text(
                                            appLocalization.translate("tags")),
                                        scrollable: true,
                                        content: BlocProvider.value(
                                          value: taskPopUpBloc,
                                          child: BlocBuilder<TaskPopUpBloc,
                                              TaskPopUpState>(
                                            builder: (context, state) {
                                              return SizedBox(
                                                height: 400,
                                                width: 400,
                                                child: Column(
                                                  children: state.taskParams
                                                            ?.clickupSpace?.tags
                                                            .map((e) =>
                                                                CheckboxListTile(
                                                                    title: Row(
                                                                      children: [
                                                                        Icon(Icons.tag,color: e.getTagFgColor,),
                                                                        Text(
                                                                          e.name ??
                                                                              "",
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    value: state
                                                                            .taskParams
                                                                            ?.tags
                                                                            ?.contains(
                                                                                e) ==
                                                                        true,
                                                                    onChanged:
                                                                      (value) {
                                                                    List<ClickupTag>?
                                                                        tags =
                                                                        List.from(
                                                                            state.taskParams?.tags ??
                                                                                [],
                                                                            growable:
                                                                                true);
                                                                    if (value ==
                                                                        true) {
                                                                      tags.add(
                                                                          e);
                                                                    } else {
                                                                      tags.remove(
                                                                          e);
                                                                    }
                                                                    taskPopUpBloc.add(UpdateClickupTaskParamsEvent(
                                                                        taskParams:
                                                                            clickupTaskParams.copyWith(tags: tags)));
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

                          Wrap(
                            children: [

                              ///TODO B create a new Folder
                              ///Folder
                              if (state.isFoldersListAvailable && task == null)
                                DropdownButton<ClickupFolder?>(
                                  hint:
                                      Text(appLocalization.translate("folder")),
                                  value: state.taskParams?.folder,
                                  onChanged: (folder) => folder == null
                                      ? taskPopUpBloc.add(
                                          UpdateClickupTaskParamsEvent(
                                              taskParams: clickupTaskParams
                                                  .copyWith(clearFolder: true)))
                                      : taskPopUpBloc.add(
                                          UpdateClickupTaskParamsEvent(
                                              taskParams: clickupTaskParams
                                                  .copyWith(folder: folder))),
                                  items: (state
                                              .taskParams?.clickupSpace?.folders
                                              .map((e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text(e.name ?? "")))
                                              .toList() ??
                                          []) +
                                      [
                                        DropdownMenuItem(
                                            value: null,
                                            child: Text(appLocalization
                                                .translate("clear")))
                                      ],
                                )
                              else if (task?.folder != null)
                                Text(" ${task?.folder?.name ?? ""} "),

                              ///TODO B create a new list
                              ///List
                              if (task == null &&
                                  state.taskParams?.clickupList == null &&
                                  (state.taskParams?.getAvailableLists
                                          .isNotEmpty ==
                                      true))
                                DropdownButton<ClickupList>(
                                  elevation: 0,
                                  hint: Text(appLocalization.translate("list")),
                                  value: state.taskParams?.clickupList,
                                  onChanged: (list) => taskPopUpBloc.add(
                                      UpdateClickupTaskParamsEvent(
                                          taskParams: clickupTaskParams
                                              .copyWith(clickupList: list))),
                                  items: state.taskParams?.getAvailableLists
                                          .map((e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(e.name ?? "")))
                                          .toList() ??
                                      [],
                                )
                              else if(task == null &&
                                  state.taskParams?.clickupList != null)
                                Text(" ${state.taskParams?.clickupList?.name ?? ""} ")
                              else if(task!=null)
                                Text(" ${task.list?.name ?? ""} "),
                            ],
                          ),

                          Wrap(
                            children: [
                              ///isAllDay
                              Checkbox(
                                  value: taskPopupParams.isAllDay,
                                  onChanged: null),
                              ///All day Date
                              if(taskPopupParams.isAllDay)CustomButton(
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
                                    ).then((value) =>
                                      taskPopUpBloc.add(
                                          UpdateClickupTaskParamsEvent(
                                              taskParams: clickupTaskParams
                                                  .copyWith(startDate: value))));
                                },
                                customButtonEnum: CustomButtonEnum.secondary,
                                child: Text(
                                    " ${appLocalization.translate("date")}"
                                      " ${DateTimeExtensions.customToString
                                      (state.taskParams?.startDate,
                                        includeTime: false) ?? ""} "),
                                ),

                              ///Start DATE
                              if (taskPopupParams.isAllDay == false)
                                CustomButton(
                                  onPressed: () {
                                    showDateTimePicker(
                                      context: context,
                                      initialDate:
                                          initialStartDate ?? DateTime.now(),
                                      firstDate: firstDate,
                                      lastDate: lastDate,
                                    ).then((value) => taskPopUpBloc.add(
                                        UpdateClickupTaskParamsEvent(
                                            taskParams: clickupTaskParams
                                                .copyWith(startDate: value))));
                                  },
                                  customButtonEnum: CustomButtonEnum.secondary,
                                  child: Text(
                                      " ${appLocalization.translate("startDate")}"
                                      " ${DateTimeExtensions.customToString(state.taskParams?.startDate) ?? ""} "),
                                ),

                              ///DUE DATE
                              if (taskPopupParams.isAllDay == false)
                                CustomButton(
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
                                  customButtonEnum: CustomButtonEnum.secondary,
                                  child: Text(
                                      " ${appLocalization.translate("dueDate")}"
                                      " ${DateTimeExtensions.customToString(state.taskParams?.dueDate) ?? ""} "),
                                ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ));
            },
          );
        },
      ),
    );
  }
}
