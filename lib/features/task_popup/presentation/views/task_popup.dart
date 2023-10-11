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
import '../../../startup/presentation/bloc/startup_bloc.dart';
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
          final isLoadingScheduleState = scheduleState.isLoading;
          return BlocBuilder<TaskPopUpBloc, TaskPopUpState>(
            builder: (context, state) {
              final taskPopUpBloc = BlocProvider.of<TaskPopUpBloc>(context);
              final clickupTaskParams = state.taskParams ??
                  ClickupTaskParams.unknown(
                      clickupAccessToken: Globals.clickupAuthAccessToken,
                      clickupTaskParamsEnum: task == null
                          ? ClickupTaskParamsEnum.create
                          : ClickupTaskParamsEnum.update);
              final isLoading = isLoadingScheduleState ;
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
                              clickupAccessToken:
                              Globals.clickupAuthAccessToken,
                              assignees: [
                                ClickupAssignees(
                                    id: Globals.clickupUser?.id)
                              ],
                              title: state.taskParams?.title ?? "",
                              description: state.taskParams?.description,
                            );
                          } else {
                            params = ClickupTaskParams.updateTask(
                              task: task,
                              clickupAccessToken:
                              Globals.clickupAuthAccessToken,
                              title: state.taskParams?.title,
                              description: state.taskParams?.description,
                            );
                          }
                          taskPopupParams.onSave!(params);
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
                          CustomTextInputField(
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
                          ),

                          ///FIXME tags not viewed
                          ///Tags
                          DropdownMenu<ClickupTag>(
                            hintText: appLocalization.translate("tags"),
                            onSelected: (tag) {
                              if (tag != null) {
                                taskPopUpBloc.add(UpdateClickupTaskParamsEvent(
                                    taskParams:
                                    clickupTaskParams.copyWith(tags: [tag])));
                              }
                            },
                            dropdownMenuEntries: state.taskParams?.clickupSpace?.tags
                                .map((e) => DropdownMenuEntry(
                                value: e,
                                style: ButtonStyle(
                                    textStyle: MaterialStateProperty.all(
                                        TextStyle(
                                            textBaseline:
                                            TextBaseline.alphabetic,
                                            color: task?.priority
                                                ?.getPriorityExclamationColor))),
                                label: e.name.toString()))
                                .toList() ?? <DropdownMenuEntry<ClickupTag>>[],
                          ),

                          Wrap(
                            children: [
                              ///TODO create a new Space
                              ///Space
                              DropdownMenu<ClickupSpace>(
                                hintText: appLocalization.translate("space"),
                                initialSelection: state.taskParams?.clickupSpace,
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

                              ///TODO create a new Folder
                              ///FIXME in case a folderless List selected,it must not selected
                              ///FIXME in case space changed,it must not selected
                              ///Folder
                              if (state.taskParams?.clickupSpace?.folders
                                  .isNotEmpty ==
                                  true)
                                DropdownMenu<ClickupFolder>(
                                  hintText: appLocalization.translate("folder"),
                                  initialSelection: state.taskParams?.folder,
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

                              ///TODO create a new list
                              ///FIXME lists not viewed
                              ///FIXME in case folder changed,it must not selected
                              ///FIXME in case space changed,it must not selected
                              ///List
                              if (state.taskParams?.getAvailableLists.isNotEmpty ==
                                  true)
                                DropdownMenu<ClickupList>(
                                  hintText: appLocalization.translate("list"),
                                  initialSelection: state.taskParams?.clickupList,
                                  onSelected: (list) => taskPopUpBloc.add(
                                      UpdateClickupTaskParamsEvent(
                                          taskParams: clickupTaskParams
                                              .copyWith(clickupList: list))),
                                  dropdownMenuEntries: state
                                          .taskParams?.getAvailableLists
                                          .map((e) => DropdownMenuEntry(
                                              value: e, label: e.name ?? ""))
                                          .toList() ??
                                      [],
                                ),
                            ],
                          ),

                          Text(
                              "selectedWorkspace: ${Globals.selectedWorkspace?.name.toString()}"),
                          Text(
                              "clickupSpace: ${state.taskParams?.clickupSpace?.name}"),
                          Text(
                              "tags: ${state.taskParams?.clickupSpace?.tags.map((e) => e.name)}"),
                          Text(
                              "clickupSpace.folders: ${state.taskParams?.clickupSpace?.folders.map((e) => e.name)}"),
                          Text("folder: ${state.taskParams?.folder?.name}"),
                          Text("list in space: ${state.taskParams?.clickupSpace?.lists.map((e) => e.name)}"),
                          Text("list in folder: ${state.taskParams?.folder?.lists?.map((e) => e.name)}"),
                          Text("getAvailableLists: ${state.taskParams?.getAvailableLists?.map((e) => e.name)}"),
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
