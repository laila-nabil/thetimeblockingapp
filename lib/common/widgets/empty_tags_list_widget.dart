import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';

import '../../core/localization/localization.dart';
import '../../core/resources/app_colors.dart';

class EmptyTagsListWidget extends StatelessWidget {
  const EmptyTagsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
        appLocalization.translate("noTagsMessage"),
        style: AppTextStyle.getTextStyle(AppTextStyleParams(
            appFontSize: AppFontSize.paragraphXSmall,
            color: context.isDarkMode ? AppColors.white : AppColors.black.withOpacity(0.8),
            appFontWeight: AppFontWeight.thin)),
    );
  }
}
