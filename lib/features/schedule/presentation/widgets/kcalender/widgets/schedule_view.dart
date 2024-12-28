import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:logger/logger.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';
import 'package:thetimeblockingapp/common/widgetbook.dart';
import 'package:thetimeblockingapp/core/extensions.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/widgets/kcalender/widgets/task_widget_in_kalendar.dart';

/// This is the base class for all [ScheduleViewConfiguration]s.
abstract class ScheduleViewConfiguration extends ViewConfiguration {
  ScheduleViewConfiguration({required super.name});

  /// Whether to show the header or not.
  bool get showHeader;

}

class ScheduleConfiguration extends ScheduleViewConfiguration {
  ScheduleConfiguration({
    this.showHeader = true,
    required super.name,
    required this.displayRange,
  });

  final DateTimeRange displayRange;

  @override
  String get name => appLocalization.translate("schedule");

  @override
  bool showHeader;
}

class CustomScheduleView<T> extends StatefulWidget {
  CustomScheduleView({
    super.key,
    required this.controller,
    required this.eventsController,
    required this.scheduleViewConfiguration,
    this.components,
    required this.scheduleGroups,
    required this.tileBuilder,required this.itemScrollController,
  });

  /// The [CalendarController] used to control the view.
  final CalendarController<Task> controller;

  /// The [CalendarEventsController] used to control events.
  final EventsController<Task> eventsController;

  /// The [MultiDayViewConfiguration] used to configure the view.
  final ScheduleViewConfiguration scheduleViewConfiguration;

  /// The [CalendarComponents] used to build the components of the view.
  final CalendarComponents? components;

  final List<ScheduleGroup<Task>> scheduleGroups;
  final ItemScrollController itemScrollController;
  final Widget Function(
    CalendarEvent<Task> event,
  ) tileBuilder;

  /// Returns a iterable of [ScheduleGroup]s.
  /// * A [ScheduleGroup] is a group of [CalendarEvent]s that are on the same date.
  static List<ScheduleGroup<Task>> getScheduleGroups(
      {required EventsController<Task> eventsController}) {
    final scheduleGroups = <ScheduleGroup<Task>>[];

    for (final event in eventsController.events) {
      for (final date in event.datesSpanned) {
        final index = scheduleGroups.indexWhere(
              (element) => element.date == date,
        );

        if (index == -1) {
          final isFirstOfMonth = !scheduleGroups.any(
                (group) => group.date.startOfMonth == date.startOfMonth,
          );

          scheduleGroups.add(
            ScheduleGroup<Task>(
              date: date,
              events: [event],
              isFirstOfMonth: isFirstOfMonth,
            ),
          );
        } else {
          scheduleGroups[index].addEvent(event);
        }
      }
    }

    // Sort events in each ScheduleGroup by start date
    for (final group in scheduleGroups) {
      group.events.sort((a, b) => a.start.compareTo(b.start));
    }

    return scheduleGroups..sort((a, b) => a.date.compareTo(b.date));
  }

  @override
  State<CustomScheduleView<T>> createState() => _CustomScheduleViewState<T>();
}

class _CustomScheduleViewState<T> extends State<CustomScheduleView<T>> {
  @override
  void deactivate() {
    widget.controller.detach();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return _ScheduleContent<Task>(
      controller: widget.controller,
      viewConfiguration: widget.scheduleViewConfiguration,
      eventsController: widget.eventsController,
      tileBuilder: widget.tileBuilder,
      itemScrollController: widget.itemScrollController,
      scheduleGroups: widget.scheduleGroups,
    );
  }
}

class _ScheduleContent<T> extends StatefulWidget {
  const _ScheduleContent({
    super.key,
    required this.controller,
    required this.viewConfiguration,
    required this.eventsController,
    required this.tileBuilder, required this.scheduleGroups, required this.itemScrollController,
  });

  final CalendarController<Task> controller;
  final ScheduleViewConfiguration viewConfiguration;
  final EventsController<Task> eventsController;
  final List<ScheduleGroup<Task>> scheduleGroups;
  final ItemScrollController itemScrollController;
  final Widget Function(
    CalendarEvent<Task> event,
  ) tileBuilder;

  @override
  State<_ScheduleContent<T>> createState() => _ScheduleContentState<T>();
}

class _ScheduleContentState<T> extends State<_ScheduleContent<T>> {
  ItemPositionsListener? itemPositionsListener;


