import 'package:flutter/material.dart';

enum AppFontWeight {
  regular(FontWeight.normal),
  medium(FontWeight.w500),
  semiBold(FontWeight.w600),
  bold(FontWeight.w700);

  const AppFontWeight(this.value);

  final FontWeight value;
}

enum AppFontSize {
  displayLarge(size: 52, lineHeight: 56),
  displaySmall(size: 44, lineHeight: 48),
  heading1(size: 40, lineHeight: 48),
  heading2(size: 36, lineHeight: 44),
  heading3(size: 32, lineHeight: 40),
  heading4(size: 28, lineHeight: 36),
  heading5(size: 24, lineHeight: 32),
  heading6(size: 20, lineHeight: 28),
  paragraphLarge(size: 18, lineHeight: 28),
  paragraphMedium(size: 16, lineHeight: 24),
  paragraphSmall(size: 14, lineHeight: 20),
  paragraphXSmall(size: 12, lineHeight: 20),
  paragraphX2Small(size: 10, lineHeight: 20);

  const AppFontSize({required this.size, required this.lineHeight});

  final double size;
  final double lineHeight;
}

class AppTextStyle {
  static TextStyle getTextStyle(AppTextStyleParams appTextStyleParams) {
    return TextStyle(
        fontFamily: 'Inter',
        fontSize: appTextStyleParams.appFontSize.size,
        inherit: true,
        fontWeight: appTextStyleParams.appFontWeight.value,
        color: appTextStyleParams.color,
        height: appTextStyleParams.appFontSize.lineHeight);
  }
}

class AppTextStyleParams {
  final Color color;
  final AppFontWeight appFontWeight;
  final AppFontSize appFontSize;

  AppTextStyleParams(this.appFontSize,
      {required this.color, required this.appFontWeight});
}
