import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalender/kalender.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';

class CalendarZoomDetector extends StatefulWidget {
  final Widget child;
  final CalendarController<Task> controller;
  const CalendarZoomDetector({super.key, required this.child, required this.controller});

  @override
  State<CalendarZoomDetector> createState() => _CalendarZoomDetectorState();
}

class _CalendarZoomDetectorState extends State<CalendarZoomDetector> {
  CalendarController<Task> get controller => widget.controller;
  MultiDayViewController<Task>? get viewController {
    final viewController = controller.viewController;
    if (viewController is MultiDayViewController<Task>) {
      return viewController;
    } else {
      return null;
    }
  }

  ScrollController? get scrollController => viewController?.scrollController;
  ValueNotifier<double>? get heightPerMinute => viewController?.heightPerMinute;
  ValueNotifier<bool> isCtrlPressed = ValueNotifier(false);
  double _pointerYOffset = 0;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (task) {
        if (!HardwareKeyboard.instance.isControlPressed) return;
        if (task is! PointerScaleEvent) return;
        final height = heightPerMinute?.value;
        if (height == null) return;

        var newHeight = height * pow(2, log(task.scale) / 4);
        newHeight = newHeight.clamp(0.5, 2);

        final zoomRatio = newHeight / height;
        final scrollPosition = scrollController?.position.pixels;
        if (scrollPosition == null) return;

        final pointerPosition = scrollPosition + _pointerYOffset;
        final newPosition = (pointerPosition * zoomRatio) - _pointerYOffset;
        scrollController?.jumpTo(newPosition);
        heightPerMinute?.value = newHeight;
      },
      onPointerHover: (task) => _pointerYOffset = task.localPosition.dy,
      behavior: HitTestBehavior.translucent,
      child: ValueListenableBuilder(
        valueListenable: isCtrlPressed,
        builder: (context, value, _) => ScrollConfiguration(
          behavior: value ? const ScrollBehaviorNever() : const MaterialScrollBehavior(),
          child: widget.child,
        ),
      ),
    );
  }
}

class ScrollBehaviorNever extends ScrollBehavior {
  const ScrollBehaviorNever();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) => const NeverScrollableScrollPhysics();
}

class ZoomIntent extends Intent {
  const ZoomIntent();
}
