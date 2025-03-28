import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';

import '../../core/localization/localization.dart';
import '../../core/resources/app_colors.dart';

class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
        appLocalization.translate("noTasksMessage"),
        style: AppTextStyle.getTextStyle(AppTextStyleParams(
            appFontSize: AppFontSize.paragraphXSmall,
            color: AppColors.black(context.isDarkMode).withOpacity(0.8),
            appFontWeight: AppFontWeight.thin)),
    );
  }
}
