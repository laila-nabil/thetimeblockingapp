import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/resources/app_icons.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/text_styles.dart';

class TagChip extends StatelessWidget {
  const TagChip({super.key, required this.tagName, this.color, this.onDelete});

  final String tagName;
  final Color? color;
  final void Function()? onDelete;

  static TextStyle textStyle(Color color) => AppTextStyle.getTextStyle(AppTextStyleParams(
  appFontSize: AppFontSize.paragraphXSmall,
  color: color,
  appFontWeight: AppFontWeight.medium));
  @override
  Widget build(BuildContext context) {
    final color = AppColors.grey(context.isDarkMode).shade600;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 100),
      child: Chip(
          onDeleted: onDelete,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Icon(
                  AppIcons.hashtag,
                  color: color ?? color,
                  size: 12,
                ),
              ),
              const SizedBox(
                width: 2.5,
              ),
              Expanded(
                child: Text(
                  tagName,
                  style: textStyle(color),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )),
    );
  }
}
