import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
import 'package:thetimeblockingapp/core/resources/app_icons.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';


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
    final colors = AppColors.grey(context.isDarkMode).shade600;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 110),
      child: Chip(
          label: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isListInsideFolder)
                Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Icon(
                    AppIcons.folder,
                    color: colors,
                    size: iconSize,
                  ),
                ),
              if (isListInsideFolder)
                const SizedBox(
                  width: 2.5,
                ),
              if (isListInsideFolder)
                Expanded(
                  child: Text(
                    folderName??"",
                    style: AppTextStyle.getTextStyle(AppTextStyleParams(
                        appFontSize: AppFontSize.paragraphXSmall,
                        color: colors,
                        appFontWeight: AppFontWeight.medium)),
                    overflow: TextOverflow.ellipsis,
                  ),
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
                child: Icon(
                  AppIcons.list,
                  color: colors,
                  size: iconSize,
                ),
              ),
              const SizedBox(
                width: 2.5,
              ),
              Expanded(
                child: Text(
                  listName,
                  style: AppTextStyle.getTextStyle(AppTextStyleParams(
                      appFontSize: AppFontSize.paragraphXSmall,
                      color: colors,
                      appFontWeight: AppFontWeight.medium)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )),
    );
  }
}
