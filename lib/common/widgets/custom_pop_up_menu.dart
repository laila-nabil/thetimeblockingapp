import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';

import '../../core/resources/app_colors.dart';
import '../../core/resources/app_icons.dart';

class CustomPopupItem {
  final String? title;
  final IconData? icon;
  final Widget? titleWidget;
  final void Function()? onTap;
  final AlertDialog? alertDialog;

  CustomPopupItem._(
      {this.title, this.titleWidget, this.onTap, this.alertDialog, this.icon});

  CustomPopupItem(
      {required String title, void Function()? onTap, AlertDialog? alertDialog,IconData? icon})
      : this._(
            onTap: onTap,
            title: title,
            icon: icon,
            titleWidget: null,
            alertDialog: alertDialog);

  CustomPopupItem.custom(
      {required Widget titleWidget,
      void Function()? onTap,
      AlertDialog? alertDialog})
      : this._(
            onTap: onTap,
            title: null,
            titleWidget: titleWidget,alertDialog: alertDialog);
}

class CustomPopupMenu extends StatefulWidget {
  const CustomPopupMenu(
      {super.key,
      required this.items,
      this.backgroundColor, this.tooltip});

  final List<CustomPopupItem> items;
  final Color? backgroundColor;
  final String? tooltip;
  static TextStyle textStyle(bool isDarkMode) => AppTextStyle.getTextStyle(AppTextStyleParams(
      appFontSize: AppFontSize.paragraphSmall,
      color: AppColors.grey(isDarkMode).shade900,
      appFontWeight: AppFontWeight.regular));

  @override
  State<CustomPopupMenu> createState() => _CustomPopupMenuState();
}

class _CustomPopupMenuState extends State<CustomPopupMenu> {
  bool isOpened = false;
  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.backgroundColor ?? AppColors.white(context.isDarkMode);
    return PopupMenuButton(
        tooltip: widget.tooltip,
        color: AppColors.white(context.isDarkMode),
        surfaceTintColor: AppColors.white(context.isDarkMode),
        shadowColor: AppColors.secondary(context.isDarkMode).shade100,
        icon: Container(
            padding: const EdgeInsets.all(4.0),
            decoration: ShapeDecoration(
                color: backgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0)),
                shadows: [
                  if(isOpened)BoxShadow(
                    color: AppColors.secondary(context.isDarkMode).shade50,
                    blurRadius: 0,
                    offset: const Offset(0, 0),
                    spreadRadius: 4,
                  ),
                ]),
            child: Icon(
              AppIcons.dotsv,
              size: 16,
              color: AppColors.grey(context.isDarkMode).shade500,
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
                    onTap: e.alertDialog!=null ? (){
                      //showDialog is not shown on PopupMenuItem tap
                      //
                      // That's because onTap of popupMenuItem tries to use Navigator.pop
                      // to close the popup but at same time you are trying to show the dialog,
                      // So it closes the dialog and leaves the popup so, you can wait till
                      // the all the animations or ongoing things complete then show dialog

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              return e.alertDialog!;
                            });
                      });
                    }: e.onTap,
                    child: e.title?.isNotEmpty == true
                        ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if(e.icon!=null)Icon(e.icon,),
                            if(e.icon!=null)SizedBox(width: AppSpacing.xSmall8.value,),
                            Text(
                                e.title ?? "",
                                style: CustomPopupMenu.textStyle(context.isDarkMode),
                              ),
                          ],
                        )
                        : e.titleWidget,
                  ))
              .toList();
        });
  }
}
