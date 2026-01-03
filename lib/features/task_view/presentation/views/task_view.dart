import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:thetimeblockingapp/common/entities/folder.dart';
import 'package:thetimeblockingapp/common/entities/priority.dart';
import 'package:thetimeblockingapp/common/entities/status.dart';
import 'package:thetimeblockingapp/common/entities/tag.dart';
import 'package:thetimeblockingapp/common/entities/task_folder_list.dart';
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/common/enums/backend_mode.dart';
import 'package:thetimeblockingapp/common/widgets/custom_button.dart';
import 'package:thetimeblockingapp/common/widgets/custom_text_input_field.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';
import 'package:thetimeblockingapp/core/extensions.dart';
import 'package:thetimeblockingapp/core/functions.dart';

import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/core/resources/app_icons.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';
import 'package:thetimeblockingapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:thetimeblockingapp/features/global/presentation/bloc/global_bloc.dart';
import 'package:thetimeblockingapp/common/entities/tasks_list.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task_date_time.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_task_use_case.dart';
import '../../../../common/dialogs/show_date_time_picker.dart';
import '../../../../common/entities/user.dart';
import '../../../../common/widgets/custom_alert_dialog.dart';
import '../../../../common/widgets/custom_drop_down.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../tasks/domain/entities/task_parameters.dart';
import '../../../tasks/presentation/widgets/tag_chip.dart';

///TODO Z smart auto complete like Notion's / to select a list,tags,due date and start date
///TODO once start date is selected when creating task from floating button,end date is start + defaultTaskDuration
///TODO Z input task duration

// ignore: must_be_immutable
class TaskViewParams extends Equatable {
  Task? task;
  final void Function(CreateTaskParams params) onSave;
  void Function()? onDuplicate;
  final void Function(DeleteTaskParams params)? onDelete;
  final Bloc bloc;
  final bool Function(Object? state) isLoading;
  DateTime? start;
  DateTime? startDate;
  DateTime? dueDate;
  late bool isAllDay;
  TasksList? list;
  Folder? folder;
  Workspace? workspace;
  Tag? tag;
  TaskStatus? status;
  TaskPriority? priority;

  TaskViewParams.openNotAllDayTask({
    required this.task,
    required this.onSave,
    required this.onDelete,
    required this.onDuplicate,
    this.start,
    required this.bloc,
    required this.isLoading,
  }) {
    start = task?.startDate ?? start;
    dueDate = task?.dueDate ??
        start?.add(serviceLocator<AppConfig>().defaultTaskDuration);
    isAllDay = false;
    list = task?.list;
    status = task?.status;
    priority = task?.priority;
    folder = task?.folder;
    workspace = task?.workspace;
  }

  TaskViewParams.notAllDayTask({
    this.task,
    required this.onSave,
    this.onDelete,
    this.start,
    DateTime? end,
    required this.bloc,
    required this.isLoading,
  }) {
    start = task?.startDate ?? start;
    dueDate = end ?? task?.dueDate ?? start?.add(serviceLocator<AppConfig>().defaultTaskDuration);
    isAllDay = false;
    list = null;
  }

  TaskViewParams.allDayTask({
    this.task,
    required this.onSave,
    this.onDelete,
    this.start,
    required this.bloc,
    required this.isLoading,
  }) {
    if (start != null) {
      start = DateTime(start!.year, start!.month, start!.day, 4);
      dueDate = start;
    }
    isAllDay = true;
    list = null;
  }

  TaskViewParams.addToList({
    required this.onSave,
    this.onDelete,
    required this.list,
    this.folder,
    required this.bloc,
    required this.isLoading,
    required this.workspace,
  }) {
    task = null;
    isAllDay = false;
    start = null;
  }

  TaskViewParams.open({
    required this.task,
    required this.onSave,
    required this.onDelete,
    required this.bloc,
    required this.isLoading, this.onDuplicate,
  }) {
    start = task?.startDate;
    dueDate = task?.dueDate;
    isAllDay = task?.isAllDay ?? false;
    start = null;
    list = task?.list;
    workspace = task?.workspace;
    priority = task?.priority;
    folder = task?.folder;
    status = task?.status;
  }

  TaskViewParams.addToTag({
    required this.onSave,
    this.onDelete,
    required this.tag,
    required this.bloc,
    required this.isLoading,
  }) {
    task = null;
    isAllDay = false;
    start = null;
    list = null;
  }

