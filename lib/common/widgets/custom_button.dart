import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:dartz/dartz.dart' as dartz; 
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

enum CustomButtonSize { xSmall ,small, large, xlarge }

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.label,
      required this.icon,
      required this.onPressed,
      required this.type,
      this.size = CustomButtonSize.large,
      this.focusNode,
      this.child,
      this.tooltip,
      this.analyticsEvent});

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
            icon: dartz.Right(icon),
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
            icon: dartz.Left(imagePath),
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
            icon: dartz.Right(icon),
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
            icon: dartz.Left(imagePath),
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
            icon: dartz.Right(icon),
            onPressed: onPressed,
            size: size,
            type: type,
            focusNode: focusNode,
            analyticsEvent: analyticsEvent,
            tooltip: tooltip);
  final String? label;
  final Widget? child;
  final dartz.Either<String, IconData>? icon;
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
          unawaited(serviceLocator<Analytics>().logEvent(analyticsEvent!.name));
        }
        onPressed!();
      }
    }

    double buttonMinIconButtonSize (){
      switch (size) {
        case CustomButtonSize.xSmall:
          return 22;
        case CustomButtonSize.small:
          return 36;
        case CustomButtonSize.large:
          return 56;
        case CustomButtonSize.xlarge:
          return 56;
      }
    }
    double iconSize() {
      switch (size) {
        case CustomButtonSize.xSmall:
          return 15;
        case CustomButtonSize.small:
          return 15;
        case CustomButtonSize.large:
          return 18;
        case CustomButtonSize.xlarge:
          return 18;
      }
    }

    AppFontSize fontSize() {
      switch (size) {
        case CustomButtonSize.xSmall:
          return AppFontSize.paragraphX2Small;
        case CustomButtonSize.small:
          return AppFontSize.paragraphSmall;
        case CustomButtonSize.large:
          return AppFontSize.paragraphMedium;
        case CustomButtonSize.xlarge:
          return AppFontSize.paragraphMedium;
      }
    }
    final notOnlyLabel = type.hasIcon || child != null;
    final borderRadius = BorderRadius.circular(6);
    double horizontalPadding(bool notOnlyLabel) {
      switch (size) {
        case CustomButtonSize.xSmall:
          return (notOnlyLabel ? 6 : 10);
        case CustomButtonSize.small:
          return (notOnlyLabel ? 12 : 16);
        case CustomButtonSize.large:
          return (notOnlyLabel ? 16 : 24);
        case CustomButtonSize.xlarge:
          return (notOnlyLabel ? 16 : 24);
      }
    }
    double verticalFilledOutlinedVerticalPadding (){
      switch (size) {
        case CustomButtonSize.xSmall:
          return 8;
        case CustomButtonSize.small:
          return 8;
        case CustomButtonSize.large:
          return 16;
        case CustomButtonSize.xlarge:
          return 16;
      }
    }
    final filledButtonBackgroundColor = type.isPrimary
        ? AppColors.primary(context.isDarkMode).shade500
        : type.isGrey
            ? AppColors.grey(context.isDarkMode).shade500
            : AppColors.error(context.isDarkMode).shade500;
    final filledButtonStyle = ButtonStyle(
        // fixedSize: WidgetStatePropertyAll(Size.fromHeight(buttonMaxHeight())),
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
          if (states.contains(WidgetState.focused) ||
              states.contains(WidgetState.pressed)) {
            return filledButtonBackgroundColor;
          }
          if (states.contains(WidgetState.hovered)) {
            return type.isPrimary
                ? AppColors.primary(context.isDarkMode).shade400
                : type.isGrey
                    ? AppColors.grey(context.isDarkMode).shade700
                    : AppColors.error(context.isDarkMode).shade300;
          }
          if (states.contains(WidgetState.disabled)) {
            return AppColors.grey(context.isDarkMode).shade300;
          }
          return type.isPrimary
              ? AppColors.primary(context.isDarkMode).shade500
              : type.isGrey
                  ? AppColors.grey(context.isDarkMode).shade500
                  : AppColors.error(context.isDarkMode).shade500;
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
          return AppColors.white(context.isDarkMode);
        }),
        shape: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          );
        }),
        padding: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          return EdgeInsets.symmetric(
              vertical: verticalFilledOutlinedVerticalPadding(),
              horizontal: horizontalPadding(notOnlyLabel));
        }),
        textStyle:
            WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          return AppTextStyle.getTextStyle(AppTextStyleParams(
              color: AppColors.white(context.isDarkMode),
              appFontWeight: AppFontWeight.semiBold,
              appFontSize: fontSize(),));
        }));

    Color outlinedButtonBorderColor(Set<WidgetState> states) =>
        states.contains(WidgetState.disabled)
            ? AppColors.grey(context.isDarkMode).shade100
            : type.isSecondary
                ? (states.contains(WidgetState.hovered)
                    ? AppColors.primary(context.isDarkMode).shade700
                    : AppColors.primary(context.isDarkMode).shade600)
                : type.isGrey
                    ? (states.contains(WidgetState.focused)
                        ? AppColors.grey(context.isDarkMode).shade100
                        : AppColors.grey(context.isDarkMode).shade300)
                    : AppColors.error(context.isDarkMode).shade400;
    double outlinedButtonBorderWidth(Set<WidgetState> states) =>
        states.contains(WidgetState.disabled) ||
                states.contains(WidgetState.focused)
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
      side: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        return BorderSide(
            color: outlinedButtonBorderColor(states),
            width: outlinedButtonBorderWidth(states),
            style: BorderStyle.solid);
      }),
      backgroundColor:
          WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.white(context.isDarkMode);
        }
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return type.isSecondary
              ? AppColors.primary(context.isDarkMode).shade50
              : type.isGrey
                  ? AppColors.grey(context.isDarkMode).shade50
                  : AppColors.error(context.isDarkMode).shade50;
        }

        return AppColors.white(context.isDarkMode);
      }),
      foregroundColor:
          WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return outlinedButtonDisabledForegroundColor;
        }
        return outlinedButtonForegroundColor;
      }),
      shape: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        );
      }),
      padding: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        return EdgeInsets.symmetric(
            vertical: verticalFilledOutlinedVerticalPadding(),
            horizontal:
                horizontalPadding(notOnlyLabel));
      }),
      textStyle: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        return AppTextStyle.getTextStyle(AppTextStyleParams(
            color: AppColors.white(context.isDarkMode),
            appFontWeight: AppFontWeight.semiBold,
            appFontSize: fontSize(),));
      }),
    );
    final labelWidget = Text(
      label ?? "",
    );
    final iconWidget = icon?.fold(
            (l) => Image.asset(
                  l,
                  width: iconSize(),
                  fit: BoxFit.fitWidth,
                ),
            (r) => Icon(
                  r,
                  size: iconSize(),
                )) ??
        Container();
    Widget filledLabelButton(dartz.Either<Widget, String> child) => CustomToolTip(
          message: tooltip,
          child: FilledButton(
            onPressed: onPressedWithAnalytics,
            focusNode: focusNode,
            style: filledButtonStyle,
            child: child.fold(
                (l) => l,
                (r) => Text(
                      r,
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
            padding: EdgeInsets.all(verticalFilledOutlinedVerticalPadding()),
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
    Widget outlinedLabelButton(dartz.Either<Widget, String> child) => CustomToolTip(
          message: tooltip,
          child: OutlinedButton(
            onPressed: onPressedWithAnalytics,
            focusNode: focusNode,
            style: outlinedButtonStyle,
            child: child.fold((l) => l, (r) => Text(r )),
          ),
        );
    final outlinedIconButton = SizedBox(
      width: buttonMinIconButtonSize(),
      height: buttonMinIconButtonSize(),
      child: CustomToolTip(
        message: tooltip,
        child: TextButton(
          onPressed: onPressedWithAnalytics,
          focusNode: focusNode,
          style: outlinedButtonStyle.copyWith(
              alignment: Alignment.center,
              padding: const WidgetStatePropertyAll(EdgeInsets.zero),
              fixedSize:
                  WidgetStatePropertyAll(Size(buttonMinIconButtonSize(), buttonMinIconButtonSize()))),
          child: iconWidget,
        ),
      ),
    );
    Color textForegroundColor(Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return AppColors.grey(context.isDarkMode).shade300;
      }
      if (type.isPrimary) {
        return states.contains(WidgetState.focused)
            ? AppColors.primary(context.isDarkMode).shade700
            : states.contains(WidgetState.hovered)
                ? AppColors.primary(context.isDarkMode).shade600
                : AppColors.primary(context.isDarkMode).shade500;
      }
      if (type.isGrey) {
        return states.contains(WidgetState.focused)
            ? AppColors.grey(context.isDarkMode).shade700
            : states.contains(WidgetState.hovered)
                ? AppColors.grey(context.isDarkMode).shade400
                : AppColors.grey(context.isDarkMode).shade500;
      }
      return AppColors.error(context.isDarkMode).shade400;
    }

    final textButtonStyle = ButtonStyle(
      textStyle: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        return AppTextStyle.getTextStyle(AppTextStyleParams(
            appFontSize: fontSize(),
            color: textForegroundColor(states),
            appFontWeight: AppFontWeight.semiBold,));
      }),
      foregroundColor: WidgetStateProperty.resolveWith(
          (Set<WidgetState> states) => textForegroundColor(states)),
      padding: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        switch (size) {
          case CustomButtonSize.xSmall:
            return EdgeInsets.symmetric(
                vertical: 8.0, horizontal: (notOnlyLabel ? 8 : 10));
          case CustomButtonSize.small:
            return EdgeInsets.symmetric(
                vertical: 8.0, horizontal: (notOnlyLabel ? 12 : 16));
          case CustomButtonSize.large:
            return EdgeInsets.zero;
          case CustomButtonSize.xlarge:
            return EdgeInsets.zero;
        }
      }),
    );
    Widget textLabelButton(dartz.Either<Widget, String> child) => CustomToolTip(
        message: tooltip,
        child: TextButton(
          onPressed: onPressedWithAnalytics,
          style: textButtonStyle,
          child: child.fold((l) => l, (r) => Text(r )),
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
      width: buttonMinIconButtonSize(),
      height: buttonMinIconButtonSize(),
      child: CustomToolTip(
        message: tooltip,
        child: TextButton(
          onPressed: onPressedWithAnalytics,
          focusNode: focusNode,
          style: textButtonStyle.copyWith(
            alignment: Alignment.center,
            padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          ),
          child: iconWidget,
        ),
      ),
    );
    final iconMinPaddingButton = SizedBox(
      width: iconSize(),
      height: iconSize(),
      child: CustomToolTip(
        message: tooltip,
        child: IconButton(
          padding: EdgeInsets.zero,
          onPressed: onPressedWithAnalytics,
          focusNode: focusNode,
          style: textButtonStyle.copyWith(
            alignment: Alignment.center,
            padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          ),
          iconSize: iconSize(),
          icon: iconWidget,
        ),
      ),
    );
    switch (type) {
      case (CustomButtonType.primaryLabel):
        return filledLabelButton(
            child == null ? dartz.Right(label ?? "") : dartz.Left(child ?? Container()));
      case (CustomButtonType.primaryTrailingIcon):
        return filledTrailingIconButton;
      case (CustomButtonType.primaryLeadingIcon):
        return filledLeadingIconButton;
      case (CustomButtonType.primaryIcon):
        return filledIconButton;
      case (CustomButtonType.secondaryLabel):
        return outlinedLabelButton(
            child == null ? dartz.Right(label ?? "") : dartz.Left(child ?? Container()));
      case (CustomButtonType.secondaryTrailingIcon):
        return outlinedTrailingIconButton;
      case (CustomButtonType.secondaryLeadingIcon):
        return outlinedLeadingIconButton;
      case (CustomButtonType.secondaryIcon):
        return outlinedIconButton;
      case (CustomButtonType.greyFilledLabel):
        return filledLabelButton(
            child == null ? dartz.Right(label ?? "") : dartz.Left(child ?? Container()));
      case (CustomButtonType.greyFilledTrailingIcon):
        return filledTrailingIconButton;
      case (CustomButtonType.greyFilledLeadingIcon):
        return filledLeadingIconButton;
      case (CustomButtonType.greyFilledIcon):
        return filledIconButton;
      case (CustomButtonType.destructiveFilledLabel):
        return filledLabelButton(
            child == null ? dartz.Right(label ?? "") : dartz.Left(child ?? Container()));
      case (CustomButtonType.destructiveFilledTrailingIcon):
        return filledTrailingIconButton;
      case (CustomButtonType.destructiveFilledLeadingIcon):
        return filledLeadingIconButton;
      case (CustomButtonType.destructiveFilledIcon):
        return filledIconButton;

      case (CustomButtonType.greyOutlinedLabel):
        return outlinedLabelButton(
            child == null ? dartz.Right(label ?? "") : dartz.Left(child ?? Container()));
      case (CustomButtonType.greyOutlinedTrailingIcon):
        return outlinedTrailingIconButton;
      case (CustomButtonType.greyOutlinedLeadingIcon):
        return outlinedLeadingIconButton;
      case (CustomButtonType.greyOutlinedIcon):
        return outlinedIconButton;
      case (CustomButtonType.destructiveOutlinedLabel):
        return outlinedLabelButton(
            child == null ? dartz.Right(label ?? "") : dartz.Left(child ?? Container()));
      case (CustomButtonType.destructiveOutlinedTrailingIcon):
        return outlinedTrailingIconButton;
      case (CustomButtonType.destructiveOutlinedLeadingIcon):
        return outlinedLeadingIconButton;
      case (CustomButtonType.destructiveOutlinedIcon):
        return outlinedIconButton;

      case (CustomButtonType.primaryTextLabel):
        return textLabelButton(
            child == null ? dartz.Right(label ?? "") : dartz.Left(child ?? Container()));
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
            child == null ? dartz.Right(label ?? "") : dartz.Left(child ?? Container()));
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
            child == null ? dartz.Right(label ?? "") : dartz.Left(child ?? Container()));
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
            child == null ? dartz.Right(label ?? "") : dartz.Left(child ?? Container()));
    }
  }
  }
