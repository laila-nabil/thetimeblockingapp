import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';

import '../../core/resources/app_colors.dart';
import '../../core/resources/app_design.dart';
import '../../core/resources/app_icons.dart';

///TODO update UI to match Figma design

class CustomDropDown extends DropdownButton {
  static TextStyle textStyle(bool isDarkMode) => AppTextStyle.getTextStyle(AppTextStyleParams(
      appFontSize: AppFontSize.paragraphSmall,
      color: AppColors.grey(isDarkMode).shade900,
      appFontWeight: AppFontWeight.regular));

  final bool isDarkMode;
  CustomDropDown({
    super.key,
    required super.items,
    super.selectedItemBuilder,
    super.value,
    super.hint,
    super.disabledHint,
    required super.onChanged,
    super.onTap,
    super.style,
    super.icon,
    super.iconDisabledColor,
    super.iconEnabledColor,
    super.iconSize = 24.0,
    super.isDense = false,
    super.itemHeight = kMinInteractiveDimension,
    super.focusNode,
    super.autofocus = false,
    super.menuMaxHeight,
    super.enableFeedback,
    super.alignment = AlignmentDirectional.centerStart,
    required this.isDarkMode
  });

  @override
  Color? get dropdownColor => AppColors.background(isDarkMode);

  @override
  Color? get focusColor => AppColors.grey(isDarkMode).shade50;

  @override
  Widget? get icon => const Icon(AppIcons.chevrondown, size: 0);

  @override
  EdgeInsetsGeometry? get padding => EdgeInsets.zero;

  @override
  BorderRadius? get borderRadius =>
      BorderRadius.circular(AppBorderRadius.xSmall.value);

  @override
  Widget? get underline => Container();

  @override
  int get elevation => 0;
}

class CustomDropDownMenu extends DropdownMenu {
  final bool isDarkMode;
  const CustomDropDownMenu({
    super.key,
    super.enabled = true,
    super.width,
    super.menuHeight,
    super.leadingIcon,
    super.trailingIcon,
    super.label,
    super.hintText,
    super.helperText,
    super.errorText,
    super.selectedTrailingIcon,
    super.enableFilter = false,
    super.enableSearch = true,
    super.textStyle,
    super.inputDecorationTheme,
    super.controller,
    required super.initialSelection,
    required super.onSelected,
    super.requestFocusOnTap,
    required super.dropdownMenuEntries,
    required this.isDarkMode
  });


  @override
  MenuStyle? get menuStyle => MenuStyle(
      surfaceTintColor:
          WidgetStateColor.resolveWith((states) => AppColors.background(isDarkMode)));
}
