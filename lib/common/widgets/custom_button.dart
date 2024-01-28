import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';

import 'custom_tooltip.dart';

///TODO trailing icon not done
///TODO needs refactoring
///TODO icons in iconNotFilledNotOutlined
///TODO icon sizes in label with icon

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
        this.tooltip})
      : super(key: key);

  const CustomButton.custom(
      {Key? key,
        required Widget child,
        required void Function()? onPressed,
        CustomButtonType type = CustomButtonType.primaryLabel,
        CustomButtonSize size = CustomButtonSize.small,
        FocusNode? focusNode,
        String? tooltip})
      : this(
      key: key,
      child: child,
      icon: null,
      label: null,
      onPressed: onPressed,
      size: size,
      type: type,
      focusNode: focusNode,
      tooltip: tooltip);

  const CustomButton.noIcon(
      {Key? key,
        required String label,
        required void Function()? onPressed,
        CustomButtonType type = CustomButtonType.primaryLabel,
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
      focusNode: focusNode,
      tooltip: tooltip);

  CustomButton.leadingIcon(
      {Key? key,
        required String label,
        required IconData icon,
        required void Function()? onPressed,
        CustomButtonType type = CustomButtonType.primaryLeadingIcon,
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
      focusNode: focusNode,
      tooltip: tooltip);

  CustomButton.leadingImage(
      {Key? key,
        required String label,
        required String imagePath,
        required void Function()? onPressed,
        CustomButtonType type = CustomButtonType.primaryLeadingIcon,
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
      focusNode: focusNode,
      tooltip: tooltip);

  CustomButton.trailingIcon(
      {Key? key,
        required String label,
        required IconData icon,
        required void Function()? onPressed,
        CustomButtonType type = CustomButtonType.primaryTrailingIcon,
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
      focusNode: focusNode,
      tooltip: tooltip);

  CustomButton.trailingImage(
      {Key? key,
        required String label,
        required String imagePath,
        required void Function()? onPressed,
        CustomButtonType type = CustomButtonType.primaryTrailingIcon,
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
      focusNode: focusNode,
      tooltip: tooltip);

  CustomButton.iconOnly(
      {Key? key,
        required IconData icon,
        required void Function()? onPressed,
        CustomButtonType type = CustomButtonType.primaryIcon,
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
      focusNode: focusNode,
      tooltip: tooltip);
  final String? label;
  final Widget? child;
  final Either<String, IconData>? icon;
  final void Function()? onPressed;
  final CustomButtonType type;
  final CustomButtonSize size;
  final FocusNode? focusNode;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final isSmall = size == CustomButtonSize.small;
    final double buttonHeight = isSmall ? 36 : 56;
    final labelWithIcon = type.hasIcon;
    final borderRadius = BorderRadius.circular(6);
    final verticalFilledOutlinedVerticalPadding = isSmall ? 8.0 : 16.0;
    final filledButtonBackgroundColor = type.isPrimary
        ? AppColors.primary.shade500
        : type.isGrey
        ? AppColors.grey.shade500
        : AppColors.error.shade500;
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
                    ? AppColors.primary.shade400
                    : type.isGrey
                    ? AppColors.grey.shade700
                    : AppColors.error.shade300;
              }
              if (states.contains(MaterialState.disabled)) {
                return AppColors.grey.shade300;
              }
              return type.isPrimary
                  ? AppColors.primary.shade500
                  : type.isGrey
                  ? AppColors.grey.shade500
                  : AppColors.error.shade500;
            }),
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              return AppColors.white;
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
                  ? (labelWithIcon ? 12 : 16)
                  : (labelWithIcon ? 16 : 24));
        }),
        textStyle:
        MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          return AppTextStyle.getTextStyle(AppTextStyleParams(
              color: AppColors.white,
              appFontWeight: AppFontWeight.semiBold,
              appFontSize: isSmall
                  ? AppFontSize.paragraphSmall
                  : AppFontSize.paragraphMedium));
        }));

    Color outlinedButtonBorderColor(Set<MaterialState> states) =>
        states.contains(MaterialState.disabled)
            ? AppColors.grey.shade100
            : type.isSecondary
            ? (states.contains(MaterialState.hovered)
            ? AppColors.primary.shade700
            : AppColors.primary.shade600)
            : type.isGrey
            ? (states.contains(MaterialState.focused)
            ? AppColors.grey.shade100
            : AppColors.grey.shade300)
            : AppColors.error.shade400;
    double outlinedButtonBorderWidth(Set<MaterialState> states) =>
        states.contains(MaterialState.disabled) ||
            states.contains(MaterialState.focused)
            ? 2.0
            : (type.isGrey ? 1.0 : 1.5);
    final outlinedButtonDisabledForegroundColor = AppColors.grey.shade400;
    final outlinedButtonForegroundColor = type.isSecondary
        ? AppColors.primary.shade600
        : type.isGrey
        ? AppColors.grey.shade700
        : AppColors.error.shade400;
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
          return AppColors.white;
        }
        if (states.contains(MaterialState.hovered) ||
            states.contains(MaterialState.focused)) {
          return type.isSecondary
              ? AppColors.primary.shade50
              : type.isGrey
              ? AppColors.grey.shade50
              : AppColors.error.shade50;
        }

        return AppColors.white;
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
            horizontal: isSmall
                ? (labelWithIcon ? 12 : 16)
                : (labelWithIcon ? 16 : 24));
      }),
      textStyle: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        return AppTextStyle.getTextStyle(AppTextStyleParams(
            color: AppColors.white,
            appFontWeight: AppFontWeight.semiBold,
            appFontSize: isSmall
                ? AppFontSize.paragraphSmall
                : AppFontSize.paragraphMedium));
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
    Widget filledLabel(Either<Widget,String> child) => CustomToolTip(
      message: tooltip,
      child: FilledButton(
        onPressed: onPressed,
        focusNode: focusNode,
        style: filledButtonStyle,
        child: child.fold((l) => l, (r) => Text(
          r ?? "",
        )),
      ),
    );
    final filledLeadingIcon = CustomToolTip(
      message: tooltip,
      child: FilledButton.icon(
        onPressed: onPressed,
        focusNode: focusNode,
        style: filledButtonStyle,
        label: labelWidget,
        icon: iconWidget,
      ),
    );
    final filledTrailingIcon = CustomToolTip(
      message: tooltip,
      child: FilledButton.icon(
        onPressed: onPressed,
        focusNode: focusNode,
        style: filledButtonStyle,
        label: labelWidget,
        icon: iconWidget,
      ),
    );
    final filledIcon = Material(
      color: Colors.transparent,
      child: Ink(
        decoration: ShapeDecoration(
          color: onPressed == null
              ? AppColors.grey.shade300
              : filledButtonBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
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
            padding: EdgeInsets.all(verticalFilledOutlinedVerticalPadding),
            icon: iconWidget,
          ),
        ),
      ),
    );
    final outlinedLeadingIcon = CustomToolTip(
      message: tooltip,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        focusNode: focusNode,
        style: outlinedButtonStyle,
        label: Text(
          label ?? "",
        ),
        icon: iconWidget,
      ),
    );
    final outlinedTrailingIcon = CustomToolTip(
      message: tooltip,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        focusNode: focusNode,
        style: outlinedButtonStyle,
        label: Text(
          label ?? "",
        ),
        icon: iconWidget,
      ),
    );
    Widget outlinedLabel(Either<Widget,String> child) =>  CustomToolTip(
      message: tooltip,
      child: OutlinedButton(
        onPressed: onPressed,
        focusNode: focusNode,
        style: outlinedButtonStyle,
        child: child.fold((l) => l, (r) => Text(r??"")),
      ),
    );
    final outlinedIcon = SizedBox(
      width: buttonHeight,
      height: buttonHeight,
      child: CustomToolTip(
        message: tooltip,
        child: TextButton(
          onPressed: onPressed,
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
        return AppColors.grey.shade300;
      }
      if (type.isPrimary) {
        return states.contains(MaterialState.focused)
            ? AppColors.primary.shade700
            : states.contains(MaterialState.hovered)
            ? AppColors.primary.shade600
            : AppColors.primary.shade500;
      }
      if (type.isGrey) {
        return states.contains(MaterialState.focused)
            ? AppColors.grey.shade700
            : states.contains(MaterialState.hovered)
            ? AppColors.grey.shade400
            : AppColors.grey.shade500;
      }
      return AppColors.error.shade400;
    }

    final textButtonStyle = ButtonStyle(
      textStyle: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        return AppTextStyle.getTextStyle(AppTextStyleParams(
            appFontSize: isSmall
                ? AppFontSize.paragraphSmall
                : AppFontSize.paragraphMedium,
            color: textForegroundColor(states),
            appFontWeight: AppFontWeight.semiBold));
      }),
      foregroundColor: MaterialStateProperty.resolveWith(
              (Set<MaterialState> states) => textForegroundColor(states)),
      padding: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        return isSmall
            ? EdgeInsets.symmetric(
            vertical: 8.0, horizontal: (labelWithIcon ? 12 : 16))
            : EdgeInsets.zero;
      }),
    );
    Widget textLabel (Either<Widget,String> child) =>  CustomToolTip(
        message: tooltip,
        child: TextButton(
          onPressed: onPressed,
          style: textButtonStyle,
          child: child.fold((l) => l, (r) => Text(r ?? "")),
        ));
    final textTrailingIcon = CustomToolTip(
        message: tooltip,
        child: TextButton.icon(
          style: textButtonStyle,
          onPressed: onPressed,
          icon: iconWidget,
          label: labelWidget,
        ));
    final textLeadingIcon = CustomToolTip(
        message: tooltip,
        child: TextButton.icon(
          style: textButtonStyle,
          onPressed: onPressed,
          icon: iconWidget,
          label: labelWidget,
        ));
    final textIcon = SizedBox(
      width: buttonHeight,
      height: buttonHeight,
      child: CustomToolTip(
        message: tooltip,
        child: TextButton(
          onPressed: onPressed,
          focusNode: focusNode,
          style: textButtonStyle.copyWith(
            alignment: Alignment.center,
            padding: const MaterialStatePropertyAll(EdgeInsets.zero),
          ),
          child: iconWidget,
        ),
      ),
    );
    final iconMinPadding = SizedBox(
      width: isSmall ? 15 : 18,
      height: isSmall ? 15 : 18,
      child: CustomToolTip(
        message: tooltip,
        child: IconButton(
          padding: EdgeInsets.zero,
          onPressed: onPressed,
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
        return filledLabel(child == null ? Right(label??""): Left(child??Container()));
      case (CustomButtonType.primaryTrailingIcon):
        return filledTrailingIcon;
      case (CustomButtonType.primaryLeadingIcon):
        return filledLeadingIcon;
      case (CustomButtonType.primaryIcon):
        return filledIcon;
      case (CustomButtonType.secondaryLabel):
        return outlinedLabel(child == null ? Right(label??""): Left(child??Container()));
      case (CustomButtonType.secondaryTrailingIcon):
        return outlinedTrailingIcon;
      case (CustomButtonType.secondaryLeadingIcon):
        return outlinedLeadingIcon;
      case (CustomButtonType.secondaryIcon):
        return outlinedIcon;
      case (CustomButtonType.greyFilledLabel):
        return filledLabel(child == null ? Right(label??""): Left(child??Container()));
      case (CustomButtonType.greyFilledTrailingIcon):
        return filledTrailingIcon;
      case (CustomButtonType.greyFilledLeadingIcon):
        return filledLeadingIcon;
      case (CustomButtonType.greyFilledIcon):
        return filledIcon;
      case (CustomButtonType.destructiveFilledLabel):
        return filledLabel(child == null ? Right(label??""): Left(child??Container()));
      case (CustomButtonType.destructiveFilledTrailingIcon):
        return filledTrailingIcon;
      case (CustomButtonType.destructiveFilledLeadingIcon):
        return filledLeadingIcon;
      case (CustomButtonType.destructiveFilledIcon):
        return filledIcon;

      case (CustomButtonType.greyOutlinedLabel):
        return outlinedLabel(child == null ? Right(label??""): Left(child??Container()));
      case (CustomButtonType.greyOutlinedTrailingIcon):
        return outlinedTrailingIcon;
      case (CustomButtonType.greyOutlinedLeadingIcon):
        return outlinedLeadingIcon;
      case (CustomButtonType.greyOutlinedIcon):
        return outlinedIcon;
      case (CustomButtonType.destructiveOutlinedLabel):
        return outlinedLabel(child == null ? Right(label??""): Left(child??Container()));
      case (CustomButtonType.destructiveOutlinedTrailingIcon):
        return outlinedTrailingIcon;
      case (CustomButtonType.destructiveOutlinedLeadingIcon):
        return outlinedLeadingIcon;
      case (CustomButtonType.destructiveOutlinedIcon):
        return outlinedIcon;

      case (CustomButtonType.primaryTextLabel):
        return textLabel(child == null ? Right(label??""): Left(child??Container()));
      case (CustomButtonType.primaryTextTrailingIcon):
        return textTrailingIcon;
      case (CustomButtonType.primaryTextLeadingIcon):
        return textLeadingIcon;
      case (CustomButtonType.primaryTextIcon):
        return textIcon;
      case (CustomButtonType.primaryIconMinPadding):
        return iconMinPadding;

      case (CustomButtonType.greyTextLabel):
        return textLabel(child == null ? Right(label??""): Left(child??Container()));
      case (CustomButtonType.greyTextTrailingIcon):
        return textTrailingIcon;
      case (CustomButtonType.greyTextLeadingIcon):
        return textLeadingIcon;
      case (CustomButtonType.greyTextIcon):
        return textIcon;
      case (CustomButtonType.greyIconMinPadding):
        return iconMinPadding;

      case (CustomButtonType.destructiveTextLabel):
        return textLabel(child == null ? Right(label??""): Left(child??Container()));
      case (CustomButtonType.destructiveTextTrailingIcon):
        return textTrailingIcon;
      case (CustomButtonType.destructiveTextLeadingIcon):
        return textLeadingIcon;
      case (CustomButtonType.destructiveTextIcon):
        return textIcon;
      case (CustomButtonType.destructiveIconMinPadding):
        return iconMinPadding;
      default:
        return filledLabel(child == null ? Right(label??""): Left(child??Container()));
    }
  }
}