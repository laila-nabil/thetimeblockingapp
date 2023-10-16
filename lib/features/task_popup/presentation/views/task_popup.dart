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
import 'package:thetimeblockingapp/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:thetimeblockingapp/features/task_popup/presentation/bloc/task_pop_up_bloc.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_folder.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_list.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_space.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_task_use_case.dart';
import '../../../../common/widgets/custom_alert_dialog.dart';
import '../../../../common/widgets/custom_input_date_picker_form_field.dart';
import '../../../tasks/domain/entities/task_parameters.dart';

class TaskPopupParams extends Equatable {
  final ClickupTask? task;
  final void Function(ClickupTaskParams params)? onSave;
  final void Function(DeleteClickupTaskParams params)? onDelete;
  final ScheduleBloc scheduleBloc;
  final DateTime? cellDate;

  const TaskPopupParams({
    this.task,
    this.onSave,
    this.onDelete,
    this.cellDate,
    required this.scheduleBloc,
  });

  DateTime? get startDate => dueDate?.subtract(const Duration(hours: 1));

  DateTime? get dueDate => cellDate;

  TaskPopupParams copyWith({
    ClickupTask? task,
    void Function(ClickupTaskParams params)? onSave,
    void Function(DeleteClickupTaskParams params)? onDelete,
    ScheduleBloc? scheduleBloc,
    DateTime? cellDate,
  }) {
    return TaskPopupParams(
        task: task ?? this.task,
        onSave: onSave ?? this.onSave,
        onDelete: onDelete ?? this.onDelete,
        scheduleBloc: scheduleBloc ?? this.scheduleBloc,
        cellDate: cellDate ?? this.cellDate);
  }

