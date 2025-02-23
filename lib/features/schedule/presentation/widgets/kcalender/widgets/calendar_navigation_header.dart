import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/widgets/kcalender/kalender_tasks_calendar.dart';
import 'package:thetimeblockingapp/features/schedule/presentation/widgets/kcalender/widgets/schedule_view.dart';

class CalendarNavigationHeader extends StatelessWidget {
  const CalendarNavigationHeader({
    super.key,
    required this.calendarController,
    required this.viewConfigurations,
    required this.currentConfiguration,
    required this.onViewConfigurationChanged,
    required this.animateToTodayScheduleView,
  });

  final CalendarController calendarController;
  final List<ViewConfiguration> viewConfigurations;
  final int currentConfiguration;
  final void Function(int index) onViewConfigurationChanged;
  final void Function() animateToTodayScheduleView;
  @override
  Widget build(BuildContext context) {
    final isScheduleView = (viewConfigurations
        .getViewConfiguration(currentConfiguration)) is ScheduleConfiguration;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final isNarrow = context.showSmallDesign;
        final dateFormat = isNarrow
            ? DateFormat(
                'MMM yyyy', appLocalization.getCurrentLangCode(context))
            : DateFormat(
                'MMMM yyyy,', appLocalization.getCurrentLangCode(context));

        final navigationRow = Row(
          mainAxisSize: MainAxisSize.min,
          children: isScheduleView ? []: [
            IconButton(
              onPressed: () {
                calendarController.animateToPreviousPage();
              },
              icon: const Icon(Icons.chevron_left, size: 28),
            ),
            IconButton(
              onPressed: () {
                calendarController.animateToNextPage();
              },
              icon: const Icon(Icons.chevron_right, size: 28),
            ),
          ],
        );

        var visibleDateTimeRange = calendarController.visibleDateTimeRange;
        if(calendarController.viewController is MonthViewController){
          visibleDateTimeRange = (calendarController.viewController as MonthViewController).visibleDateTimeRange;
        }

        final viewSelector = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < viewConfigurations.length; i++)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: OutlinedButton(
                  style: buttonStyle(currentConfiguration == i, context),
                  onPressed: () => onViewConfigurationChanged(i),
                  child: Text(viewConfigurations.getViewConfiguration(i).name),
                ),
              ),
          ],
        );

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.medium16.value,
            vertical: AppSpacing.small12.value,
          ),
          child: isNarrow
              ? Row(
                  children: [
                    navigationRow,
                    dateAndTodayRow(isScheduleView, context, visibleDateTimeRange, dateFormat),
                    Spacer(),
                    DropdownMenu<int>(
                      width: context.responsiveT<double>(params: ResponsiveTParams<double>(small: 90.0,medium: 140.0)),
                      initialSelection: currentConfiguration,
                      textStyle: AppTextStyle.getTextStyle(AppTextStyleParams(
                          appFontSize: AppFontSize.paragraphXSmall,
                          color: AppColors.text(context.isDarkMode),
                          appFontWeight: AppFontWeight.regular)),
                      dropdownMenuEntries: [
                        for (var i = 0; i < KalendarTasksCalendar.viewConfigurations(true).length; i++)
                          DropdownMenuEntry<int>(
                              value: i,
                              label: viewConfigurations.getViewConfiguration(i).name,
                              labelWidget: Text(
                                viewConfigurations.getViewConfiguration(i).name,
                                style: AppTextStyle.getTextStyle(
                                    AppTextStyleParams(
                                        appFontSize:
                                            AppFontSize.paragraphXSmall,
                                        color:
                                            AppColors.text(context.isDarkMode),
                                        appFontWeight: AppFontWeight.regular)),
                              )),
                      ],
                      enableSearch: false,
                      onSelected: (int? value) {
                        if (value == null) return;
                        onViewConfigurationChanged(value);
                      },
                      trailingIcon: Transform.translate(
                          offset: Offset(0, -5),
                          child: Icon(Icons.arrow_drop_down, size: 20)),
                      selectedTrailingIcon: Transform.translate(
                          offset: Offset(0, -5),
                          child: Icon(Icons.arrow_drop_up, size: 20)),
                      inputDecorationTheme: InputDecorationTheme(
                        alignLabelWithHint: true,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.small12.value, vertical: 0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppBorderRadius.x3Large.value),
                          borderSide: BorderSide(
                            color: AppColors.grey(context.isDarkMode)
                                .withOpacity(0.3),
                          ),
                        ),
                        constraints: BoxConstraints.tight(const
                        Size.fromHeight(32)),
                        isDense: true,
                      ),
                    )
                  ],
                )
              : Row(
                  children: [
                    navigationRow,
                    SizedBox(
                        width: context.showSmallDesign
                            ? AppSpacing.xSmall8.value
                            : AppSpacing.medium16.value),
                    Expanded(child: dateAndTodayRow(isScheduleView, context, visibleDateTimeRange, dateFormat)),
                    viewSelector,
                  ],
                ),
        );
      },
    );
  }

  Row dateAndTodayRow(
      bool isScheduleView,
      BuildContext context,
      ValueNotifier<DateTimeRange> visibleDateTimeRange,
      DateFormat dateFormat) {
    if(isScheduleView){
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          OutlinedButton(
            style: buttonStyle(false, context),
            onPressed: animateToTodayScheduleView,
            child: context.showSmallDesign
                ? Icon(Icons.today)
                : Text(
              appLocalization.translate("today"),
              style: AppTextStyle.getTextStyle(AppTextStyleParams(
                  appFontSize: AppFontSize.paragraphXSmall,
                  color: AppColors.primary(context.isDarkMode),
                  appFontWeight: AppFontWeight.regular)),
            ),
          ),
        ],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children:  [
              ValueListenableBuilder(
                  valueListenable: visibleDateTimeRange,
                  builder: (context, visibleRange, child) {
                    printDebug('visibleRange monthDifference ${visibleRange.monthDifference}');
                    return Text(
                      navigationHeaderTitle(dateFormat, visibleRange,context),
                      style: context.showSmallDesign
                          ? AppTextStyle.getTextStyle(AppTextStyleParams(
                              appFontSize: AppFontSize.paragraphMedium,
                              color: AppColors.black(context.isDarkMode),
                              appFontWeight: AppFontWeight.medium))
                          : AppTextStyle.getTextStyle(AppTextStyleParams(
                              appFontSize: AppFontSize.heading6,
                              color: AppColors.black(context.isDarkMode),
                              appFontWeight: AppFontWeight.medium)),
                    );
                  }),
              SizedBox(
                  width: context.showSmallDesign
                      ? AppSpacing.xSmall8.value
                      : AppSpacing.medium16.value),
              OutlinedButton(
                style: buttonStyle(false, context),
                onPressed: () {
                  calendarController.animateToDate(
                    DateTime.now(),
                    duration: const Duration(milliseconds: 300),
                  );
                },
                child: context.showSmallDesign
                    ? Icon(Icons.today)
                    : Text(
                        appLocalization.translate("today"),
                        style: AppTextStyle.getTextStyle(AppTextStyleParams(
                            appFontSize: AppFontSize.paragraphXSmall,
                            color: AppColors.primary(context.isDarkMode),
                            appFontWeight: AppFontWeight.regular)),
                      ),
              ),
            ],
    );
  }

  String navigationHeaderTitle(DateFormat dateFormat, DateTimeRange visibleRange,BuildContext context) {
    printDebug("visibleRange.monthDifference ${visibleRange.monthDifference}");
    printDebug("visibleRange.start ${visibleRange.start}");
    printDebug("visibleRange.end ${visibleRange.end}");
    var navigationHeaderTitle = dateFormat.format(visibleRange.start);
    if (calendarController.viewController is MonthViewController &&
        visibleRange.monthDifference == 2) {
      navigationHeaderTitle =
          "${DateFormat('MMM yyyy', appLocalization.getCurrentLangCode(context)).format(DateTime(visibleRange.start.year, visibleRange.start.month + 1, 1))}";
    }
    if (calendarController.viewController is MonthViewController &&
        visibleRange.monthDifference == 1) {
      navigationHeaderTitle =
          "${DateFormat('MMM', appLocalization.getCurrentLangCode(context)).format(visibleRange.start)}-${DateFormat('MMM yyyy', appLocalization.getCurrentLangCode(context)).format(visibleRange.end)}";
    }
    return navigationHeaderTitle;
  }

  ButtonStyle buttonStyle(bool isSelected, BuildContext context) {
    return OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      textStyle: const TextStyle(fontSize: 12),
      foregroundColor: isSelected
          ? Theme.of(context).colorScheme.onPrimary
          : Theme.of(context).colorScheme.surfaceTint,
      backgroundColor: isSelected ? Theme.of(context).primaryColor : null,
      side: BorderSide(
        color: AppColors.grey(context.isDarkMode).withOpacity(0.3),
      ),
    );
  }
}
