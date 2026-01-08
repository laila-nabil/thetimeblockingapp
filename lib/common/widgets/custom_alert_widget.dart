import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:thetimeblockingapp/common/widgets/custom_button.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/core/resources/app_icons.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';

enum CustomAlertType { base, information, success, error, warning }

enum CustomAlertThemeType { filled, accent, outlined }

class CustomAlertWidget extends StatelessWidget {
  const CustomAlertWidget({
    super.key,
    required this.customAlertType,
    required this.customAlertThemeType,
    required this.title,
    this.details,
    this.primaryCta,
    this.primaryCtaOnPressed,
    this.secondaryCta,
    this.secondaryCtaOnPressed,
    this.onClose,
  });

  final CustomAlertType customAlertType;
  final CustomAlertThemeType customAlertThemeType;
  final String title;
  final String? details;
  final String? primaryCta;
  final void Function()? primaryCtaOnPressed;
  final String? secondaryCta;
  final void Function()? secondaryCtaOnPressed;
  final void Function()? onClose;

  @override
  Widget build(BuildContext context) {
    final bool smallVersion = context.showSmallDesign;
    return Stack(
      children: [
        if (onClose == null)
          Positioned.directional(
              textDirection: Directionality.of(context),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 8, 0),
                child: IconButton(
                    onPressed: onClose,
                    icon: const Icon(
                      Icons.close,
                      size: 24,
                    )),
              )),
        Container(
          decoration: BoxDecoration(
            color: _backgroundColor(
                customAlertType: customAlertType,
                customAlertThemeType: customAlertThemeType,
                isDarkMode: context.isDarkMode),
            border: Border.all(
                color: _borderColor(
                    customAlertType: customAlertType,
                    customAlertThemeType: customAlertThemeType,
                    isDarkMode: context.isDarkMode)),
            borderRadius: BorderRadius.circular(AppBorderRadius.xLarge.value),
          ),
          padding: smallVersion
              ? EdgeInsetsDirectional.fromSTEB(
                  AppSpacing.small12.value,
                  AppSpacing.small12.value,
                  AppSpacing.small12.value,
                  AppSpacing.small12.value)
              : EdgeInsetsDirectional.fromSTEB(AppSpacing.big20.value,
                  AppSpacing.big20.value, 60, AppSpacing.big20.value),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _icon(
                  customAlertType: customAlertType,
                  customAlertThemeType: customAlertThemeType,
                  isDarkMode: context.isDarkMode),
              SizedBox(
                width: AppSpacing.medium16.value,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: _titleTextStyle(smallVersion, context,
                          customAlertType: customAlertType,
                          customAlertThemeType: customAlertThemeType),
                    ),
                    if (details?.isNotEmpty == true)
                      Padding(
                        padding:
                            EdgeInsets.only(top: AppSpacing.x2Small4.value),
                        child: Text(details ?? "",
                            style: _detailsTextStyle(smallVersion, context,
                                customAlertThemeType: customAlertThemeType,
                                customAlertType: customAlertType)),
                      ),
                    SizedBox(
                      height: AppSpacing.medium16.value,
                    ),
                    Row(
                      children: [
                        if (secondaryCtaOnPressed != null &&
                            secondaryCta?.isNotEmpty == true)
                          CustomButton.noIcon(
                              label: secondaryCta ?? "",
                              onPressed: secondaryCtaOnPressed,
                              type: CustomButtonType.greyTextLabel),
                        if (primaryCtaOnPressed != null &&
                            primaryCta?.isNotEmpty == true)
                          smallVersion
                              ? CustomButton.noIcon(
                                  label: primaryCta ?? "",
                                  onPressed: primaryCtaOnPressed,
                                  size: CustomButtonSize.xSmall,
                                  type: CustomButtonType.greyTextLabel)
                              : CustomButton.noIcon(
                                  label: primaryCta ?? "",
                                  onPressed: primaryCtaOnPressed,
                                  type: CustomButtonType.greyFilledLabel),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _icon(
    {required CustomAlertType customAlertType,
    required CustomAlertThemeType customAlertThemeType,
    required bool isDarkMode}) {
  const containerSize = 32.0;
  const iconSize = 16.0;
  final borderRadius = BorderRadius.circular(AppBorderRadius.xSmall.value);
  switch (customAlertType) {
    case CustomAlertType.base:
      if (customAlertThemeType == CustomAlertThemeType.filled) {
        return Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: AppColors.white,
              border: Border.all(color: AppColors.grey(200))),
          child: Icon(
            AppIcons.infocircle,
            size: iconSize,
            color: isDarkMode ? AppColors.grey(50) : AppColors.grey(900),
          ),
        );
      }
      if (customAlertThemeType == CustomAlertThemeType.accent) {
        return Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: AppColors.white,
              border: Border.all(color: AppColors.grey(200))),
          child: Icon(AppIcons.infocircle,
              size: iconSize, color: AppColors.grey(500)),
        );
      }
      return Container(
        width: containerSize,
        height: containerSize,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: AppColors.grey(50),
        ),
        child: Icon(AppIcons.infocircle,
            size: iconSize, color: AppColors.grey(500)),
      );
    case CustomAlertType.information:
      if (customAlertThemeType == CustomAlertThemeType.filled) {
        return Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: AppColors.primary(isDarkMode, 50),
              border: Border.all(color: AppColors.primary(isDarkMode, 100))),
          child: Icon(AppIcons.infocircle,
              size: iconSize, color: AppColors.primary(isDarkMode, 500)),
        );
      }
      if (customAlertThemeType == CustomAlertThemeType.accent) {
        return Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: AppColors.white,
              border: Border.all(color: AppColors.primary(isDarkMode, 100))),
          child: Icon(
            AppIcons.infocircle,
            size: iconSize,
            color: AppColors.primary(isDarkMode, 600),
          ),
        );
      }
      return Container(
        width: containerSize,
        height: containerSize,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: AppColors.primary(isDarkMode, 50),
        ),
        child: Icon(
          AppIcons.infocircle,
          size: iconSize,
          color: AppColors.primary(isDarkMode, 600),
        ),
      );
    case CustomAlertType.success:
      if (customAlertThemeType == CustomAlertThemeType.filled) {
        return Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: AppColors.white,
              border: Border.all(color: AppColors.success(isDarkMode, 100))),
          child: Icon(
            AppIcons.checkcircle,
            size: iconSize,
            color: AppColors.success(isDarkMode, 600),
          ),
        );
      }
      if (customAlertThemeType == CustomAlertThemeType.accent) {
        return Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: AppColors.white,
              border: Border.all(color: AppColors.success(isDarkMode, 100))),
          child: Icon(
            AppIcons.checkcircle,
            size: iconSize,
            color: AppColors.success(isDarkMode, 600),
          ),
        );
      }
      return Container(
        width: containerSize,
        height: containerSize,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: AppColors.success(isDarkMode, 50),
        ),
        child: Icon(
          AppIcons.checkcircle,
          size: iconSize,
          color: AppColors.success(isDarkMode, 600),
        ),
      );
    case CustomAlertType.warning:
      if (customAlertThemeType == CustomAlertThemeType.filled) {
        return Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: AppColors.white,
              border: Border.all(color: AppColors.warning(isDarkMode, 100))),
          child: Icon(
            AppIcons.infotriangle,
            size: iconSize,
            color: AppColors.warning(isDarkMode, 600),
          ),
        );
      }
      if (customAlertThemeType == CustomAlertThemeType.accent) {
        return Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: AppColors.white,
              border: Border.all(color: AppColors.warning(isDarkMode, 100))),
          child: Icon(
            AppIcons.infotriangle,
            size: iconSize,
            color: AppColors.warning(isDarkMode, 600),
          ),
        );
      }
      return Container(
        width: containerSize,
        height: containerSize,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: AppColors.warning(isDarkMode, 50),
        ),
        child: Icon(
          AppIcons.infotriangle,
          size: iconSize,
          color: AppColors.warning(isDarkMode, 600),
        ),
      );
    case CustomAlertType.error:
      if (customAlertThemeType == CustomAlertThemeType.filled) {
        return Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: AppColors.error(50),
              border: Border.all(color: AppColors.error(100))),
          child: Icon(AppIcons.infocircle,
              size: iconSize, color: AppColors.error(500)),
        );
      }
      if (customAlertThemeType == CustomAlertThemeType.accent) {
        return Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: AppColors.white,
              border: Border.all(color: AppColors.error(100))),
          child: Icon(AppIcons.infocircle,
              size: iconSize, color: AppColors.error(500)),
        );
      }
      return Container(
        width: containerSize,
        height: containerSize,
        decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: AppColors.error(50),
            border: Border.all(color: AppColors.error(100))),
        child: Icon(AppIcons.infocircle,
            size: iconSize, color: AppColors.error(500)),
      );
  }
}

