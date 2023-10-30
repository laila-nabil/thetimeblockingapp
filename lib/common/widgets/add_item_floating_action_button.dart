import 'package:flutter/material.dart';

class AddItemFloatingActionButton extends FloatingActionButton {
  const AddItemFloatingActionButton({
    super.key,
    super.tooltip,
    super.foregroundColor,
    super.backgroundColor,
    super.focusColor,
    super.hoverColor,
    super.splashColor,
    super.heroTag,
    super.elevation,
    super.focusElevation,
    super.hoverElevation,
    super.highlightElevation,
    super.disabledElevation,
    required super.onPressed,
    super.mouseCursor,
    super.mini = false,
    super.shape,
    super.clipBehavior = Clip.none,
    super.focusNode,
    super.autofocus = false,
    super.materialTapTargetSize,
    super.isExtended = false,
    super.enableFeedback,
  });

  @override
  Widget? get child => const Icon(Icons.add);
}
