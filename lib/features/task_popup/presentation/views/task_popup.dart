
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
                              ///FIXME priorities list
                              if(false)DropdownButton<ClickupTaskPriority>(
                                value: task?.priority,
                                hint: Text(appLocalization.translate("priority")),
                                onChanged: (priority) => taskPopUpBloc.add(
                                    UpdateClickupTaskParamsEvent(
                                        taskParams: clickupTaskParams.copyWith(
                                            taskPriority: priority))),
                                items: ClickupTaskPriority
                                    .getPriorityExclamationList
                                    .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.priorityNum.toString(),
                                    style: TextStyle(
                                        textBaseline:
                                        TextBaseline.alphabetic,
                                        color: task?.priority
                                            ?.getPriorityExclamationColor),
                                    ),))
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

                          ///Tags
                          DropdownButton<ClickupTag>(
                            hint: Text( appLocalization.translate("tags")),
                            onChanged: (tag) {
                              if (tag != null) {
                                taskPopUpBloc.add(UpdateClickupTaskParamsEvent(
                                    taskParams:
                                    clickupTaskParams.copyWith(tags: [tag])));
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
                                    .toList() ?? [],
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
                                    value: e, child: Text(e.name ?? "")))
                                    .toList() ??
                                    [],
                              ),

                              ///TODO create a new Folder
                              ///Folder
                              if (state.taskParams?.clickupSpace?.folders
                                  .isNotEmpty ==
                                  true)
                                DropdownButton<ClickupFolder?>(
                                  hint: Text(appLocalization.translate("folder")),
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
                              if (state.taskParams?.getAvailableLists.isNotEmpty ==
                                  true)
                                DropdownButton<ClickupList>(
                                  elevation: 0,
                                  hint: Text(appLocalization.translate("list")),
                                  value: state.taskParams?.clickupList,
                                  onChanged: (list) => taskPopUpBloc.add(
                                      UpdateClickupTaskParamsEvent(
                                          taskParams: clickupTaskParams
                                              .copyWith(clickupList: list))),
                                  items: state
                                      .taskParams?.getAvailableLists
                                      .map((e) => DropdownMenuItem(
                                      value: e, child: Text(e.name ?? "")))
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
                          Text("getAvailableLists: ${state.taskParams?.getAvailableLists.map((e) => e.name)}"),
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