Color _backgroundColor(
    {required CustomAlertType customAlertType,
    required CustomAlertThemeType customAlertThemeType,
    required bool isDarkMode}) {
  switch (customAlertType) {
    case CustomAlertType.base:
      if (customAlertThemeType == CustomAlertThemeType.filled) {
        return AppColors.grey(700);
      }
      if (customAlertThemeType == CustomAlertThemeType.accent) {
        return AppColors.grey(50);
      }
      return AppColors.white;
    case CustomAlertType.information:
      if (customAlertThemeType == CustomAlertThemeType.filled) {
        return AppColors.primary(isDarkMode, 500);
      }
      if (customAlertThemeType == CustomAlertThemeType.accent) {
        return AppColors.primary(isDarkMode, 100);
      }
      return AppColors.white;
    case CustomAlertType.success:
      if (customAlertThemeType == CustomAlertThemeType.filled) {
        return AppColors.success(isDarkMode, 600);
      }
      if (customAlertThemeType == CustomAlertThemeType.accent) {
        return AppColors.success(isDarkMode, 50);
      }
      return AppColors.white;
    case CustomAlertType.warning:
      if (customAlertThemeType == CustomAlertThemeType.filled) {
        return AppColors.warning(isDarkMode, 400);
      }
      if (customAlertThemeType == CustomAlertThemeType.accent) {
        return AppColors.warning(isDarkMode, 50);
      }
      return AppColors.white;
    case CustomAlertType.error:
      if (customAlertThemeType == CustomAlertThemeType.filled) {
        return AppColors.error(400);
      }
      if (customAlertThemeType == CustomAlertThemeType.accent) {
        return AppColors.error(50);
      }
      return AppColors.white;
  }
}

