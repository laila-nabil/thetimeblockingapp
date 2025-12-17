import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';

import '../../core/resources/app_colors.dart';
import '../../core/resources/app_design.dart';
import '../../core/resources/app_icons.dart';

class CustomDropDown<T> extends StatelessWidget {
  const CustomDropDown(
      {super.key,
      this.isDense,
      this.isDarkMode,
      this.style,
      this.hint,
      this.icon,
      this.value,
      this.onChanged,
      required this.showBorder,
      this.items = const []});

  final bool? isDense;
  final bool? isDarkMode;
  final TextStyle? style;
  final Widget? hint;
  final Widget? icon;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final List<ShadOption<T>> items;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    return ShadSelect(
      onChanged: onChanged,
      placeholder: hint,
      initialValue: value,
      options: items,
      allowDeselection: true,
      shrinkWrap: true,
      decoration: showBorder
          ? ShadDecoration(disableSecondaryBorder: true)
          : ShadDecoration(
              border: ShadBorder.none, disableSecondaryBorder: true),
      selectedOptionBuilder: (context, value) =>
          items.where((i) => i.value == value).firstOrNull?.child ??
          Container(),
    );
  }
}
