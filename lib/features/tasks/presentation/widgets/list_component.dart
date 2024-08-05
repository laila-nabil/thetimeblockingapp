import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/common/entities/tasks_list.dart';

import '../../../../common/widgets/custom_pop_up_menu.dart';
import '../../../../core/resources/text_styles.dart';

class ListComponent extends StatefulWidget {
  const ListComponent(
      {super.key, required this.list, this.onTap, this.actions});

  final TasksList list;
  final void Function()? onTap;
  final List<CustomPopupItem>? actions;

  @override
  State<ListComponent> createState() => _ListComponentState();
}

class _ListComponentState extends State<ListComponent> {
  bool onHover = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHover: (hover){
        if (hover!=onHover) {
          setState(() {
            onHover = hover;
          });
        }
      },
      child: Container(
        padding: EdgeInsets.all(AppSpacing.xSmall8.value),
        decoration: BoxDecoration(
            color: onHover
                ? AppColors.primary(context.isDarkMode).shade50.withOpacity(0.5)
                : AppColors.background(context.isDarkMode)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.list.name ?? "",
              style: AppTextStyle.getTextStyle(AppTextStyleParams(
                  appFontSize: AppFontSize.paragraphSmall,
                  color: AppColors.grey(context.isDarkMode).shade900,
                  appFontWeight: AppFontWeight.semiBold)),
            ),
            if (widget.actions?.isNotEmpty == true)
              CustomPopupMenu(
                  items: widget.actions ?? [],
                  )
          ],
        ),
      ),
    );
  }
}
