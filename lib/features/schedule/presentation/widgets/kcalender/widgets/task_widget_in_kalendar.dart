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
import 'package:thetimeblockingapp/features/schedule/presentation/widgets/kcalender/kalender_tasks_calendar.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/widgets/task_widget_in_calendar.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task_parameters.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/presentation/widgets/tag_chip.dart';

class TaskWidgetInKalendar extends StatelessWidget {
  const TaskWidgetInKalendar({
    super.key,
    required this.event,
    required this.tileType,
    this.taskLocation = TaskLocation.body,
    required this.onCompleteConfirmed,
    required this.onDeleteConfirmed,
    required this.viewConfiguration,
    required this.heightPerMinute,
    required this.onDelete,
    required this.onSave,
    required this.onDuplicate,
    this.onEventTapped,
  });

  const TaskWidgetInKalendar.schedule({
    super.key,
    required this.event,
    required this.tileType,
    this.taskLocation = TaskLocation.body,
    required this.onCompleteConfirmed,
    required this.onDeleteConfirmed,
    required this.viewConfiguration,
    required this.heightPerMinute,
    required this.onDelete,
    required this.onSave,
    required this.onDuplicate,
    required this.onEventTapped,
  });

  final CalendarEvent<Task> event;
  final TileType tileType;
  final TaskLocation taskLocation;
  final void Function() onCompleteConfirmed;
  final void Function() onDeleteConfirmed;
  final ViewConfiguration viewConfiguration;
  final double? heightPerMinute;

  final void Function(DeleteTaskParams) onDelete;
  final void Function(CreateTaskParams) onSave;
  final void Function(CreateTaskParams) onDuplicate;
  final void Function()? onEventTapped;

  @override
  Widget build(BuildContext context) {
    return TaskWidgetInCalendar(
        task: event.data!,
        onEventTapped: onEventTapped,
        taskLocation: taskLocation,
        tileType: tileType,
        onCompleteConfirmed: onCompleteConfirmed,
        onDeleteConfirmed: onDeleteConfirmed,
        calendarViewType: viewConfiguration.getCalendarViewType,
        heightPerMinute: heightPerMinute,
        onDelete: onDelete,
        onSave: onSave,
        onDuplicate: onDuplicate);
  }
}
