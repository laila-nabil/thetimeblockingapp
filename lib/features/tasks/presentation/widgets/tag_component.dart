import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_list.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';

import '../../../../core/resources/text_styles.dart';

class TagComponent extends StatelessWidget {
  const TagComponent({super.key, required this.tag, this.onTap});

  final ClickupTag tag;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xSmall.value),
        decoration: BoxDecoration(color: AppColors.background),
        child: Text(
          tag.name ?? "",
          style: AppTextStyle.getTextStyle(AppTextStyleParams(
              appFontSize: AppFontSize.paragraphSmall,
              color: AppColors.grey.shade900,
              appFontWeight: AppFontWeight.semiBold)),
        ),
      ),
    );
  }
}
