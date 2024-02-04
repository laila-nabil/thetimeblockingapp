import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_list.dart';

import '../../../../core/resources/text_styles.dart';

class ListComponent extends StatelessWidget {
  const ListComponent({super.key, required this.list, this.onTap});

  final ClickupList list;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xSmall.value),
        decoration: BoxDecoration(color: AppColors.background),
        child: Text(
          list.name ?? "",
          style: AppTextStyle.getTextStyle(AppTextStyleParams(
              appFontSize: AppFontSize.paragraphSmall,
              color: AppColors.grey.shade900,
              appFontWeight: AppFontWeight.semiBold)),
        ),
      ),
    );
  }
}