  @override
  List<Object?> get props => [
        task,
        onSave,
        onDelete,
        cellDate,
        scheduleBloc,
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
                          startDate: taskPopupParams.startDate
                        )
                      : ClickupTaskParams.startUpdateTask(
                          clickupAccessToken: Globals.clickupAuthAccessToken,
                          task: task,
                        )));
          },
        ),
        BlocProvider.value(
          value: taskPopupParams.scheduleBloc,
        ),
      ],
      child: BlocBuilder<ScheduleBloc, ScheduleState>(
        builder: (context, scheduleState) {
          final isLoadingScheduleState = scheduleState.isLoading;
          return BlocBuilder<TaskPopUpBloc, TaskPopUpState>(
            builder: (context, state) {
              final taskPopUpBloc = BlocProvider.of<TaskPopUpBloc>(context);
              printDebug("state.taskParams ${state.taskParams}");
              final clickupTaskParams = state.taskParams ??
                  (task == null
                      ? ClickupTaskParams.startCreateNewTask(
                          clickupAccessToken: Globals.clickupAuthAccessToken,
                          dueDate: taskPopupParams.dueDate,
                          startDate: taskPopupParams.startDate)
                      : ClickupTaskParams.startUpdateTask(
                          clickupAccessToken: Globals.clickupAuthAccessToken,
                task: task,
              ));
              printDebug("clickupTaskParams $clickupTaskParams");
              final isLoading = isLoadingScheduleState;
              return CustomAlertDialog(
                  loading: isLoading,
                  shape: RoundedRectangleBorder(borderRadius: borderRadius),
                  contentPadding: const EdgeInsets.all(radius),
                  actions: [
                    CustomButton(
                        onPressed: () => Navigator.maybePop(context),
                        child: Text(appLocalization.translate("cancel"))),
                    CustomButton(
                        onPressed: isLoading ||
                                taskPopupParams.onSave == null ||
                                state.readyToSubmit == false
                            ? null
                            : () {
                                ClickupTaskParams params;
                                if (task == null) {
                                  params = ClickupTaskParams.createNewTask(
                                    dueDate: taskPopupParams.cellDate,
                                    clickupList: state.taskParams!.clickupList!,
                                    clickupAccessToken:
                                        Globals.clickupAuthAccessToken,
                                    title: state.taskParams?.title ?? "",
                                    description: state.taskParams?.description,
                                  );
                                } else {
                                  params = ClickupTaskParams.updateTask(
                                    task: task,
                                    clickupAccessToken:
                                        Globals.clickupAuthAccessToken,
                                    updatedTitle: state.taskParams?.title,
                                    updatedDescription: state.taskParams?.description,
                                  );
                                }
                                taskPopupParams
                                    .onSave!(state.taskParams ?? params);
                              },
                        child: Text(appLocalization.translate("save")))
                  ],
                  content: SingleChildScrollView(
                    child: SizedBox(
                      width: double.maxFinite,
                      child: Column(
                        children: [
                          ///Priority & Title
                          Row(
                            children: [
                              ///FIXME priorities list
                              if (false)
                                DropdownButton<ClickupTaskPriority>(
                                  value: task?.priority,
                                  hint: Text(
                                      appLocalization.translate("priority")),
                                  onChanged: (priority) => taskPopUpBloc.add(
                                      UpdateClickupTaskParamsEvent(
                                          taskParams:
                                              clickupTaskParams.copyWith(
                                                  taskPriority: priority))),
                                  items: ClickupTaskPriority
                                      .getPriorityExclamationList
                                      .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(
                                              e.priorityNum.toString(),
                                              style: TextStyle(
                                                  textBaseline:
                                                      TextBaseline.alphabetic,
                                                  color: task?.priority
                                                      ?.getPriorityExclamationColor),
                                            ),
                                          ))
                                      .toList(),
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
                              )),
                              if (taskPopupParams.task != null)
                                IconButton(
                                    onPressed: taskPopupParams.onDelete == null
                                        ? null
                                        : () => taskPopupParams.onDelete!(
                                            DeleteClickupTaskParams(
                                                task: taskPopupParams.task!,
                                                clickupAccessToken: Globals
                                                    .clickupAuthAccessToken)),
                                    icon: const Icon(Icons.delete))
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
                          DropdownButton<ClickupTag>(
                            hint: Text(appLocalization.translate("tags")),
                            onChanged: (tag) {
                              if (tag != null) {
                                taskPopUpBloc.add(UpdateClickupTaskParamsEvent(
                                    taskParams: clickupTaskParams
                                        .copyWith(tags: [tag])));
                              }
                            },
                            items: state.taskParams?.clickupSpace?.tags
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(
                                            e.name.toString(),
                                            style: TextStyle(
                                                textBaseline:
                                                    TextBaseline.alphabetic,
                                                color: task?.priority
                                                    ?.getPriorityExclamationColor),
                                          ),
                                        ))
                                    .toList() ??
                                [],
                          ),

                          Wrap(
                            children: [
                              ///TODO create a new Space
                              ///Space
                              DropdownButton<ClickupSpace>(
                                hint: Text(appLocalization.translate("space")),
                                value: state.taskParams?.clickupSpace,
                                onChanged: (space) => taskPopUpBloc.add(
                                    UpdateClickupTaskParamsEvent(
                                        taskParams: clickupTaskParams.copyWith(
                                            clickupSpace: space))),
                                items: (Globals.clickupSpaces)
                                        ?.map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e.name ?? "")))
                                        .toList() ??
                                    [],
                              ),

                              ///TODO create a new Folder
                              ///Folder
                              if (state.taskParams?.clickupSpace?.folders
                                      .isNotEmpty ==
                                  true || state.taskParams?.folder !=null )
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
                                ),

                              ///TODO create a new list
                              ///List
                              if (state.taskParams?.getAvailableLists
                                      .isNotEmpty ==
                                  true || state.taskParams?.clickupList !=null )
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
                                ),
                            ],
                          ),

                          Wrap(
                            children: [
                              Text(task?.startDateUtc?.formatDateTime ??
                                  taskPopupParams.cellDate?.formatDateTime ??
                                  appLocalization.translate("startDate")),
                              ///Start DATE
                              CustomInputDatePickerFormField(
                                  fieldLabelText:
                                      appLocalization.translate("startDate"),
                                  firstDate: DateTime.now()
                                      .subtract(const Duration(days: 1000)),
                                  initialDate: task?.startDateUtc ??
                                      taskPopupParams.cellDate,
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 1000))),

                              ///DUE DATE
                              InputDatePickerFormField(
                                  fieldLabelText:
                                      appLocalization.translate("dueDate"),
                                  fieldHintText:
                                      appLocalization.translate("dueDate"),
                                  firstDate: DateTime.now()
                                      .subtract(const Duration(days: 1000)),
                                  initialDate: task?.dueDateUtc ??
                                      taskPopupParams.cellDate ??
                                      DateTime.now(),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 1000))),
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
