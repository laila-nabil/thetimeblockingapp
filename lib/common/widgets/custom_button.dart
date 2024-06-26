import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';

import 'custom_tooltip.dart';

enum CustomButtonType {
  primaryLabel,
  primaryTrailingIcon,
  primaryLeadingIcon,
  primaryIcon,
  secondaryLabel,
  secondaryTrailingIcon,
  secondaryLeadingIcon,
  secondaryIcon,
  greyOutlinedLabel,
  greyOutlinedTrailingIcon,
  greyOutlinedLeadingIcon,
  greyOutlinedIcon,
  greyFilledLabel,
  greyFilledTrailingIcon,
  greyFilledLeadingIcon,
  greyFilledIcon,
  destructiveOutlinedLabel,
  destructiveFilledLabel,
  primaryTextLabel,
  greyTextLabel,
  destructiveTextLabel,
  destructiveOutlinedTrailingIcon,
  destructiveFilledTrailingIcon,
  primaryTextTrailingIcon,
  greyTextTrailingIcon,
  destructiveTextTrailingIcon,
  destructiveOutlinedLeadingIcon,
  destructiveFilledLeadingIcon,
  primaryTextLeadingIcon,
  greyTextLeadingIcon,
  destructiveTextLeadingIcon,
  destructiveOutlinedIcon,
  destructiveFilledIcon,
  primaryTextIcon,
  greyTextIcon,
  destructiveTextIcon,
  primaryIconMinPadding,
  greyIconMinPadding,
  destructiveIconMinPadding,
}

extension CustomButtonTypeExt on CustomButtonType {
  bool get isPrimary => name.toLowerCase().contains("primary");

  bool get isSecondary => name.toLowerCase().contains("secondary");

  bool get isGrey => name.toLowerCase().contains("grey");

  bool get isDestructive => name.toLowerCase().contains("destructive");

  bool get hasIcon => name.toLowerCase().contains("icon");
}

