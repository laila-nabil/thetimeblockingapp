import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CustomCalendar extends StatelessWidget {
  const CustomCalendar({
    super.key, this.onTap,
  });
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
      onTap: onTap,
      firstDayOfWeek: 6,
      showTodayButton: true,
      // dataSource: ,
    );
  }
}
