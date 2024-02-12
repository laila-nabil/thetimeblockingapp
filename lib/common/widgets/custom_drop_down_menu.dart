import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';

import '../../core/resources/app_colors.dart';
import '../../core/resources/app_design.dart';
import '../../core/resources/app_icons.dart';
import '../../core/resources/assets_paths.dart';

class CustomDropDownMenu extends DropdownButton {
  static TextStyle textStyle = AppTextStyle.getTextStyle(AppTextStyleParams(
      appFontSize: AppFontSize.paragraphSmall,
      color: AppColors.grey.shade900,
      appFontWeight: AppFontWeight.regular));

  CustomDropDownMenu({
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
  });

  @override
  Color? get dropdownColor => AppColors.background;

  @override
  Color? get focusColor => AppColors.grey.shade50;

  @override
  Widget? get icon => const Padding(
        padding: EdgeInsets.all(4.0),
        child: Icon(AppIcons.chevrondown, size: 14),
      );

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