enum CustomButtonSize { small, large, xlarge }

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.label,
      required this.icon,
      required this.onPressed,
      required this.type,
      this.size = CustomButtonSize.large,
      this.focusNode,
      this.child,
      this.tooltip,
      this.analyticsEvent})
      : super(key: key);

  const CustomButton.custom({
    Key? key,
    required Widget child,
    required void Function()? onPressed,
    CustomButtonType type = CustomButtonType.primaryLabel,
    CustomButtonSize size = CustomButtonSize.small,
    FocusNode? focusNode,
    String? tooltip,
    AnalyticsEvents? analyticsEvent,
  }) : this(
            key: key,
            child: child,
            icon: null,
            label: null,
            onPressed: onPressed,
            size: size,
            type: type,
            focusNode: focusNode,
            analyticsEvent: analyticsEvent,
            tooltip: tooltip);

  const CustomButton.noIcon({
    Key? key,
    required String label,
    required void Function()? onPressed,
    CustomButtonType type = CustomButtonType.primaryLabel,
    CustomButtonSize size = CustomButtonSize.small,
    FocusNode? focusNode,
    String? tooltip,
    AnalyticsEvents? analyticsEvent,
  }) : this(
          key: key,
          icon: null,
          label: label,
          onPressed: onPressed,
          size: size,
          type: type,
          focusNode: focusNode,
          tooltip: tooltip,
          analyticsEvent: analyticsEvent,
        );

  CustomButton.leadingIcon({
    Key? key,
    required String label,
    required IconData icon,
    required void Function()? onPressed,
    CustomButtonType type = CustomButtonType.primaryLeadingIcon,
    CustomButtonSize size = CustomButtonSize.small,
    FocusNode? focusNode,
    String? tooltip,
    AnalyticsEvents? analyticsEvent,
  }) : this(
            key: key,
            label: label,
            icon: Right(icon),
            onPressed: onPressed,
            size: size,
            type: type,
            focusNode: focusNode,
            analyticsEvent: analyticsEvent,
            tooltip: tooltip);

  CustomButton.leadingImage({
    Key? key,
    required String label,
    required String imagePath,
    required void Function()? onPressed,
    CustomButtonType type = CustomButtonType.primaryLeadingIcon,
    CustomButtonSize size = CustomButtonSize.small,
    FocusNode? focusNode,
    String? tooltip,
    AnalyticsEvents? analyticsEvent,
  }) : this(
            key: key,
            label: label,
            icon: Left(imagePath),
            onPressed: onPressed,
            size: size,
            type: type,
            focusNode: focusNode,
            analyticsEvent: analyticsEvent,
            tooltip: tooltip);

  CustomButton.trailingIcon({
    Key? key,
    required String label,
    required IconData icon,
    required void Function()? onPressed,
    CustomButtonType type = CustomButtonType.primaryTrailingIcon,
    CustomButtonSize size = CustomButtonSize.small,
    FocusNode? focusNode,
    String? tooltip,
    AnalyticsEvents? analyticsEvent,
  }) : this(
            key: key,
            label: label,
            icon: Right(icon),
            onPressed: onPressed,
            size: size,
            type: type,
            focusNode: focusNode,
            analyticsEvent: analyticsEvent,
            tooltip: tooltip);

  CustomButton.trailingImage({
    Key? key,
    required String label,
    required String imagePath,
    required void Function()? onPressed,
    CustomButtonType type = CustomButtonType.primaryTrailingIcon,
    CustomButtonSize size = CustomButtonSize.small,
    FocusNode? focusNode,
    String? tooltip,
    AnalyticsEvents? analyticsEvent,
  }) : this(
            key: key,
            label: label,
            icon: Left(imagePath),
            onPressed: onPressed,
            size: size,
            type: type,
            focusNode: focusNode,
            analyticsEvent: analyticsEvent,
            tooltip: tooltip);

  CustomButton.iconOnly({
    Key? key,
    required IconData icon,
    required void Function()? onPressed,
    CustomButtonType type = CustomButtonType.primaryIcon,
    CustomButtonSize size = CustomButtonSize.small,
    FocusNode? focusNode,
    String? tooltip,
    AnalyticsEvents? analyticsEvent,
  }) : this(
            key: key,
            label: null,
            icon: Right(icon),
            onPressed: onPressed,
            size: size,
            type: type,
            focusNode: focusNode,
            analyticsEvent: analyticsEvent,
            tooltip: tooltip);
  final String? label;
  final Widget? child;
  final Either<String, IconData>? icon;
  final void Function()? onPressed;
  final CustomButtonType type;
  final CustomButtonSize size;
  final FocusNode? focusNode;
  final String? tooltip;
  final AnalyticsEvents? analyticsEvent;

  @override
  Widget build(BuildContext context) {
    onPressedWithAnalytics() {
      if (onPressed != null) {
        if (analyticsEvent != null) {
          serviceLocator<Analytics>().logEvent(analyticsEvent.toString());
        }
        onPressed!();
      }
    }

    final isSmall = size == CustomButtonSize.small;
    final double buttonHeight = isSmall ? 36 : 56;
    final notOnlyLabel = type.hasIcon || child != null;
    final borderRadius = BorderRadius.circular(6);
    final verticalFilledOutlinedVerticalPadding = isSmall ? 8.0 : 16.0;
    final filledButtonBackgroundColor = type.isPrimary
        ? AppColors.primary(context.isDarkMode).shade500
        : type.isGrey
            ? AppColors.grey(context.isDarkMode).shade500
            : AppColors.error(context.isDarkMode).shade500;
    final filledButtonStyle = ButtonStyle(
        fixedSize: MaterialStatePropertyAll(Size.fromHeight(buttonHeight)),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.focused) ||
              states.contains(MaterialState.pressed)) {
            return filledButtonBackgroundColor;
          }
          if (states.contains(MaterialState.hovered)) {
            return type.isPrimary
                ? AppColors.primary(context.isDarkMode).shade400
                : type.isGrey
                    ? AppColors.grey(context.isDarkMode).shade700
                    : AppColors.error(context.isDarkMode).shade300;
          }
          if (states.contains(MaterialState.disabled)) {
            return AppColors.grey(context.isDarkMode).shade300;
          }
          return type.isPrimary
              ? AppColors.primary(context.isDarkMode).shade500
              : type.isGrey
                  ? AppColors.grey(context.isDarkMode).shade500
                  : AppColors.error(context.isDarkMode).shade500;
        }),
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          return AppColors.white(context.isDarkMode);
        }),
        shape: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          );
        }),
        padding: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          return EdgeInsets.symmetric(
              vertical: verticalFilledOutlinedVerticalPadding,
              horizontal: isSmall
                  ? (notOnlyLabel ? 12 : 16)
                  : (notOnlyLabel ? 16 : 24));
        }),
        textStyle:
            MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          return AppTextStyle.getTextStyle(AppTextStyleParams(
              color: AppColors.white(context.isDarkMode),
              appFontWeight: AppFontWeight.semiBold,
              appFontSize: isSmall
                  ? AppFontSize.paragraphSmall
                  : AppFontSize.paragraphMedium,));
        }));

    Color outlinedButtonBorderColor(Set<MaterialState> states) =>
        states.contains(MaterialState.disabled)
            ? AppColors.grey(context.isDarkMode).shade100
            : type.isSecondary
                ? (states.contains(MaterialState.hovered)
                    ? AppColors.primary(context.isDarkMode).shade700
                    : AppColors.primary(context.isDarkMode).shade600)
                : type.isGrey
                    ? (states.contains(MaterialState.focused)
                        ? AppColors.grey(context.isDarkMode).shade100
                        : AppColors.grey(context.isDarkMode).shade300)
                    : AppColors.error(context.isDarkMode).shade400;
    double outlinedButtonBorderWidth(Set<MaterialState> states) =>
        states.contains(MaterialState.disabled) ||
                states.contains(MaterialState.focused)
            ? 2.0
            : (type.isGrey ? 1.0 : 1.5);
    final outlinedButtonDisabledForegroundColor =
        AppColors.grey(context.isDarkMode).shade400;
    final outlinedButtonForegroundColor = type.isSecondary
        ? AppColors.primary(context.isDarkMode).shade600
        : type.isGrey
            ? AppColors.grey(context.isDarkMode).shade700
            : AppColors.error(context.isDarkMode).shade400;
    final outlinedButtonStyle = ButtonStyle(
      fixedSize: MaterialStatePropertyAll(Size.fromHeight(buttonHeight)),
      side: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        return BorderSide(
            color: outlinedButtonBorderColor(states),
            width: outlinedButtonBorderWidth(states),
            style: BorderStyle.solid);
      }),
      backgroundColor:
          MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.white(context.isDarkMode);
        }
        if (states.contains(MaterialState.hovered) ||
            states.contains(MaterialState.focused)) {
          return type.isSecondary
              ? AppColors.primary(context.isDarkMode).shade50
              : type.isGrey
                  ? AppColors.grey(context.isDarkMode).shade50
                  : AppColors.error(context.isDarkMode).shade50;
        }

        return AppColors.white(context.isDarkMode);
      }),
      foregroundColor:
          MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return outlinedButtonDisabledForegroundColor;
        }
        return outlinedButtonForegroundColor;
      }),
      shape: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        );
      }),
      padding: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        return EdgeInsets.symmetric(
            vertical: verticalFilledOutlinedVerticalPadding,
            horizontal:
                isSmall ? (notOnlyLabel ? 12 : 16) : (notOnlyLabel ? 16 : 24));
      }),
      textStyle: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        return AppTextStyle.getTextStyle(AppTextStyleParams(
            color: AppColors.white(context.isDarkMode),
            appFontWeight: AppFontWeight.semiBold,
            appFontSize: isSmall
                ? AppFontSize.paragraphSmall
                : AppFontSize.paragraphMedium,));
      }),
    );
    final labelWidget = Text(
      label ?? "",
    );
    final iconWidget = icon?.fold(
            (l) => Image.asset(
                  l,
                  width: isSmall ? 15 : 18,
                  fit: BoxFit.fitWidth,
                ),
            (r) => Icon(
                  r,
                  size: isSmall ? 15 : 18,
                )) ??
        Container();
    Widget filledLabelButton(Either<Widget, String> child) => CustomToolTip(
          message: tooltip,
          child: FilledButton(
            onPressed: onPressedWithAnalytics,
            focusNode: focusNode,
            style: filledButtonStyle,
            child: child.fold(
                (l) => l,
                (r) => Text(
                      r ?? "",
                    )),
          ),
        );
    final filledLeadingIconButton = CustomToolTip(
      message: tooltip,
      child: FilledButton.icon(
        onPressed: onPressedWithAnalytics,
        focusNode: focusNode,
        style: filledButtonStyle,
        label: labelWidget,
        icon: iconWidget,
      ),
    );
    final double scale = MediaQuery.textScaleFactorOf(context);
    // Adjust the gap based on the text scale factor. Start at 8, and lerp
    // to 4 based on how large the text is.
    final double gap = scale <= 1 ? 8 : lerpDouble(8, 4, math.min(scale - 1, 1))!;
    final filledTrailingIconButton = true ? CustomToolTip(
      message: tooltip,
      child: FilledButton(
        onPressed: onPressedWithAnalytics,
        focusNode: focusNode,
        style: filledButtonStyle,
        child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(child: labelWidget),
                  SizedBox(width: gap),
                  iconWidget,
                ],
              ),
            ),
    ): CustomToolTip(
      message: tooltip,
      child: FilledButton.icon(
        onPressed: onPressedWithAnalytics,
        focusNode: focusNode,
        style: filledButtonStyle,
        label: labelWidget,
        icon: iconWidget,
      ),
    );
    final filledIconButton = Material(
      color: Colors.transparent,
      child: Ink(
        decoration: ShapeDecoration(
          color: onPressed == null
              ? AppColors.grey(context.isDarkMode).shade300
              : filledButtonBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
        ),
        child: CustomToolTip(
          message: tooltip,
          child: IconButton(
            onPressed: onPressedWithAnalytics,
            focusNode: focusNode,
            alignment: Alignment.center,
            color: AppColors.white(context.isDarkMode),
            disabledColor: AppColors.white(context.isDarkMode),
            padding: EdgeInsets.all(verticalFilledOutlinedVerticalPadding),
            icon: iconWidget,
          ),
        ),
      ),
    );
    final outlinedLeadingIconButton = CustomToolTip(
      message: tooltip,
      child: OutlinedButton.icon(
        onPressed: onPressedWithAnalytics,
        focusNode: focusNode,
        style: outlinedButtonStyle,
        label: Text(
          label ?? "",
        ),
        icon: iconWidget,
      ),
    );
    final outlinedTrailingIconButton = CustomToolTip(
      message: tooltip,
      child: OutlinedButton(
        onPressed: onPressedWithAnalytics,
        focusNode: focusNode,
        style: outlinedButtonStyle,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(child: labelWidget),
            SizedBox(width: gap),
            iconWidget,
          ],
        ),
      ),
    );
    Widget outlinedLabelButton(Either<Widget, String> child) => CustomToolTip(
          message: tooltip,
          child: OutlinedButton(
            onPressed: onPressedWithAnalytics,
            focusNode: focusNode,
            style: outlinedButtonStyle,
            child: child.fold((l) => l, (r) => Text(r ?? "")),
          ),
        );
    final outlinedIconButton = SizedBox(
      width: buttonHeight,
      height: buttonHeight,
      child: CustomToolTip(
        message: tooltip,
        child: TextButton(
          onPressed: onPressedWithAnalytics,
          focusNode: focusNode,
          style: outlinedButtonStyle.copyWith(
              alignment: Alignment.center,
              padding: const MaterialStatePropertyAll(EdgeInsets.zero),
              fixedSize:
                  MaterialStatePropertyAll(Size(buttonHeight, buttonHeight))),
          child: iconWidget,
        ),
      ),
    );
    Color textForegroundColor(Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return AppColors.grey(context.isDarkMode).shade300;
      }
      if (type.isPrimary) {
        return states.contains(MaterialState.focused)
            ? AppColors.primary(context.isDarkMode).shade700
            : states.contains(MaterialState.hovered)
                ? AppColors.primary(context.isDarkMode).shade600
                : AppColors.primary(context.isDarkMode).shade500;
      }
      if (type.isGrey) {
        return states.contains(MaterialState.focused)
            ? AppColors.grey(context.isDarkMode).shade700
            : states.contains(MaterialState.hovered)
                ? AppColors.grey(context.isDarkMode).shade400
                : AppColors.grey(context.isDarkMode).shade500;
      }
      return AppColors.error(context.isDarkMode).shade400;
    }

    final textButtonStyle = ButtonStyle(
      textStyle: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        return AppTextStyle.getTextStyle(AppTextStyleParams(
            appFontSize: isSmall
                ? AppFontSize.paragraphSmall
                : AppFontSize.paragraphMedium,
            color: textForegroundColor(states),
            appFontWeight: AppFontWeight.semiBold,));
      }),
      foregroundColor: MaterialStateProperty.resolveWith(
          (Set<MaterialState> states) => textForegroundColor(states)),
      padding: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        return isSmall
            ? EdgeInsets.symmetric(
                vertical: 8.0, horizontal: (notOnlyLabel ? 12 : 16))
            : EdgeInsets.zero;
      }),
    );
    Widget textLabelButton(Either<Widget, String> child) => CustomToolTip(
        message: tooltip,
        child: TextButton(
          onPressed: onPressedWithAnalytics,
          style: textButtonStyle,
          child: child.fold((l) => l, (r) => Text(r ?? "")),
        ));
    final textTrailingIconButton = CustomToolTip(
        message: tooltip,
        child: TextButton(
          style: textButtonStyle,
          onPressed: onPressedWithAnalytics,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(child: labelWidget),
              SizedBox(width: gap),
              iconWidget,
            ],
          ),
        ));
    final textLeadingIconButton = CustomToolTip(
        message: tooltip,
        child: TextButton.icon(
          style: textButtonStyle,
          onPressed: onPressedWithAnalytics,
          icon: iconWidget,
          label: labelWidget,
        ));
    final textIconButton = SizedBox(
      width: buttonHeight,
      height: buttonHeight,
      child: CustomToolTip(
        message: tooltip,
        child: TextButton(
          onPressed: onPressedWithAnalytics,
          focusNode: focusNode,
          style: textButtonStyle.copyWith(
            alignment: Alignment.center,
            padding: const MaterialStatePropertyAll(EdgeInsets.zero),
          ),
          child: iconWidget,
        ),
      ),
    );
    final iconMinPaddingButton = SizedBox(
      width: isSmall ? 15 : 18,
      height: isSmall ? 15 : 18,
      child: CustomToolTip(
        message: tooltip,
        child: IconButton(
          padding: EdgeInsets.zero,
          onPressed: onPressedWithAnalytics,
          focusNode: focusNode,
          style: textButtonStyle.copyWith(
            alignment: Alignment.center,
            padding: const MaterialStatePropertyAll(EdgeInsets.zero),
          ),
          iconSize: isSmall ? 15 : 18,
          icon: iconWidget,
        ),
      ),
    );
    switch (type) {
      case (CustomButtonType.primaryLabel):
        return filledLabelButton(
            child == null ? Right(label ?? "") : Left(child ?? Container()));
      case (CustomButtonType.primaryTrailingIcon):
        return filledTrailingIconButton;
      case (CustomButtonType.primaryLeadingIcon):
        return filledLeadingIconButton;
      case (CustomButtonType.primaryIcon):
        return filledIconButton;
      case (CustomButtonType.secondaryLabel):
        return outlinedLabelButton(
            child == null ? Right(label ?? "") : Left(child ?? Container()));
      case (CustomButtonType.secondaryTrailingIcon):
        return outlinedTrailingIconButton;
      case (CustomButtonType.secondaryLeadingIcon):
        return outlinedLeadingIconButton;
      case (CustomButtonType.secondaryIcon):
        return outlinedIconButton;
      case (CustomButtonType.greyFilledLabel):
        return filledLabelButton(
            child == null ? Right(label ?? "") : Left(child ?? Container()));
      case (CustomButtonType.greyFilledTrailingIcon):
        return filledTrailingIconButton;
      case (CustomButtonType.greyFilledLeadingIcon):
        return filledLeadingIconButton;
      case (CustomButtonType.greyFilledIcon):
        return filledIconButton;
      case (CustomButtonType.destructiveFilledLabel):
        return filledLabelButton(
            child == null ? Right(label ?? "") : Left(child ?? Container()));
      case (CustomButtonType.destructiveFilledTrailingIcon):
        return filledTrailingIconButton;
      case (CustomButtonType.destructiveFilledLeadingIcon):
        return filledLeadingIconButton;
      case (CustomButtonType.destructiveFilledIcon):
        return filledIconButton;

      case (CustomButtonType.greyOutlinedLabel):
        return outlinedLabelButton(
            child == null ? Right(label ?? "") : Left(child ?? Container()));
      case (CustomButtonType.greyOutlinedTrailingIcon):
        return outlinedTrailingIconButton;
      case (CustomButtonType.greyOutlinedLeadingIcon):
        return outlinedLeadingIconButton;
      case (CustomButtonType.greyOutlinedIcon):
        return outlinedIconButton;
      case (CustomButtonType.destructiveOutlinedLabel):
        return outlinedLabelButton(
            child == null ? Right(label ?? "") : Left(child ?? Container()));
      case (CustomButtonType.destructiveOutlinedTrailingIcon):
        return outlinedTrailingIconButton;
      case (CustomButtonType.destructiveOutlinedLeadingIcon):
        return outlinedLeadingIconButton;
      case (CustomButtonType.destructiveOutlinedIcon):
        return outlinedIconButton;

      case (CustomButtonType.primaryTextLabel):
        return textLabelButton(
            child == null ? Right(label ?? "") : Left(child ?? Container()));
      case (CustomButtonType.primaryTextTrailingIcon):
        return textTrailingIconButton;
      case (CustomButtonType.primaryTextLeadingIcon):
        return textLeadingIconButton;
      case (CustomButtonType.primaryTextIcon):
        return textIconButton;
      case (CustomButtonType.primaryIconMinPadding):
        return iconMinPaddingButton;

      case (CustomButtonType.greyTextLabel):
        return textLabelButton(
            child == null ? Right(label ?? "") : Left(child ?? Container()));
      case (CustomButtonType.greyTextTrailingIcon):
        return textTrailingIconButton;
      case (CustomButtonType.greyTextLeadingIcon):
        return textLeadingIconButton;
      case (CustomButtonType.greyTextIcon):
        return textIconButton;
      case (CustomButtonType.greyIconMinPadding):
        return iconMinPaddingButton;

      case (CustomButtonType.destructiveTextLabel):
        return textLabelButton(
            child == null ? Right(label ?? "") : Left(child ?? Container()));
      case (CustomButtonType.destructiveTextTrailingIcon):
        return textTrailingIconButton;
      case (CustomButtonType.destructiveTextLeadingIcon):
        return textLeadingIconButton;
      case (CustomButtonType.destructiveTextIcon):
        return textIconButton;
      case (CustomButtonType.destructiveIconMinPadding):
        return iconMinPaddingButton;
      default:
        return filledLabelButton(
            child == null ? Right(label ?? "") : Left(child ?? Container()));
    }
  }
}
