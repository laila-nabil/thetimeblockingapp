import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/resources/assets_paths.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/text_styles.dart';

class TagChip extends StatelessWidget {
  const TagChip({super.key, required this.tagName, this.color});

  final String tagName;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.grey.shade600;
    return Chip(
        backgroundColor: AppColors.background,
        elevation: 0.5,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child: Image.asset(
                AppAssets.hashtag,
                color: color ?? color,
                width: 12,
                height: 12,
              ),
            ),
            const SizedBox(
              width: 2.5,
            ),
            Text(
              tagName,
              style: AppTextStyle.getTextStyle(AppTextStyleParams(
                  appFontSize: AppFontSize.paragraphXSmall,
                  color: color,
                  appFontWeight: AppFontWeight.medium)),
            ),
          ],
        ));
  }
}
