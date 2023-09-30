import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CustomCalendar extends StatelessWidget {
  const CustomCalendar({
    super.key, this.onTap, required this.tasksDataSource,
  });
  final TasksDataSource tasksDataSource;
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
      appointmentBuilder: (context, calendarAppointmentDetails) {
        return Container(
            color: Colors.deepPurpleAccent.shade100.withOpacity(0.5),
            child: Text(calendarAppointmentDetails.appointments
                .map((e) =>
                    "${(e as Appointment).subject} ${e.notes?.isNotEmpty == true ? (": ${e.notes}") : ""}")
                .toString()));
        return Column(
          children: calendarAppointmentDetails.appointments
              .map((e) => Container(
            width: double.infinity,
              color: (e as Appointment).color,
              child: Text("${(e).subject}: ${(e).notes}")
          )).toList(),
        );
      },
    );
  }
}

class TasksDataSource extends CalendarDataSource {
  TasksDataSource({required List<Appointment> tasks}) {
    appointments = tasks;
  }
}