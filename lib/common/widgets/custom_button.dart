import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';

import 'custom_tooltip.dart';

enum CustomButtonType {
  primary,
  secondary,
  greyOutlined,
  greySolid,
  destructiveOutlined,
  destructiveSolid,
  text,
}

extension CustomButtonEnumExt on CustomButtonType {
  bool get isFilled => (this == CustomButtonType.primary ||
      this == CustomButtonType.greySolid ||
      this == CustomButtonType.destructiveSolid);

  bool get isOutlined => (this == CustomButtonType.secondary ||
      this == CustomButtonType.greyOutlined ||
      this == CustomButtonType.destructiveOutlined);

  bool get isPrimary => this == CustomButtonType.primary;

  bool get isGreySolid => this == CustomButtonType.greySolid;

  bool get isDestructiveSolid => this == CustomButtonType.destructiveSolid;

  bool get isSecondary => this == CustomButtonType.secondary;
}

enum CustomButtonSize { small, large }

enum CustomButtonIconStyle { none, leadingIcon, trailingIcon, iconOnly }

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.label,
      required this.icon,
      required this.onPressed,
      this.type = CustomButtonType.primary,
      this.iconStyle = CustomButtonIconStyle.none,
      this.size = CustomButtonSize.large,
      this.focusNode,
      this.tooltip
      })
      : super(key: key);

  const CustomButton.noIcon(
      {Key? key,
      required String label,
      required void Function()? onPressed,
      CustomButtonType type = CustomButtonType.primary,
      CustomButtonSize size = CustomButtonSize.small,
      FocusNode? focusNode,
      String? tooltip})
      : this(
            key: key,
            icon: null,
            label: label,
            onPressed: onPressed,
            size: size,
            type: type,
            iconStyle: CustomButtonIconStyle.none,
            focusNode: focusNode,
            tooltip: tooltip);

  CustomButton.leadingIcon(
      {Key? key,
      required String label,
      required IconData icon,
      required void Function()? onPressed,
      CustomButtonType type = CustomButtonType.primary,
      CustomButtonSize size = CustomButtonSize.small,
      FocusNode? focusNode,
      String? tooltip})
      : this(
            key: key,
            label: label,
            icon: Right(icon),
            onPressed: onPressed,
            size: size,
            type: type,
            iconStyle: CustomButtonIconStyle.leadingIcon,
            focusNode: focusNode,
            tooltip: tooltip);

  CustomButton.leadingImage(
      {Key? key,
      required String label,
      required String imagePath,
      required void Function()? onPressed,
      CustomButtonType type = CustomButtonType.primary,
      CustomButtonSize size = CustomButtonSize.small,
      FocusNode? focusNode,
      String? tooltip})
      : this(
            key: key,
            label: label,
            icon: Left(imagePath),
            onPressed: onPressed,
            size: size,
            type: type,
            iconStyle: CustomButtonIconStyle.leadingIcon,
            focusNode: focusNode,
            tooltip: tooltip);

  CustomButton.trailingIcon(
      {Key? key,
      required String label,
      required IconData icon,
      required void Function()? onPressed,
      CustomButtonType type = CustomButtonType.primary,
      CustomButtonSize size = CustomButtonSize.small,
      FocusNode? focusNode,
      String? tooltip})
      : this(
            key: key,
            label: label,
            icon: Right(icon),
            onPressed: onPressed,
            size: size,
            type: type,
            iconStyle: CustomButtonIconStyle.trailingIcon,
            focusNode: focusNode,
            tooltip: tooltip);

  CustomButton.trailingImage(
      {Key? key,
      required String label,
      required String imagePath,
      required void Function()? onPressed,
      CustomButtonType type = CustomButtonType.primary,
      CustomButtonSize size = CustomButtonSize.small,
      FocusNode? focusNode,
      String? tooltip})
      : this(
            key: key,
            label: label,
            icon: Left(imagePath),
            onPressed: onPressed,
            size: size,
            type: type,
            iconStyle: CustomButtonIconStyle.trailingIcon,
            focusNode: focusNode,
            tooltip: tooltip);

  CustomButton.iconOnly(
      {Key? key,
      required IconData icon,
      required void Function()? onPressed,
      CustomButtonType type = CustomButtonType.primary,
      CustomButtonSize size = CustomButtonSize.small,
      FocusNode? focusNode,
      String? tooltip})
      : this(
            key: key,
            label: null,
            icon: Right(icon),
            onPressed: onPressed,
            size: size,
            type: type,
            iconStyle: CustomButtonIconStyle.iconOnly,
            focusNode: focusNode,
            tooltip: tooltip);
  final String? label;
  final Either<String, IconData>? icon;
  final void Function()? onPressed;
  final CustomButtonType type;
  final CustomButtonIconStyle iconStyle;
  final CustomButtonSize size;
  final FocusNode? focusNode;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final isSmall = size == CustomButtonSize.small;
    final labelWithIcon = (iconStyle == CustomButtonIconStyle.trailingIcon ||
        iconStyle == CustomButtonIconStyle.leadingIcon);
    final filledButtonBackgroundColor = type.isPrimary
        ? AppColors.primary.shade500
        : type.isGreySolid
            ? AppColors.grey.shade500
            : AppColors.error.shade500;
    final filledButtonStyle = FilledButton.styleFrom(
        backgroundColor: filledButtonBackgroundColor,
        disabledBackgroundColor: AppColors.grey.shade300,
        disabledForegroundColor: AppColors.white,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        padding: EdgeInsets.symmetric(
            vertical: isSmall ? 8.0 : 16.0,
            horizontal: isSmall
                ? (labelWithIcon ? 12 : 16)
                : (labelWithIcon ? 16 : 24)),
        textStyle: AppTextStyle.getTextStyle(AppTextStyleParams(
            color: AppColors.white,
            appFontWeight: AppFontWeight.semiBold,
            appFontSize: isSmall
                ? AppFontSize.paragraphSmall
                : AppFontSize.paragraphMedium)));

    if (type.isFilled && labelWithIcon) {
      return CustomToolTip(
        message: tooltip,
        child: FilledButton.icon(
          onPressed: onPressed,
          focusNode: focusNode,
          style: filledButtonStyle,
          label: Text(
            label ?? "",
          ),
          icon: icon!.fold(
              (l) => Image.asset(
                    l,
                    width: isSmall ? 15 : 18,
                    fit: BoxFit.fitWidth,
                  ),
              (r) => Icon(
                    r,
                    size: isSmall ? 15 : 18,
                  )),
        ),
      );
    }
    if (type.isFilled && iconStyle == CustomButtonIconStyle.none) {
      return CustomToolTip(
        message: tooltip,
        child: FilledButton(
          onPressed: onPressed,
          focusNode: focusNode,
          style: filledButtonStyle,
          child: Text(
            label ?? "",
          ),
        ),
      );
    }
    if (type.isFilled && iconStyle == CustomButtonIconStyle.iconOnly) {
      return Material(
        color: Colors.transparent,
        child: Ink(
          decoration: ShapeDecoration(
            color: onPressed == null
                ? AppColors.grey.shade300
                : filledButtonBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: CustomToolTip(
            message: tooltip,
            child: IconButton(
              onPressed: onPressed,
              focusNode: focusNode,
              alignment: Alignment.center,
              color: AppColors.white,
              disabledColor: AppColors.white,
              padding: EdgeInsets.all(isSmall ? 8 : 16),
              icon: icon!.fold(
                  (l) => Image.asset(
                        l,
                      ),
                  (r) => Icon(
                        r,
                      )),
            ),
          ),
        ),
      );
    }
    return CustomToolTip(
      message: tooltip,
      child: FilledButton(
        onPressed: onPressed,
        focusNode: focusNode,
        style: filledButtonStyle,
        child: Text(
          label ?? "",
        ),
      ),
    );
  }
}
