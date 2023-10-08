import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';

import 'custom_loading.dart';

//since responsiveScaffoldLoading overlayLoading does not cover a pop up

class CustomAlertDialog extends AlertDialog {
  const CustomAlertDialog({
    super.key,
    required this.loading,
    super.icon,
    super.iconColor,
    super.iconPadding,
    super.title,
    super.titlePadding,
    super.titleTextStyle,
    super.content,
    super.contentPadding,
    super.contentTextStyle,
    super.actions,
    super.actionsPadding,
    super.actionsAlignment,
    super.actionsOverflowAlignment,
    super.actionsOverflowDirection,
    super.actionsOverflowButtonSpacing,
    super.buttonPadding,
    super.backgroundColor,
    super.elevation,
    super.shadowColor,
    super.surfaceTintColor,
    super.semanticLabel,
    super.insetPadding,
    super.clipBehavior,
    super.shape,
    super.alignment,
    super.scrollable,
  });
  ///[loading] in case loading is from Bloc's state,
  ///[CustomAlertDialog] must be wrapped with BlocBuilder and state.isLoading is passed
  final bool loading;

  @override
  Widget? get content {
    if (super.content == null) {
      return null;
    } else {
      if (loading) {
        printDebug("alert loading");
        return const CustomLoading();
      } else {
        printDebug("alert not loading");
        return super.content!;
      }
    }
  }
}
