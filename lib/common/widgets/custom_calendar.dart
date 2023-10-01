import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';

class CustomCalendar extends StatelessWidget {
  const CustomCalendar({
    super.key, this.onTap, required this.tasksDataSource,
  });
  final ClickupTasksDataSource tasksDataSource;
  final void Function(CalendarTapDetails)? onTap;
  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      allowedViews: const [
        CalendarView.day,
        CalendarView.week,
        CalendarView.month,
      ],
      allowDragAndDrop: true,
      allowAppointmentResize: true,
      allowViewNavigation: true,
      firstDayOfWeek: 6,
      showTodayButton: true,
      dataSource: tasksDataSource,
      showNavigationArrow: true,
      appointmentBuilder: (context, calendarAppointmentDetails) {
        final task =
            calendarAppointmentDetails.appointments.first as ClickupTask;
        return Container(
            color: Colors.deepPurpleAccent.shade100.withOpacity(0.5),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (calendarAppointmentDetails.bounds.height > 20)
                    Text("${(task).folder?.name}>${(task).list?.name}"),
                  Text("${(task).name}\n${(task).description}"),
                ],
              ),
            ));
      },
    );
  }
}

class ClickupTasksDataSource extends CalendarDataSource {
  final List<ClickupTask> clickupTasks;

  ClickupTasksDataSource({required this.clickupTasks});

  @override
  DateTime getStartTime(int index) {
    return clickupTasks[index].startDate ??
        DateTime.now();
  }

  @override
  DateTime getEndTime(int index) {
    return clickupTasks[index].dueDate!;
  }

  @override
  String? getNotes(int index) {
    return clickupTasks[index].description;
  }

  @override
  Object? getId(int index) {
    return clickupTasks[index].id;
  }

  @override
  String getSubject(int index) {
    return clickupTasks[index].name ?? "";
  }

  @override
  bool isAllDay(int index) {
    return clickupTasks[index].startDate == null &&
        clickupTasks[index].dueDate != null;
  }

  @override
  List? get appointments => clickupTasks;
}