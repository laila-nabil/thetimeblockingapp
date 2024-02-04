import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_list.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';

import '../../../../common/widgets/custom_drop_down.dart';
import '../../../../core/resources/assets_paths.dart';
import '../../../../core/resources/text_styles.dart';

class TagComponent extends StatelessWidget {
  const TagComponent({super.key, required this.tag, this.onTap, this.actions});

  final ClickupTag tag;
  final void Function()? onTap;
  final List<CustomDropDownItem>? actions;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xSmall8.value),
        decoration: BoxDecoration(color: AppColors.background),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tag.name ?? "",
              style: AppTextStyle.getTextStyle(AppTextStyleParams(
                  appFontSize: AppFontSize.paragraphSmall,
                  color: AppColors.grey.shade900,
                  appFontWeight: AppFontWeight.semiBold)),
            ),
            if (actions?.isNotEmpty == true)
              CustomDropDownMenu(
                  items: actions ?? [],
                  listButton: Image.asset(
                    AppAssets.dotsVPng,
                    height: 20,
                    fit: BoxFit.fitHeight,
                  ))
          ],
        ),
      ),
    );
  }
}