  TaskViewParams.openFromTag({
    required this.task,
    required this.onSave,
    required this.onDelete,
    required this.bloc,
    required this.isLoading,
  }) {
    start = task?.startDate;
    dueDate = task?.dueDate;
    isAllDay = task?.isAllDay ?? false;
    start = null;
    list = task?.list;
  }

  TaskViewParams._({this.task,
    required this.onSave,
    this.onDelete,
    required this.bloc,
    required this.isLoading,
    this.start,
    this.list,
    this.startDate,
    this.dueDate});

  TaskViewParams copyWith({
    Task? task,
    void Function(CreateTaskParams params)? onSave,
    void Function(DeleteTaskParams params)? onDelete,
    Bloc? bloc,
    DateTime? start,
    DateTime? startDate,
    DateTime? dueDate,
    TasksList? list,
  }) {
    return TaskViewParams._(
      task: task ?? this.task,
      onSave: onSave ?? this.onSave,
      onDelete: onDelete ?? this.onDelete,
      bloc: bloc ?? this.bloc,
      list: list ?? this.list,
      isLoading: isLoading,
      start: start ?? this.start,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  @override
  List<Object?> get props =>
      [
        task,
        onSave,
        onDelete,
        bloc,
        isLoading,
        start,
        list,
        start,
        dueDate
      ];
}

Future showTaskPopup({
  required BuildContext context,
  required TaskViewParams taskViewParams,
}) {
  if(isTaskViewBottomSheet(context)){
    return showModalBottomSheet(
        context: context,
        useSafeArea: true,
        elevation: 0,
        isScrollControlled: true,
        builder: (ctx) {
          return TaskView(
            taskViewParams: taskViewParams,
          );
        });
  }
  return showDialog(
      context: context,
      builder: (ctx) {
        return TaskView(
          taskViewParams: taskViewParams,
        );
      });
}

bool isTaskViewBottomSheet(BuildContext context) =>
    isMobileDevice() || context.showSmallDesign;

class TaskView extends StatefulWidget {
  const TaskView({super.key, required this.taskViewParams});

  final TaskViewParams taskViewParams;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {

  bool showBorderCustomDropDown = true;

  late TextEditingController titleController;
  late FocusNode titleFocusNode;

  late TextEditingController descriptionController;

  late FocusNode descriptionFocusNode;

  late CreateTaskParams taskParams;

  bool get readyToSubmit {
    printDebug("this one");
    if (taskParams.task == null) {
      return taskParams.title != null;
    } else {
      return (taskParams.title != taskParams.task?.title ||
          taskParams.description != taskParams.task?.description ||
          taskParams.list != taskParams.task?.list ||
          taskParams.tags != taskParams.task?.tags ||
          taskParams.taskPriority != taskParams.task?.priority ||
          taskParams.taskStatus != taskParams.task?.status ||
          taskParams.dueDate != taskParams.task?.dueDate ||
          taskParams.startDate != taskParams.task?.startDate);
    }
  }

  CreateTaskParams onSaveTaskParams(DateTime? newTaskDueDate,
      User user,{required TasksList defaultList}) {
    CreateTaskParams params;
    final task = taskParams.task;
    if (task != null) {
      params = CreateTaskParams.updateTask(
          defaultList: defaultList,
          task: taskParams.task!,

          updatedTitle: taskParams.title,
          updatedDescription: taskParams.description,
          updatedTags: taskParams.tags == task.tags ? null : taskParams.tags,
          updatedDueDate:
          taskParams.dueDate == task.dueDate ? null : taskParams.dueDate,
          updatedStartDate: taskParams.startDate == task.startDate
              ? null
              : taskParams.startDate,
          updatedTaskPriority: taskParams.taskPriority == task.priority
              ? null
              : taskParams.taskPriority,
          updatedTaskStatus: taskParams.taskStatus == task.status
              ? null
              : taskParams.taskStatus,
          updatedParentTask: taskParams.parentTask == task.list
              ? null
              : taskParams.parentTask,
          folder: taskParams.folder == task.folder
              ? null
              : taskParams.folder,
          list: taskParams.list == task.list
              ? null
              : taskParams.list,
          backendMode: serviceLocator<BackendMode>().mode,
          user: user
      );
    } else {
      params = taskParams;
    }
    return params;
  }

  bool get isFoldersListAvailable =>
      taskParams.workspace?.folders
          ?.isNotEmpty ==
          true || taskParams.folder != null;

  bool get viewTagsButton =>
      taskParams.task != null || taskParams.workspace != null;

  late bool setTaskParams = false;
  bool folderAndListDropDown = true;

  @override
  void initState() {
    titleController = TextEditingController();
    titleFocusNode = FocusNode();
    descriptionController = TextEditingController();
    descriptionFocusNode = FocusNode();
    titleController.text = widget.taskViewParams.task?.title ?? "";
    descriptionController.text = widget.taskViewParams.task?.description ?? "";
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final authState = BlocProvider.of<AuthBloc>(context).state;
    final globalState = BlocProvider.of<GlobalBloc>(context).state;
    if(setTaskParams != true){
      printDebug("globalState.selectedWorkspace!.defaultList! ${globalState.selectedWorkspace!.defaultList!}");
      taskParams = widget.taskViewParams.task == null
          ? CreateTaskParams.startCreateNewTask(
          defaultList: globalState.selectedWorkspace!.defaultList!,
          dueDate: TaskDateTime(dateTime: widget.taskViewParams.dueDate),
          startDate: TaskDateTime(dateTime: widget.taskViewParams.start),
          workspace: serviceLocator<AppConfig>().isWorkspaceAppWide
              ? globalState
              .selectedWorkspace
              : null,
          list: widget.taskViewParams.list,
          folder: widget.taskViewParams.folder,
          backendMode: serviceLocator<BackendMode>().mode,
          user: authState.user!,
          tags: widget.taskViewParams.tag != null
              ? [widget.taskViewParams.tag!]
              : [])
          : CreateTaskParams.startUpdateTask(
        defaultList: globalState.selectedWorkspace!.defaultList!,
        task: widget.taskViewParams.task!,
        backendMode: serviceLocator<BackendMode>().mode,
        user: authState.user!,
        workspace: serviceLocator<AppConfig>().isWorkspaceAppWide
            ? globalState.selectedWorkspace
            : widget.taskViewParams.task!.workspace,
        tags: widget.taskViewParams.task!.tags,
      );
      setTaskParams = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    titleController.dispose();
    titleFocusNode.dispose();
    descriptionController.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radius = AppBorderRadius.xLarge.value;
    final borderRadius = BorderRadius.circular(radius);
    var task = widget.taskViewParams.task;
    final globalState = BlocProvider
        .of<GlobalBloc>(context)
        .state;
    printDebug("taskViewParams ${widget.taskViewParams}");
    final authState = BlocProvider
        .of<AuthBloc>(context)
        .state;
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: widget.taskViewParams.bloc,
        ),
      ],
      child: BlocBuilder(
          bloc: widget.taskViewParams.bloc,
          builder: (context, blocState) {
            printDebug("taskParams $taskParams");
            final firstDate =
            DateTime.now().subtract(const Duration(days: 1000));
            final lastDate = DateTime.now().add(const Duration(days: 1000));
            final initialDueDate =
                task?.dueDate ?? widget.taskViewParams.dueDate;
            final initialStartDate =
                task?.startDate ?? widget.taskViewParams.start;
            final loading = widget.taskViewParams.isLoading(blocState);
            final spacerV = SizedBox(
              height: AppSpacing.medium16.value,
            );
            final taskLocationTextStyle = AppTextStyle.getTextStyle(
                AppTextStyleParams(
                    appFontSize: AppFontSize.paragraphSmall,
                    appFontWeight: AppFontWeight.medium,
                    color: context.isDarkMode ? AppColors
                        .grey(50) : AppColors
                        .grey(800)));
            final sectionTitle = AppTextStyle.getTextStyle(AppTextStyleParams(
                appFontSize: AppFontSize.paragraphSmall,
                color: context.isDarkMode ? AppColors
                    .grey(50): AppColors
                    .grey(900),
                appFontWeight: AppFontWeight.medium));
            var selectedFolder = taskParams.workspace?.folders
                ?.where((f) => f.id == taskParams.folder?.id)
                .firstOrNull;
            return CustomAlertDialog(
                loading: loading,
                elevation: isTaskViewBottomSheet(context) ? 0 : null,
                shape: isTaskViewBottomSheet(context)
                    ? RoundedRectangleBorder(side: BorderSide.none)
                    : RoundedRectangleBorder(borderRadius: borderRadius),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: isTaskViewBottomSheet(context)
                        ? 0
                        : AppSpacing.medium16.value,
                    vertical:isTaskViewBottomSheet(context)
                        ? 0
                        : AppSpacing.small12.value),
                actionsOverflowAlignment: OverflowBarAlignment.start,
                actionsPadding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.medium16.value,
                  vertical: AppSpacing.x2Small4.value
                ),
                actionsAlignment: MainAxisAlignment.end,
                actionsOverflowButtonSpacing: AppSpacing.xSmall8.value,
                actionsOverflowDirection: VerticalDirection.down,
                actions: [
                  if (task != null)
                    CustomButton.iconOnly(
                      icon: AppIcons.bin,
                      onPressed: widget.taskViewParams.onDelete == null
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
                                        widget.taskViewParams.onDelete!(
                                            DeleteTaskParams(
                                              task: widget.taskViewParams
                                                  .task!,
                                            ));
                                        Navigator.pop(ctx);
                                      },
                                      type: CustomButtonType
                                          .destructiveFilledLabel),
                                  CustomButton.noIcon(
                                      type: CustomButtonType.greyTextLabel,
                                      label: appLocalization
                                          .translate("cancel"),
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                      }),
                                ],
                                content: Text(
                                    "${appLocalization.translate(
                                        "areYouSureDelete")} ${widget
                                        .taskViewParams.task?.title}?"),
                              );
                            });
                      },
                      size: CustomButtonSize.small,
                      type: CustomButtonType.destructiveTextIcon,
                    ) else
                    SizedBox(
                      height: 48,
                    ),
                  if (task != null &&
                      widget.taskViewParams.onDuplicate != null)
                    CustomButton.iconOnly(
                      icon: AppIcons.copy,
                      onPressed: () {
                        widget.taskViewParams.onDuplicate!();
                      },
                      type: CustomButtonType.primaryTextIcon,
                      size: CustomButtonSize.small,
                    ),
                  CustomButton.noIcon(
                      type: CustomButtonType.greyTextLabel,
                      onPressed: () => Navigator.maybePop(context),
                      label: appLocalization.translate("cancel")),
                  CustomButton.noIcon(
                      onPressed: () {
                        printDebug("onsave");
                        printDebug("taskParams $taskParams");
                        printDebug("taskViewParams ${widget.taskViewParams}");
                        printDebug("loading $loading");
                        printDebug("readyToSubmit $readyToSubmit");
                        if (loading != true && readyToSubmit) {
                          widget.taskViewParams.onSave(onSaveTaskParams(
                            widget.taskViewParams.dueDate,
                            BlocProvider
                                .of<AuthBloc>(context)
                                .state
                                .user!,
                            defaultList: globalState.selectedWorkspace!.defaultList!
                          ));
                        }
                      },
                      label: appLocalization.translate("save")),
                ],
                content: SingleChildScrollView(
                  child: Container(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if(folderAndListDropDown)
                              CustomDropDown<TaskFolderList>(
                                isDense: true,
                                style: taskLocationTextStyle,
                                hint: Text(
                                    appLocalization.translate("list")),
                                value: taskParams
                                    .getAvailableFoldersLists()
                                    .where((fl) => fl.isSameId(
                                        folderId: taskParams.folder?.id ?? "",
                                        listId: taskParams.list?.id ?? ""))
                                    .firstOrNull,
                                onChanged: (fl) {
                                  setState(() {
                                    taskParams = taskParams.copyWith(
                                    folder: fl?.folder,
                                    list: fl?.list
                                    );
                                  });
                                },
                                items: taskParams.getAvailableFoldersLists()
                                    .map((e) =>
                                    ShadOption(
                                        selectedIcon: const SizedBox(),
                                        value: e,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.list),
                                            const SizedBox(width: 2,),
                                            Text(e.name ?? ""),
                                          ],
                                        )))
                                    .toList() ??
                                    [],
                                isDarkMode: (context.isDarkMode),
                                showBorder: showBorderCustomDropDown,
                              )
                              else Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [

                                ///TODO Create a new Folder in task view
                                ///Folder
                                if (isFoldersListAvailable)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomDropDown<Folder>(
                                        isDense: true,
                                        hint: Text(appLocalization
                                            .translate("folder")),
                                        style: taskLocationTextStyle,
                                        value: selectedFolder,
                                        icon: const Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Icon(
                                              AppIcons.chevrondown, size: 14),
                                        ),

                                        onChanged: (folder) {
                                          setState(() {
                                            if (folder == null) {
                                              taskParams = taskParams.copyWith(
                                                  clearFolder:
                                                  true);
                                            }
                                            else {
                                              taskParams = taskParams.copyWith(
                                                  folder:
                                                  folder);
                                            }
                                          });
                                        },
                                        items: (taskParams.workspace
                                            ?.folders
                                            ?.map((e) =>
                                            ShadOption(
                                                selectedIcon: const SizedBox(),
                                                value: e,
                                                child: Text(
                                                    e.name ?? "")))
                                            .toList() ??
                                            []),
                                        isDarkMode: (context.isDarkMode),
                                        showBorder: showBorderCustomDropDown,
                                      ),
                                      if(selectedFolder!=null)Container(
                                        margin: const EdgeInsetsDirectional.only(start: 8),
                                        child: InkWell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.clear,
                                                color: AppColors.error(),
                                                size: 10,
                                              ),
                                            ),
                                          onTap: (){
                                            setState(() {
                                              taskParams = taskParams.copyWith(
                                                  clearFolder:
                                                  true);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                Text(
                                  "/",
                                  style: taskLocationTextStyle,
                                ),

                                ///TODO Create a new list in task view
                                ///List
                                if ((taskParams
                                    .getAvailableLists(selectedFolder)
                                    .isNotEmpty ==
                                    true))
                                  CustomDropDown<TasksList>(
                                    isDense: true,
                                    style: taskLocationTextStyle,
                                    hint: Text(
                                        appLocalization.translate("list")),
                                    value: taskParams
                                        .getAvailableLists(selectedFolder)
                                        .where((l) =>
                                    l.id ==
                                        taskParams.list?.id)
                                        .firstOrNull,
                                    onChanged: (list) {
                                      setState(() {
                                        taskParams = taskParams.copyWith(
                                            list: list);
                                      });
                                    },
                                    items: taskParams.getAvailableLists(
                                        selectedFolder)
                                        .map((e) =>
                                        ShadOption(
                                            selectedIcon: const SizedBox(),
                                            value: e,
                                            child: Text(e.name ?? "")))
                                        .toList() ??
                                        [],
                                    isDarkMode: (context.isDarkMode),
                                    showBorder: showBorderCustomDropDown,
                                  ),
                              ],
                            ),
                            spacerV,

                            ///Status && Priority
                            Wrap(
                              direction: Axis.horizontal,
                              spacing: AppSpacing.medium16.value,
                              runSpacing: AppSpacing.medium16.value,
                              children: [

                                ///Status
                                if(globalState.statuses?.isNotEmpty == true)
                                  CustomDropDown<TaskStatus>(
                                    value: globalState.statuses
                                        ?.where((s) =>
                                    s.id ==
                                        taskParams.taskStatus?.id)
                                        .firstOrNull,
                                    // style: CustomDropDown
                                    //     .textStyle(context.isDarkMode),
                                    hint: Text(
                                        appLocalization.translate("status")),
                                    onChanged: (status) {
                                      setState(() {
                                        taskParams = taskParams.copyWith(
                                            taskStatus: status);
                                      });
                                    },
                                    items: globalState.statuses
                                        ?.map((e) =>
                                        ShadOption(
                                            selectedIcon: const SizedBox(),
                                            value: e,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                    e == globalState.statuses?.completedStatus
                                                        ? AppIcons
                                                        .checkboxchecked
                                                        : AppIcons.checkbox,
                                                    color: e.getColor ??
                                                        AppColors.text(context
                                                            .isDarkMode)),
                                                const SizedBox(width: 2,),
                                                Text(
                                                    e.name(appLocalization.getCurrentLanguagesEnum(context)??LanguagesEnum.ar) ?? "",
                                                    // style: CustomDropDown
                                                    //     .textStyle(
                                                    //     context.isDarkMode)
                                                    //     .copyWith(
                                                    //     color: e
                                                    //         .getColor,
                                                    //     fontWeight: taskParams
                                                    //         .taskStatus ==
                                                    //         e
                                                    //         ? AppFontWeight
                                                    //         .semiBold
                                                    //         .value
                                                    //         : null)
                                                ),
                                              ],
                                            )))
                                        .toList() ??
                                        [],
                                    isDarkMode: (context.isDarkMode),
                                    showBorder: showBorderCustomDropDown,
                                  ),

                                ///Priority
                                if(globalState.priorities?.isNotEmpty == true)
                                  CustomDropDown<TaskPriority>(
                                    value: taskParams.taskPriority,
                                    hint: Text(appLocalization
                                        .translate("priority")),
                                    onChanged: (priority) {
                                      setState(() {
                                        if(priority == null){
                                          taskParams =
                                          taskParams
                                              .copyWith(
                                              clearPriority:
                                              true);
                                        }
                                        else{
                                          taskParams =
                                          taskParams
                                              .copyWith(
                                              taskPriority:
                                              priority);
                                        }
                                      });
                                    },
                                    items: (globalState.priorities?.map((e) =>
                                        ShadOption(
                                          selectedIcon: const SizedBox(),
                                          value: e,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(AppIcons.flagbold,
                                                  color: e.getColor ??
                                                      AppColors.text(
                                                          context.isDarkMode)),
                                              const SizedBox(width: 2,),
                                              Text(
                                                e.name(appLocalization.getCurrentLanguagesEnum(context)??LanguagesEnum.en) ??
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
                                        []),
                                    isDarkMode: (context.isDarkMode),
                                    showBorder: showBorderCustomDropDown,
                                  ),
                              ],
                            ),
                            SizedBox(
                              height: AppSpacing.xSmall8.value,
                            ),

                            ///Title
                            CustomTextInputField(
                              buttonStyle: CustomTextInputFieldStyle.line,
                              focusNode: titleFocusNode,
                              controller: titleController,
                              hintText: appLocalization.translate("taskName"),
                              onChanged: (change) {
                                setState(() {
                                  taskParams = taskParams
                                      .copyWith(title: change);
                                });
                              },
                            ),
                            spacerV,

                            ///Description
                            CustomTextInputField(
                              buttonStyle: CustomTextInputFieldStyle.line,
                              focusNode: descriptionFocusNode,
                              controller: descriptionController,
                              hintText: appLocalization.translate(
                                  "description"),
                              maxLines: 3,
                              minLines: 1,
                              onChanged: (change) {
                                setState(() {
                                  taskParams = taskParams.copyWith(
                                      description: change);
                                });
                              },
                            ),
                            spacerV,
                            spacerV,
                            context.responsiveListWidgets(
                              spacingHorizontal:  AppSpacing.xSmall8.value,
                              spacingSmallVertical: AppSpacing.medium16.value,
                              spacingMediumVertical: AppSpacing.medium16.value,
                              children: [
                                Column(
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
                                    CustomButton.custom(
                                        onPressed: () {
                                          showDateTimePicker(
                                            context: context,
                                            initialDate: initialStartDate ??
                                                DateTime.now(),
                                            firstDate: firstDate,
                                            lastDate: lastDate,
                                          ).then((value) {
                                            if (value != null) {
                                              setState(() {
                                                TaskDateTime? dueDate;
                                                if (taskParams
                                                    .dueDate?.dateTime ==
                                                    null) {
                                                  dueDate = TaskDateTime(
                                                      dateTime: value.add(
                                                          serviceLocator<
                                                              AppConfig>()
                                                              .defaultTaskDuration));
                                                }
                                                taskParams =
                                                    taskParams.copyWith(
                                                        startDate:
                                                        TaskDateTime(
                                                            dateTime:
                                                            value),
                                                        dueDate: dueDate);
                                              });
                                            }
                                          });
                                        },
                                        type: CustomButtonType
                                            .greyOutlinedLabel,
                                        size: CustomButtonSize.large,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              DateTimeExtensions
                                                  .customToString(
                                                  taskParams
                                                      .startDate
                                                      ?.dateTime,
                                                  isEnglish: appLocalization.isRTL(context) == false) ??
                                                  "YYYY-MM-DD HH:MM AM",
                                              overflow:
                                              TextOverflow.ellipsis,
                                            ),
                                            if(taskParams.startDate!=null)Container(
                                              margin: const EdgeInsetsDirectional.only(start: 8),
                                              child: InkWell(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons.clear,
                                                    color: AppColors.error(),
                                                    size: 10,
                                                  ),
                                                ),
                                                onTap: (){
                                                  setState(() {
                                                    taskParams = taskParams.copyWith(
                                                        startDate:
                                                        TaskDateTime(dateTime: null,cleared: true));
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        )

                                    )
                                  ],
                                ),
                                Column(
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
                                    CustomButton.custom(
                                          onPressed: () {
                                        showDateTimePicker(
                                          context: context,
                                          initialDate:
                                          initialDueDate ?? DateTime.now(),
                                          firstDate: firstDate,
                                          lastDate: lastDate,
                                        ).then((value) {
                                          if (value != null) {
                                            setState(() {
                                              taskParams =
                                                  taskParams.copyWith(
                                                      dueDate: TaskDateTime(
                                                          dateTime: value));
                                            });
                                          }
                                        });
                                      },
                                      type: CustomButtonType
                                          .greyOutlinedLabel,
                                      size: CustomButtonSize.large,
                                      child:Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            DateTimeExtensions
                                                .customToString(
                                                taskParams.dueDate
                                                    ?.dateTime,
                                                isEnglish: appLocalization.isRTL(context) == false) ??
                                                "YYYY-MM-DD HH:MM AM",
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if(taskParams.dueDate!=null)Container(
                                            margin: const EdgeInsetsDirectional.only(start: 8),
                                            child: InkWell(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.clear,
                                                  color: AppColors.error(),
                                                  size: 10,
                                                ),
                                              ),
                                              onTap: (){
                                                setState(() {
                                                  taskParams = taskParams.copyWith(
                                                      dueDate:
                                                      TaskDateTime(dateTime: null,cleared: true));
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ) ,
                                    ),
                                  ],
                                )
                              ]
                            ),
                            spacerV,

                            ///Tags
                            ///TODO reate new tags in task view
                            if (viewTagsButton)
                              Column(
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
                                    children: (taskParams.tags?.map<Widget>(
                                            (e) =>
                                            TagChip(
                                              tagName:
                                              e.name ?? '',
                                              color: e
                                                  .getColor,
                                              onDelete: () {
                                                List<Tag>?
                                                tags =
                                                List.from(
                                                    taskParams.tags ??
                                                        [],
                                                    growable:
                                                    true);
                                                tags.remove(e);
                                                setState(() {
                                                  taskParams =
                                                  taskParams.copyWith(
                                                      tags: tags);
                                                });

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
                                                        StatefulBuilder(builder: (context,setStateAlert){
                                                          return SizedBox(
                                                            height: 400,
                                                            width: 400,
                                                            child:
                                                            ListView(
                                                              children: globalState
                                                                  .selectedWorkspace
                                                                  ?.tags
                                                                  ?.map((
                                                                  e) =>
                                                                  CheckboxListTile(
                                                                      title: Row(
                                                                        children: [
                                                                          Icon(
                                                                            AppIcons
                                                                                .hashtag,
                                                                            color: e
                                                                                .getColor,
                                                                          ),
                                                                          Text(
                                                                            e
                                                                                .name ??
                                                                                "",
                                                                            style: TagChip
                                                                                .textStyle(
                                                                                AppColors
                                                                                    .text(
                                                                                    context
                                                                                        .isDarkMode)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      value: taskParams
                                                                          .tags
                                                                          ?.contains(
                                                                          e) ==
                                                                          true,
                                                                      onChanged: (
                                                                          value) {
                                                                        List<
                                                                            Tag>? tags = List
                                                                            .from(
                                                                            taskParams
                                                                                .tags ??
                                                                                [
                                                                                ],
                                                                            growable: true);
                                                                        if (value ==
                                                                            true) {
                                                                          tags
                                                                              .add(
                                                                              e);
                                                                        } else {
                                                                          tags
                                                                              .remove(
                                                                              e);
                                                                        }
                                                                        setStateAlert(() {
                                                                          taskParams =
                                                                              taskParams
                                                                                  .copyWith(
                                                                                  tags: tags);
                                                                        });
                                                                        setState(() {
                                                                          taskParams =
                                                                              taskParams
                                                                                  .copyWith(
                                                                                  tags: tags);
                                                                        });
                                                                      }))
                                                                  .toList() ??
                                                                  [],
                                                            ),
                                                          );
                                                        }),
                                                      );
                                                    });
                                              })
                                        ],
                                  )
                                ],
                              )
                          ],
                        ),
                      )
                  ),
                ));
          }
      ),
    );
  }
}
