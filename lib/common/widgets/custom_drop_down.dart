import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';

import '../../core/resources/app_colors.dart';
import '../../core/resources/assets_paths.dart';

class CustomDropDownItem {
  final String? title;
  final Widget? titleWidget;
  final void Function() onTap;

  CustomDropDownItem._({this.title, this.titleWidget, required this.onTap});

  CustomDropDownItem.text(
      {required String title, required void Function() onTap})
      : this._(onTap: onTap, title: title, titleWidget: null);

  CustomDropDownItem.widget(
      {required Widget titleWidget, required void Function() onTap})
      : this._(onTap: onTap, title: null, titleWidget: titleWidget);
}

class CustomDropDownMenu extends StatelessWidget {
  const CustomDropDownMenu(
      {super.key, required this.items, required this.listButton});

  final List<CustomDropDownItem> items;
  final Widget listButton;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        color: AppColors.white,
        surfaceTintColor: AppColors.white,
        icon: Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: AppColors.white),
            child: listButton),
        itemBuilder: (context) {
          return items
              .map((e) => PopupMenuItem(
                    onTap: e.onTap,
                    child: e.title?.isNotEmpty == true
                        ? Text(
                            e.title ?? "",
                            style: AppTextStyle.getTextStyle(AppTextStyleParams(
                                appFontSize: AppFontSize.paragraphSmall,
                                color: AppColors.grey.shade900,
                                appFontWeight: AppFontWeight.regular)),
                          )
                        : e.titleWidget,
                  ))
              .toList();
        });
  }
}