Color _borderColor(
    {required CustomAlertType customAlertType,
    required CustomAlertThemeType customAlertThemeType,
    required bool isDarkMode}) {
  switch (customAlertType) {
    case CustomAlertType.base:
      if (customAlertThemeType == CustomAlertThemeType.filled) {
        return AppColors.grey(700);
      }
      if (customAlertThemeType == CustomAlertThemeType.accent) {
        return AppColors.grey(50);
      }
      return AppColors.white;
    case CustomAlertType.information:
      if (customAlertThemeType == CustomAlertThemeType.filled) {
        return AppColors.primary(isDarkMode, 500);
      }
      if (customAlertThemeType == CustomAlertThemeType.accent) {
        return AppColors.primary(isDarkMode, 100);
      }
      return AppColors.white;
    case CustomAlertType.success:
      if (customAlertThemeType == CustomAlertThemeType.filled) {
        return AppColors.success(isDarkMode, 600);
      }
      if (customAlertThemeType == CustomAlertThemeType.accent) {
        return AppColors.success(isDarkMode, 50);
      }
      return AppColors.white;
    case CustomAlertType.warning:
      if (customAlertThemeType == CustomAlertThemeType.filled) {
        return AppColors.warning(isDarkMode, 400);
      }
      if (customAlertThemeType == CustomAlertThemeType.accent) {
        return AppColors.warning(isDarkMode, 50);
      }
      return AppColors.white;
    case CustomAlertType.error:
      if (customAlertThemeType == CustomAlertThemeType.filled) {
        return AppColors.error(400);
      }
      if (customAlertThemeType == CustomAlertThemeType.accent) {
        return AppColors.error(50);
      }
      return AppColors.white;
  }
}

Color _titleTextColor(
    {required CustomAlertType customAlertType,
    required CustomAlertThemeType customAlertThemeType,
    required bool isDarkMode}) {
  if (customAlertType == CustomAlertType.warning) {
    return AppColors.grey(900);
  }
  if (customAlertThemeType == CustomAlertThemeType.filled) {
    return AppColors.white;
  }
  return AppColors.grey(900);
}

