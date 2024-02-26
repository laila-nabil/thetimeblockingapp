import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/common/widgets/custom_button.dart';
import 'package:thetimeblockingapp/core/globals.dart';
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
            color: backgroundColor(
                customAlertType: customAlertType,
                customAlertThemeType: customAlertThemeType,
                isDarkMode: context.isDarkMode),
            border: Border.all(
                color: borderColor(
                    customAlertType: customAlertType,
                    customAlertThemeType: customAlertThemeType,
                    isDarkMode: context.isDarkMode)),
            borderRadius: BorderRadius.circular(AppBorderRadius.xLarge.value),
          ),
          padding: EdgeInsetsDirectional.fromSTEB(AppSpacing.big20.value,
              AppSpacing.big20.value, 60, AppSpacing.big20.value),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              icon(
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
                      style: AppTextStyle.getTextStyle(AppTextStyleParams(
                          appFontSize: AppFontSize.paragraphMedium,
                          color: titleTextColor(
                              customAlertType: customAlertType,
                              customAlertThemeType: customAlertThemeType,
                              isDarkMode: context.isDarkMode),
                          appFontWeight: AppFontWeight.semiBold)),
                    ),
                    if (details?.isNotEmpty == true)
                      Padding(
                        padding: EdgeInsets.only(top: AppSpacing.x2Small4.value),
                        child: Text(details ?? "",
                            style: AppTextStyle.getTextStyle(AppTextStyleParams(
                                appFontSize: AppFontSize.paragraphSmall,
                                color: detailsTextColor(
                                    customAlertType: customAlertType,
                                    customAlertThemeType: customAlertThemeType,
                                    isDarkMode: context.isDarkMode),
                                appFontWeight: AppFontWeight.regular))),
                      ),
                    SizedBox(height: AppSpacing.medium16.value,),
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
                          CustomButton.noIcon(
                            label: primaryCta ?? "", onPressed: primaryCtaOnPressed,
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

  Widget icon(
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
                color: AppColors.white(isDarkMode),
                border: Border.all(color: AppColors.grey(isDarkMode).shade200)),
            child: Icon(
              AppIcons.infocircle,
              size: iconSize,
              color: AppColors.grey(isDarkMode).shade900,
            ),
          );
        }
        if (customAlertThemeType == CustomAlertThemeType.accent) {
          return Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: AppColors.white(isDarkMode),
                border: Border.all(color: AppColors.grey(isDarkMode).shade200)),
            child: Icon(
              AppIcons.infocircle,
              size: iconSize,
              color: AppColors.grey(isDarkMode).shade500,
            ),
          );
        }
        return Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: AppColors.grey(isDarkMode).shade50,
          ),
          child: Icon(
            AppIcons.infocircle,
            size: iconSize,
            color: AppColors.grey(isDarkMode).shade500,
          ),
        );
      case CustomAlertType.information:
        if (customAlertThemeType == CustomAlertThemeType.filled) {
          return Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: AppColors.secondary(isDarkMode).shade50,
                border: Border.all(
                    color: AppColors.secondary(isDarkMode).shade100)),
            child: Icon(
              AppIcons.infocircle,
              size: iconSize,
              color: AppColors.secondary(isDarkMode).shade500,
            ),
          );
        }
        if (customAlertThemeType == CustomAlertThemeType.accent) {
          return Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: AppColors.white(isDarkMode),
                border: Border.all(
                    color: AppColors.secondary(isDarkMode).shade100)),
            child: Icon(
              AppIcons.infocircle,
              size: iconSize,
              color: AppColors.secondary(isDarkMode).shade600,
            ),
          );
        }
        return Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: AppColors.secondary(isDarkMode).shade50,
          ),
          child: Icon(
            AppIcons.infocircle,
            size: iconSize,
            color: AppColors.secondary(isDarkMode).shade600,
          ),
        );
      case CustomAlertType.success:
        if (customAlertThemeType == CustomAlertThemeType.filled) {
          return Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: AppColors.white(isDarkMode),
                border:
                    Border.all(color: AppColors.success(isDarkMode).shade100)),
            child: Icon(
              AppIcons.checkcircle,
              size: iconSize,
              color: AppColors.success(isDarkMode).shade600,
            ),
          );
        }
        if (customAlertThemeType == CustomAlertThemeType.accent) {
          return Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: AppColors.white(isDarkMode),
                border:
                    Border.all(color: AppColors.success(isDarkMode).shade100)),
            child: Icon(
              AppIcons.checkcircle,
              size: iconSize,
              color: AppColors.success(isDarkMode).shade600,
            ),
          );
        }
        return Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: AppColors.success(isDarkMode).shade50,
          ),
          child: Icon(
            AppIcons.checkcircle,
            size: iconSize,
            color: AppColors.success(isDarkMode).shade600,
          ),
        );
      case CustomAlertType.warning:
        if (customAlertThemeType == CustomAlertThemeType.filled) {
          return Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: AppColors.white(isDarkMode),
                border:
                    Border.all(color: AppColors.warning(isDarkMode).shade100)),
            child: Icon(
              AppIcons.infotriangle,
              size: iconSize,
              color: AppColors.warning(isDarkMode).shade600,
            ),
          );
        }
        if (customAlertThemeType == CustomAlertThemeType.accent) {
          return Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: AppColors.white(isDarkMode),
                border:
                    Border.all(color: AppColors.warning(isDarkMode).shade100)),
            child: Icon(
              AppIcons.infotriangle,
              size: iconSize,
              color: AppColors.warning(isDarkMode).shade600,
            ),
          );
        }
        return Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: AppColors.warning(isDarkMode).shade50,
          ),
          child: Icon(
            AppIcons.infotriangle,
            size: iconSize,
            color: AppColors.warning(isDarkMode).shade600,
          ),
        );
      case CustomAlertType.error:
        if (customAlertThemeType == CustomAlertThemeType.filled) {
          return Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: AppColors.error(isDarkMode).shade50,
                border:
                    Border.all(color: AppColors.error(isDarkMode).shade100)),
            child: Icon(
              AppIcons.infocircle,
              size: iconSize,
              color: AppColors.error(isDarkMode).shade500,
            ),
          );
        }
        if (customAlertThemeType == CustomAlertThemeType.accent) {
          return Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: AppColors.white(isDarkMode),
                border:
                    Border.all(color: AppColors.error(isDarkMode).shade100)),
            child: Icon(
              AppIcons.infocircle,
              size: iconSize,
              color: AppColors.error(isDarkMode).shade500,
            ),
          );
        }
        return Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: AppColors.error(isDarkMode).shade50,
              border: Border.all(color: AppColors.error(isDarkMode).shade100)),
          child: Icon(
            AppIcons.infocircle,
            size: iconSize,
            color: AppColors.error(isDarkMode).shade500,
          ),
        );
    }
  }

  Color backgroundColor(
      {required CustomAlertType customAlertType,
      required CustomAlertThemeType customAlertThemeType,
      required bool isDarkMode}) {
    switch (customAlertType) {
      case CustomAlertType.base:
        if (customAlertThemeType == CustomAlertThemeType.filled) {
          return AppColors.grey(isDarkMode).shade700;
        }
        if (customAlertThemeType == CustomAlertThemeType.accent) {
          return AppColors.grey(isDarkMode).shade50;
        }
        return AppColors.white(isDarkMode);
      case CustomAlertType.information:
        if (customAlertThemeType == CustomAlertThemeType.filled) {
          return AppColors.secondary(isDarkMode).shade500;
        }
        if (customAlertThemeType == CustomAlertThemeType.accent) {
          return AppColors.secondary(isDarkMode).shade100;
        }
        return AppColors.white(isDarkMode);
      case CustomAlertType.success:
        if (customAlertThemeType == CustomAlertThemeType.filled) {
          return AppColors.success(isDarkMode).shade600;
        }
        if (customAlertThemeType == CustomAlertThemeType.accent) {
          return AppColors.success(isDarkMode).shade50;
        }
        return AppColors.white(isDarkMode);
      case CustomAlertType.warning:
        if (customAlertThemeType == CustomAlertThemeType.filled) {
          return AppColors.warning(isDarkMode).shade400;
        }
        if (customAlertThemeType == CustomAlertThemeType.accent) {
          return AppColors.warning(isDarkMode).shade50;
        }
        return AppColors.white(isDarkMode);
      case CustomAlertType.error:
        if (customAlertThemeType == CustomAlertThemeType.filled) {
          return AppColors.error(isDarkMode).shade400;
        }
        if (customAlertThemeType == CustomAlertThemeType.accent) {
          return AppColors.error(isDarkMode).shade50;
        }
        return AppColors.white(isDarkMode);
    }
  }

  Color borderColor(
      {required CustomAlertType customAlertType,
      required CustomAlertThemeType customAlertThemeType,
      required bool isDarkMode}) {
    switch (customAlertType) {
      case CustomAlertType.base:
        if (customAlertThemeType == CustomAlertThemeType.filled) {
          return AppColors.grey(isDarkMode).shade700;
        }
        if (customAlertThemeType == CustomAlertThemeType.accent) {
          return AppColors.grey(isDarkMode).shade50;
        }
        return AppColors.white(isDarkMode);
      case CustomAlertType.information:
        if (customAlertThemeType == CustomAlertThemeType.filled) {
          return AppColors.secondary(isDarkMode).shade500;
        }
        if (customAlertThemeType == CustomAlertThemeType.accent) {
          return AppColors.secondary(isDarkMode).shade100;
        }
        return AppColors.white(isDarkMode);
      case CustomAlertType.success:
        if (customAlertThemeType == CustomAlertThemeType.filled) {
          return AppColors.success(isDarkMode).shade600;
        }
        if (customAlertThemeType == CustomAlertThemeType.accent) {
          return AppColors.success(isDarkMode).shade50;
        }
        return AppColors.white(isDarkMode);
      case CustomAlertType.warning:
        if (customAlertThemeType == CustomAlertThemeType.filled) {
          return AppColors.warning(isDarkMode).shade400;
        }
        if (customAlertThemeType == CustomAlertThemeType.accent) {
          return AppColors.warning(isDarkMode).shade50;
        }
        return AppColors.white(isDarkMode);
      case CustomAlertType.error:
        if (customAlertThemeType == CustomAlertThemeType.filled) {
          return AppColors.error(isDarkMode).shade400;
        }
        if (customAlertThemeType == CustomAlertThemeType.accent) {
          return AppColors.error(isDarkMode).shade50;
        }
        return AppColors.white(isDarkMode);
    }
  }

  Color titleTextColor(
      {required CustomAlertType customAlertType,
      required CustomAlertThemeType customAlertThemeType,
      required bool isDarkMode}) {
    if (customAlertType == CustomAlertType.warning) {
      return AppColors.grey(isDarkMode).shade900;
    }
    if (customAlertThemeType == CustomAlertThemeType.filled) {
      return AppColors.white(isDarkMode);
    }
    return AppColors.grey(isDarkMode).shade900;
  }

  Color detailsTextColor(
      {required CustomAlertType customAlertType,
      required CustomAlertThemeType customAlertThemeType,
      required bool isDarkMode}) {
    if (customAlertThemeType == CustomAlertThemeType.filled) {
      if (customAlertType == CustomAlertType.warning) {
        return AppColors.grey(isDarkMode).shade900;
      }
      return AppColors.grey(isDarkMode).shade50;
    }

    return AppColors.grey(isDarkMode).shade600;
  }
}