  @override
  void initState() {
    itemPositionsListener = ItemPositionsListener.create();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) => _jumpToStartDate(),
    );

  }

  void animateToToday(){
    final today = DateTime.now();
    final index = widget.scheduleGroups.indexWhere((group) => group.date.isSameDay(today));

    if (index != -1) {
      widget.itemScrollController?.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.eventsController,
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: ScrollablePositionedList.builder(
            itemCount: widget.scheduleGroups.length,
            itemBuilder: (context, index) {
              final scheduleGroup = widget.scheduleGroups[index];

              var scheduleMonthHeaderStyle = ScheduleMonthHeaderStyle();
              final date =scheduleGroup.date;
              void onTapped(DateTime date){
                ///TODO
              }
              var dateNumTextStyle = AppTextStyle.getTextStyle(
                  AppTextStyleParams(
                      appFontSize: AppFontSize.paragraphXSmall,
                      color: AppColors.black(context.isDarkMode),
                      appFontWeight: AppFontWeight.regular));
              return Column(
                children: [
                  if (scheduleGroup.isFirstOfMonth)
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: scheduleMonthHeaderStyle.padding,
                            margin: scheduleMonthHeaderStyle.margin,
                            decoration: BoxDecoration(
                              color: scheduleMonthHeaderStyle.monthColors[date.month] ?? Colors.transparent,
                            ),
                            child: Text(
                                scheduleMonthHeaderStyle.stringBuilder
                                        ?.call(date) ??
                                    '${date.year} - ${DateFormat.MMMM(appLocalization.getCurrentLocale(context).toLanguageTag()).format(date)}',
                                style: scheduleMonthHeaderStyle.textStyle),
                          ),
                        ),
                      ],
                    ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: <Widget>[
                            Text(
                              DateFormat('EEE',appLocalization.getCurrentLocale(context).toLanguageTag()).format(date),
                              style: AppTextStyle.getTextStyle(
                                  AppTextStyleParams(
                                      appFontSize: AppFontSize.paragraphXSmall,
                                      color: AppColors.black(context.isDarkMode),
                                      appFontWeight: AppFontWeight.regular)),
                            ),
                            date.isToday
                                ? IconButton.filledTonal(
                              onPressed: () => onTapped(date),
                              icon: Text(
                                date.day.toString(),
                                style: dateNumTextStyle,
                              ),
                            )
                                : IconButton(
                              onPressed: () => onTapped(date),
                              icon: Text(
                                date.day.toString(),
                                style: dateNumTextStyle,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            children: scheduleGroup.events
                                .map((event) => Row(
                                      children: [
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: widget.tileBuilder(
                                                                                      event,
                                                                                    ),
                                            )),
                                      ],
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ScheduleDateTile<T>(
                  //   scheduleGroup: scheduleGroup,
                  // ),
                ],
              );
            },
            itemScrollController: widget.itemScrollController,
            itemPositionsListener: itemPositionsListener,
          ),
        );
      },
    );

  }

  void _jumpToStartDate() {
    if (widget.scheduleGroups.isEmpty) return;

    final date = DateTime.now();

    var index = widget.scheduleGroups.indexWhere(
      (group) => group.date.isSameDay(date),
    );

    if (index == -1) {
      index = widget.scheduleGroups.indexWhere(
        (group) => AppConfig.firstDayOfWeek == date.startOfWeek,
      );
    }

    if (index == -1) {
      index = widget.scheduleGroups.indexWhere(
        (group) => group.date.startOfMonth == date.startOfMonth,
      );
    }

    if (index == -1) {
      index = widget.scheduleGroups.length ~/ 2;
    }

    widget.itemScrollController?.jumpTo(index: index);
  }
}

class ScheduleGroup<T> {
  const ScheduleGroup({
    required this.isFirstOfMonth,
    required this.date,
    required this.events,
  });

  final DateTime date;
  final List<CalendarEvent<T>> events;

  final bool isFirstOfMonth;

  void addEvent(CalendarEvent<T> event) {
    if (!events.contains(event)) {
      events.add(event);
    }
  }
}

/// The [ScheduleMonthHeaderStyle] class is used by the default [ScheduleMonthHeader] widget.
class ScheduleMonthHeaderStyle {
  const ScheduleMonthHeaderStyle({
    this.textStyle,
    this.monthColors = const {
      1: Color(0xFFE57373),
      2: Color(0xFFF06292),
      3: Color(0xFFBA68C8),
      4: Color(0xFF9575CD),
      5: Color(0xFF7986CB),
      6: Color(0xFF64B5F6),
      7: Color(0xFF4FC3F7),
      8: Color(0xFF4DD0E1),
      9: Color(0xFF4DB6AC),
      10: Color(0xFF81C784),
      11: Color(0xFFAED581),
      12: Color(0xFFFF8A65),
    },
    this.margin = const EdgeInsets.only(top: 8),
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
    this.stringBuilder,
  });

  final Map<int, Color> monthColors;
  final TextStyle? textStyle;
  final EdgeInsets margin;
  final EdgeInsets padding;

  /// Use this function to customize the sting displayed by the [ScheduleMonthHeader].
  final String Function(DateTime date)? stringBuilder;
}
