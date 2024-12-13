import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kalender/kalender.dart';
import 'package:thetimeblockingapp/common/widgetbook.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/core/resources/assets_paths.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';

class CustomCalendarHeader extends StatelessWidget {
  const CustomCalendarHeader({
    super.key,
    required this.calendarController,
    required this.viewConfigurations,
    required this.currentConfiguration,
    required this.onViewConfigurationChanged,
    required this.visibleDateTimeRange,
  });

  final CalendarController calendarController;
  final List<ViewConfiguration> viewConfigurations;
  final DateTimeRange visibleDateTimeRange;
  final int currentConfiguration;
  final void Function(int index) onViewConfigurationChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final isNarrow = context.showSmallDesign;
        final dateFormat =
            isNarrow ? DateFormat('MMM yyyy') : DateFormat('MMMM yyyy');

        final navigationRow = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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

        final dateAndTodayRow = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dateFormat.format(calendarController.visibleMonth!),
              style: context.showSmallDesign
                  ? AppTextStyle.getTextStyle(AppTextStyleParams(
                  appFontSize: AppFontSize.paragraphMedium,
                  color: AppColors.black(context.isDarkMode),
                  appFontWeight: AppFontWeight.medium))
                  : AppTextStyle.getTextStyle(AppTextStyleParams(
                  appFontSize: AppFontSize.heading6,
                  color: AppColors.black(context.isDarkMode),
                  appFontWeight: AppFontWeight.medium)),
            ),
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
              child: context.showSmallDesign ? Icon(Icons.today): Text(
                appLocalization.translate("today"),
                style: AppTextStyle.getTextStyle(AppTextStyleParams(
                    appFontSize: AppFontSize.paragraphXSmall,
                    color: AppColors.primary(context.isDarkMode),
                    appFontWeight: AppFontWeight.regular)),
              ),
            ),
          ],
        );

        final viewSelector = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < viewConfigurations.length; i++)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: OutlinedButton(
                  style: buttonStyle(currentConfiguration == i, context),
                  onPressed: () => onViewConfigurationChanged(i),
                  child: Text(viewConfigurations[i].name),
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
                    SizedBox(
                      width: context.responsiveT<double>(
                          params: ResponsiveTParams(
                              small: AppSpacing.xSmall8.value,
                              medium: AppSpacing.medium16.value)),
                    ),
                    dateAndTodayRow,
                    Spacer(),
                    DropdownMenu<int>(
                      width: context.responsiveT<double>(params: ResponsiveTParams(small: 90,medium: 140)),
                      initialSelection: currentConfiguration,
                      textStyle: AppTextStyle.getTextStyle(AppTextStyleParams(
                          appFontSize: AppFontSize.paragraphXSmall,
                          color: AppColors.text(context.isDarkMode),
                          appFontWeight: AppFontWeight.regular)),
                      dropdownMenuEntries: [
                        for (var i = 0; i < viewConfigurations.length; i++)
                          DropdownMenuEntry<int>(
                              value: i,
                              label: viewConfigurations[i].name,
                              labelWidget: Text(
                                viewConfigurations[i].name,
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
                    Expanded(child: dateAndTodayRow),
                    viewSelector,
                  ],
                ),
        );
      },
    );
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
