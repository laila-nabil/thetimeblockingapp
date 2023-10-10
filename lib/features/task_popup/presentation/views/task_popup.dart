import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thetimeblockingapp/common/widgets/custom_button.dart';
import 'package:thetimeblockingapp/common/widgets/custom_input_field.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:thetimeblockingapp/features/task_popup/presentation/bloc/task_pop_up_bloc.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_folder.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_list.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_space.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_task_use_case.dart';

import '../../../../common/widgets/custom_alert_dialog.dart';
import '../../../../core/extensions.dart';
import '../../../tasks/domain/entities/task_parameters.dart';

class TaskPopupParams {
  final ClickupTask? task;
  final void Function(ClickupTaskParams params)? onSave;
  final void Function(DeleteClickupTaskParams params)? onDelete;
  final ScheduleBloc scheduleBloc;

  TaskPopupParams({
    this.task,
    this.onSave,
    this.onDelete,
    required this.scheduleBloc,
  });
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
          create: (context) => serviceLocator<TaskPopUpBloc>(param1: task),
        ),
        BlocProvider.value(
          value: taskPopupParams.scheduleBloc,
        ),
      ],
      child: BlocBuilder<ScheduleBloc, ScheduleState>(
        builder: (context, scheduleState) {
          final isLoading = scheduleState.isLoading;
          return BlocBuilder<TaskPopUpBloc, TaskPopUpState>(
            builder: (context, state) {
              final taskPopUpBloc = BlocProvider.of<TaskPopUpBloc>(context);
              final clickupTaskParams = state.taskParams ??
                  ClickupTaskParams.unknown(
                      clickupAccessToken: Globals.clickupAuthAccessToken,
                      clickupTaskParamsEnum: task == null
                          ? ClickupTaskParamsEnum.create
                          : ClickupTaskParamsEnum.update);
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
                                      clickupList:
                                          state.taskParams!.clickupList!,
                                      title: "default title",
                                      clickupAccessToken:
                                          Globals.clickupAuthAccessToken,
                                      assignees: const [
                                        ///TODO A
                                      ]);
                                } else {
                                  params = ClickupTaskParams.updateTask(
                                      task: task,
                                      description:
                                          "new description ${DateTime.now()}",
                                      clickupAccessToken:
                                          Globals.clickupAuthAccessToken);
                                }
                                taskPopupParams.onSave!(params);
                              },
                        child: Text(appLocalization.translate("save")))
                  ],
                  content: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      children: [
                        ///Priority & Title
                        Row(
                          children: [
                            DropdownMenu<ClickupTaskPriority>(
                              width: 70,
                              initialSelection: task?.priority,
                              hintText: appLocalization.translate("priority"),
                              onSelected: (priority) => taskPopUpBloc.add(
                                  UpdateClickupTaskParamsEvent(
                                      taskParams: clickupTaskParams.copyWith(
                                          taskPriority: priority))),
                              dropdownMenuEntries: ClickupTaskPriority
                                  .getPriorityExclamationList
                                  .map((e) => DropdownMenuEntry(
                                      value: e,
                                      style: ButtonStyle(
                                          textStyle: MaterialStateProperty.all(
                                              TextStyle(
                                                  textBaseline:
                                                      TextBaseline.alphabetic,
                                                  color: task?.priority
                                                      ?.getPriorityExclamationColor))),
                                      label: e.priorityNum.toString()))
                                  .toList(),
                            ),
                            Expanded(
                                child: CustomTextInputField(
                              controller: taskPopUpBloc.titleController,
                              decoration: InputDecoration(
                                  hintText: appLocalization.translate("title")),
                              onChanged: (change) {
                                taskPopUpBloc.add(UpdateClickupTaskParamsEvent(
                                    taskParams: clickupTaskParams.copyWith(
                                        title: change)));
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
                        Expanded(
                            child: CustomTextInputField(
                          controller: taskPopUpBloc.descriptionController,
                          decoration: InputDecoration(
                            hintText: appLocalization.translate("description"),
                          ),
                          maxLines: 3,
                          onChanged: (change) {
                            taskPopUpBloc.add(UpdateClickupTaskParamsEvent(
                                taskParams: clickupTaskParams.copyWith(
                                    description: change)));
                          },
                        )),

                        ///Tags
                        Text(task?.tags?.map((e) => "#${e.name}").toString() ??
                            ""),

                        Row(
                          children: [
                            ///Space
                            DropdownMenu<ClickupSpace>(
                              hintText: appLocalization.translate("space"),
                              onSelected: (space) => taskPopUpBloc.add(
                                  UpdateClickupTaskParamsEvent(
                                      taskParams: clickupTaskParams.copyWith(
                                          clickupSpace: space))),
                              dropdownMenuEntries: (Globals.clickupSpaces)
                                      ?.map((e) => DropdownMenuEntry(
                                          value: e, label: e.name ?? ""))
                                      .toList() ??
                                  [],
                            ),

                            ///Folder
                            DropdownMenu<ClickupFolder>(
                              hintText: appLocalization.translate("folder"),
                              onSelected: (folder) => taskPopUpBloc.add(
                                  UpdateClickupTaskParamsEvent(
                                      taskParams: clickupTaskParams.copyWith(
                                          folder: folder))),
                              dropdownMenuEntries: state
                                      .taskParams?.clickupSpace?.folders
                                      .map((e) => DropdownMenuEntry(
                                          value: e, label: e.name ?? ""))
                                      .toList() ??
                                  [],
                            ),

                            ///List
                            DropdownMenu<ClickupList>(
                              hintText: appLocalization.translate("list"),
                              onSelected: (list) => taskPopUpBloc.add(
                                  UpdateClickupTaskParamsEvent(
                                      taskParams: clickupTaskParams.copyWith(
                                          clickupList: list))),
                              dropdownMenuEntries: (ClickupSpace.getAllLists(
                                          folder: state.taskParams?.folder,
                                          space:
                                              state.taskParams?.clickupSpace))
                                      .map((e) => DropdownMenuEntry(
                                              value: e, label: e.name ?? ""))
                                          .toList() ??
                                      [],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ));
            },
          );
        },
      ),
    );
  }
}
