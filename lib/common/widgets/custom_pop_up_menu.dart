import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';

import '../../core/resources/app_colors.dart';
import '../../core/resources/app_icons.dart';
import '../../core/resources/assets_paths.dart';

class CustomPopupItem {
  final String? title;
  final Widget? titleWidget;
  final void Function() onTap;

  CustomPopupItem._({this.title, this.titleWidget, required this.onTap});

  CustomPopupItem.text(
      {required String title, required void Function() onTap})
      : this._(onTap: onTap, title: title, titleWidget: null);

  CustomPopupItem.widget(
      {required Widget titleWidget, required void Function() onTap})
      : this._(onTap: onTap, title: null, titleWidget: titleWidget);
}

class CustomPopupMenu extends StatefulWidget {
  const CustomPopupMenu(
      {super.key,
      required this.items,
      this.backgroundColor = AppColors.white, this.tooltip});

  final List<CustomPopupItem> items;
  final Color backgroundColor;
  final String? tooltip;
  static TextStyle textStyle = AppTextStyle.getTextStyle(AppTextStyleParams(
      appFontSize: AppFontSize.paragraphSmall,
      color: AppColors.grey.shade900,
      appFontWeight: AppFontWeight.regular));

  @override
  State<CustomPopupMenu> createState() => _CustomPopupMenuState();
}

class _CustomPopupMenuState extends State<CustomPopupMenu> {
  bool isOpened = false;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        tooltip: widget.tooltip,
        color: AppColors.white,
        surfaceTintColor: AppColors.white,
        shadowColor: AppColors.secondary.shade100,
        icon: Container(
            padding: const EdgeInsets.all(4.0),
            decoration: ShapeDecoration(
                color: widget.backgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0)),
                shadows: [
                  if(isOpened)BoxShadow(
                    color: AppColors.secondary.shade50,
                    blurRadius: 0,
                    offset: const Offset(0, 0),
                    spreadRadius: 4,
                  ),
                ]),
            child: Icon(
              AppIcons.dotsv,
              size: 16,
              color: AppColors.grey.shade500,
            )),
        onOpened: (){
          setState(() {
            isOpened = true;
          });
        },
        onCanceled: (){
          setState(() {
            isOpened = false;
          });
        },
        onSelected: (_){
          setState(() {
            isOpened = false;
          });
        },
        itemBuilder: (context) {
          return widget.items
              .map((e) => PopupMenuItem(
                    onTap: e.onTap,
                    child: e.title?.isNotEmpty == true
                        ? Text(
                            e.title ?? "",
                            style: CustomPopupMenu.textStyle,
                          )
                        : e.titleWidget,
                  ))
              .toList();
        });
  }
}
