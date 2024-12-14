import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// This is the base class for all [ScheduleViewConfiguration]s.
abstract class ScheduleViewConfiguration extends ViewConfiguration {
  ScheduleViewConfiguration({required super.name});

  /// Whether to show the header or not.
  bool get showHeader;

  @override
  int calculateDateIndex(DateTime date, DateTime startDate) {
    throw UnimplementedError();
  }

  @override
  int calculateNumberOfPages(DateTimeRange adjustedDateTimeRange) {
    throw UnimplementedError();
  }

  @override
  DateTimeRange calculateVisibleDateRangeForIndex({
    required int index,
    required DateTime calendarStart,
  }) {
    throw UnimplementedError();
  }
}

class ScheduleConfiguration extends ScheduleViewConfiguration {
  ScheduleConfiguration({
    this.showHeader = true, required super.name,
  });

  @override
  String get name => 'Schedule';

  @override
  bool showHeader;

  @override
  DateTimeRange calculateAdjustedDateTimeRange({
    required DateTimeRange dateTimeRange,
  }) {
    return DateTimeRange(
      start: dateTimeRange.start.startOfMonth,
      end: dateTimeRange.end.endOfMonth,
    );
  }

  @override
  DateTimeRange calculateVisibleDateTimeRange(DateTime date) {
    final monthRange = date.monthRange;
    return DateTimeRange(
      start: monthRange.start,
      end: monthRange.end,
    );
  }
}


// class ScheduleView<T> extends StatefulWidget {
//   const ScheduleView({
//     super.key,
//     required this.controller,
//     required this.eventsController,
//     required this.scheduleViewConfiguration,
//     required this.scheduleTileBuilder,
//     this.components,
//     this.style,
//     this.functions,
//     this.layoutDelegates,
//   });
//
//   /// The [CalendarController] used to control the view.
//   final CalendarController<T> controller;
//
//   /// The [CalendarEventsController] used to control events.
//   final CalendarEventsController<T> eventsController;
//
//   /// The [MultiDayViewConfiguration] used to configure the view.
//   final ScheduleViewConfiguration scheduleViewConfiguration;
//
//   /// The [CalendarComponents] used to build the components of the view.
//   final CalendarComponents? components;
//
//   /// The [CalendarStyle] used to style the default components.
//   final CalendarStyle? style;
//
//   /// The [CalendarEventHandlers] used to handle events.
//   final CalendarEventHandlers<T>? functions;
//
//   /// The [CalendarLayoutDelegates] used to layout the calendar's tiles.
//   final CalendarLayoutDelegates<T>? layoutDelegates;
//
//   final ScheduleTileBuilder<T> scheduleTileBuilder;
//
//   @override
//   State<ScheduleView<T>> createState() => _ScheduleViewState<T>();
// }
//
// class _ScheduleViewState<T> extends State<ScheduleView<T>> {
//   late ScheduleViewState _viewState;
//
//   @override
//   void deactivate() {
//     widget.controller.detach();
//     super.deactivate();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ListenableBuilder(
//       listenable: widget.scheduleViewConfiguration,
//       builder: (context, child) {
//         _viewState = widget.controller.attach(
//           widget.scheduleViewConfiguration,
//         ) as ScheduleViewState;
//
//         return CalendarStyleProvider(
//           style: widget.style ?? const CalendarStyle(),
//           components: widget.components ?? CalendarComponents(),
//           child: CalendarScope<T>(
//             state: _viewState,
//             eventsController: widget.eventsController,
//             functions: widget.functions ?? CalendarEventHandlers<T>(),
//             tileComponents: CalendarTileComponents<T>(
//               scheduleTileBuilder: widget.scheduleTileBuilder,
//             ),
//             platformData: PlatformData(),
//             layoutDelegates:
//             widget.layoutDelegates ?? CalendarLayoutDelegates<T>(),
//             child: Column(
//               children: <Widget>[
//                 ScheduleHeader<T>(
//                   viewConfiguration: widget.scheduleViewConfiguration,
//                   viewState: _viewState,
//                 ),
//                 Expanded(
//                   child: ScheduleContent<T>(
//                     controller: widget.controller,
//                     viewConfiguration: widget.scheduleViewConfiguration,
//                     viewState: _viewState,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

class ScheduleView extends StatelessWidget {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
