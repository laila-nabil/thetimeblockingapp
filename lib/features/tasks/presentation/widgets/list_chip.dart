import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';

import '../../../../core/resources/assets_paths.dart';

class ListChip extends StatelessWidget {
  const ListChip({
    super.key,
    required this.listName,
    required this.folderName,
  });

  final String listName;
  final String? folderName;

  @override
  Widget build(BuildContext context) {
    final isListInsideFolder = folderName?.isNotEmpty == true;
    const iconSize = 12.0;
    final colors = AppColors.grey.shade600;
    return Chip(
        backgroundColor: AppColors.background,
        elevation:  0.5,
        label: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (isListInsideFolder)
              Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Image.asset(
                  AppAssets.folder,
                  color: colors,
                  width: iconSize,
                  height: iconSize,
                ),
              ),
            if (isListInsideFolder)
              const SizedBox(
                width: 2.5,
              ),
            if (isListInsideFolder)
              Text(
                listName,
                style: AppTextStyle.getTextStyle(AppTextStyleParams(
                    appFontSize: AppFontSize.paragraphXSmall,
                    color: colors,
                    appFontWeight: AppFontWeight.medium)),
              ),
            if (isListInsideFolder)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                child: Text(
                  "/",
                  style: AppTextStyle.getTextStyle(AppTextStyleParams(
                      appFontSize: AppFontSize.paragraphXSmall,
                      color: colors,
                      appFontWeight: AppFontWeight.medium)),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child: Image.asset(
                AppAssets.list,
                color: colors,
                width: iconSize,
                height: iconSize,
              ),
            ),
            const SizedBox(
              width: 2.5,
            ),
            Text(
              listName,
              style: AppTextStyle.getTextStyle(AppTextStyleParams(
                  appFontSize: AppFontSize.paragraphXSmall,
                  color: colors,
                  appFontWeight: AppFontWeight.medium)),
            ),
          ],
        ));
  }
}
