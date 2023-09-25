import 'package:flutter/material.dart';

class AppTextStyleCore {
  TextStyle titleTextStyle(Color textColor) {
    return TextStyle(
      fontSize: (24),
      inherit: true,
      fontWeight: FontWeight.w700,
      color: textColor,
    );
  }

  TextStyle subtitleTextStyle(Color textColor) {
    return TextStyle(
      fontSize: (17),
      inherit: true,
      fontWeight: FontWeight.w400,
      color: textColor,
    );
  }

  TextStyle subtitleTextStyleBold(Color textColor) {
    return TextStyle(
      fontSize: (17),
      inherit: true,
      fontWeight: FontWeight.w700,
      color: textColor,
    );
  }

  TextStyle bodyTextStyleBold(Color textColor) {
    return TextStyle(
      fontSize: (19),
      inherit: true,
      fontWeight: FontWeight.w600,
      color: textColor,
    );
  }

  TextStyle bodyTextStyle(Color textColor, {String? langCode}) {
    return TextStyle(
      fontSize: (19),
      inherit: true,
      height: 1.2,
      fontWeight: FontWeight.w400,
      color: textColor,
    );
  }

  TextStyle buttonNavigationTextStyle(Color textColor) {
    return TextStyle(
        fontSize: (10),
        inherit: true,
        fontWeight: FontWeight.w300,
        color: textColor);
  }

  TextStyle bodySmallTextStyle(Color textColor) {
    return TextStyle(
      fontSize: (12),
      inherit: true,
      fontWeight: FontWeight.w300,
      color: textColor,
    );
  }

  TextStyle popupTitleTextStyle(Color textColor) {
    return TextStyle(
      fontSize: (22),
      inherit: true,
      fontWeight: FontWeight.w600,
      color: textColor,
    );
  }

  TextStyle popupTextFieldStyle(Color textColor) {
    return TextStyle(
      fontSize: (14),
      inherit: true,
      fontWeight: FontWeight.w400,
      color: textColor,
    );
  }

  TextStyle popupTextStyle(Color textColor) {
    return TextStyle(
      fontSize: (24),
      inherit: true,
      fontWeight: FontWeight.w400,
      color: textColor,
    );
  }
}
