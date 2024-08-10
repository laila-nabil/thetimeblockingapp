import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';

import '../../../../common/entities/tag.dart';
import '../../../../common/widgets/custom_pop_up_menu.dart';
import '../../../../core/resources/text_styles.dart';

class TagComponent extends StatefulWidget {
  const TagComponent(
      {super.key,
      required this.tag,
      this.onTap,
      this.actions,
      this.updateTagInline});

  final Tag tag;
  final void Function()? onTap;
  final List<CustomPopupItem>? actions;
  final Widget? updateTagInline;

  @override
  State<TagComponent> createState() => _TagComponentState();
}

class _TagComponentState extends State<TagComponent> {
  bool onHover = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(AppBorderRadius.large.value),
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
            borderRadius: BorderRadius.circular(AppBorderRadius.large.value),
            color: onHover
            ? AppColors.primary(context.isDarkMode).shade50.withOpacity(0.5)
            :  AppColors.background(context.isDarkMode)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.tag,
                  color: widget.tag.getColor,
                  size: 16,
                ),
                const SizedBox(width: 2.5,),
                if (widget.updateTagInline == null)
                  Text(
                    widget.tag.name ?? "",
                    style: AppTextStyle.getTextStyle(AppTextStyleParams(
                        appFontSize: AppFontSize.paragraphSmall,
                        color: AppColors.grey(context.isDarkMode).shade900,
                        appFontWeight: AppFontWeight.semiBold)),
                  )
                else
                  widget.updateTagInline!,
              ],
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