TextStyle _titleTextStyle(
  bool smallVersion,
  BuildContext context, {
  required CustomAlertType customAlertType,
  required CustomAlertThemeType customAlertThemeType,
}) {
  return AppTextStyle.getTextStyle(AppTextStyleParams(
      appFontSize: smallVersion
          ? AppFontSize.paragraphSmall
          : AppFontSize.paragraphMedium,
      color: _titleTextColor(
          customAlertType: customAlertType,
          customAlertThemeType: customAlertThemeType,
          isDarkMode: context.isDarkMode),
      appFontWeight: AppFontWeight.semiBold));
}

Color _detailsTextColor(
    {required CustomAlertType customAlertType,
    required CustomAlertThemeType customAlertThemeType,
    required bool isDarkMode}) {
  if (customAlertThemeType == CustomAlertThemeType.filled) {
    if (customAlertType == CustomAlertType.warning) {
      return AppColors.grey(900);
    }
    return AppColors.grey(50);
  }

  return AppColors.grey(600);
}

TextStyle _detailsTextStyle(
  bool smallVersion,
  BuildContext context, {
  required CustomAlertType customAlertType,
  required CustomAlertThemeType customAlertThemeType,
}) {
  return AppTextStyle.getTextStyle(AppTextStyleParams(
      appFontSize: smallVersion
          ? AppFontSize.paragraphXSmall
          : AppFontSize.paragraphSmall,
      color: _detailsTextColor(
          customAlertType: customAlertType,
          customAlertThemeType: customAlertThemeType,
          isDarkMode: context.isDarkMode),
      appFontWeight: AppFontWeight.regular));
}

void showCustomAlert({
  required BuildContext context,
  required CustomAlertType customAlertType,
  required CustomAlertThemeType customAlertThemeType,
  required String title,
  String? primaryCta,
  void Function()? primaryCtaOnPressed,
  String? secondaryCta,
  void Function()? secondaryCtaOnPressed,
  void Function()? onClose,
}) {
  final isDarkMode = context.isDarkMode;
  final smallVersion = context.showSmallDesign;
  return ShadToaster.of(context).show(
    ShadToast(
      border: ShadBorder.all(
          color: _borderColor(
              customAlertType: customAlertType,
              customAlertThemeType: customAlertThemeType,
              isDarkMode: context.isDarkMode)),
      radius: BorderRadius.circular(AppBorderRadius.xLarge.value),
      backgroundColor: _backgroundColor(
          customAlertType: customAlertType,
          customAlertThemeType: customAlertThemeType,
          isDarkMode: isDarkMode),
      title: Row(
        children: [
          _icon(
              customAlertType: customAlertType,
              customAlertThemeType: customAlertThemeType,
              isDarkMode: isDarkMode),
          SizedBox(
            width: AppSpacing.medium16.value,
          ),
          Text(
            title,
            style: _titleTextStyle(smallVersion, context,
                customAlertType: customAlertType,
                customAlertThemeType: customAlertThemeType),
          ),
        ],
      ),
      titleStyle: _titleTextStyle(smallVersion, context,
          customAlertType: customAlertType,
          customAlertThemeType: customAlertThemeType),
      action: Row(
        children: [
          if (secondaryCtaOnPressed != null && secondaryCta?.isNotEmpty == true)
            CustomButton.noIcon(
                label: secondaryCta ?? "", onPressed: secondaryCtaOnPressed),
          if (primaryCtaOnPressed != null && primaryCta?.isNotEmpty == true)
            CustomButton.noIcon(
                label: primaryCta ?? "", onPressed: primaryCtaOnPressed),
        ],
      ),
    ),
  );
  // return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     backgroundColor: Colors.transparent,
  //     elevation: 0,
  //     content: CustomAlertWidget(
  //       customAlertType: customAlertType,
  //       customAlertThemeType: customAlertThemeType,
  //       title: title,
  //       details: details,
  //       onClose: onClose,
  //       primaryCta: primaryCta,
  //       primaryCtaOnPressed: primaryCtaOnPressed,
  //       secondaryCta: secondaryCta,
  //       secondaryCtaOnPressed: secondaryCtaOnPressed,
  //     )));
}
