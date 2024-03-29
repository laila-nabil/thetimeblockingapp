import 'package:flutter/widgets.dart';

enum AppBorderRadius {
  none(0),
  x2Small(2),
  xSmall(4),
  medium(8),
  large(10),
  xLarge(12),
  x2Large(16),
  x3Large(20),
  x4Large(24),
  max(999);

  const AppBorderRadius(this.value);

  final double value;
}

enum AppShadow {
  xSmall([
    BoxShadow(
      color: Color(0x05000000),
      blurRadius: 3,
      offset: Offset(0, 5),
      spreadRadius: -2,
    ),
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 2,
      offset: Offset(0, 3),
      spreadRadius: -2,
    )
  ]),
  small([
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 4,
      offset: Offset(0, 2),
      spreadRadius: -2,
    ),
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 8,
      offset: Offset(0, 4),
      spreadRadius: -2,
    )
  ]),
  medium([
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 6,
      offset: Offset(0, 4),
      spreadRadius: -2,
    ),
    BoxShadow(
      color: Color(0x19000000),
      blurRadius: 16,
      offset: Offset(0, 12),
      spreadRadius: -4,
    )
  ]),
  large([
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 8,
      offset: Offset(0, 8),
      spreadRadius: -4,
    ),
    BoxShadow(
      color: Color(0x19000000),
      blurRadius: 24,
      offset: Offset(0, 20),
      spreadRadius: -4,
    )
  ]),
  xLarge([
    BoxShadow(
      color: Color(0x19101828),
      blurRadius: 10,
      offset: Offset(0, 8),
      spreadRadius: -6,
    ),
    BoxShadow(
      color: Color(0x19101828),
      blurRadius: 25,
      offset: Offset(0, 20),
      spreadRadius: -5,
    )
  ]),
  x2Large([
    BoxShadow(
      color: Color(0x3F0F1728),
      blurRadius: 50,
      offset: Offset(0, 25),
      spreadRadius: -12,
    )
  ]);

  const AppShadow(this.shadows);

  final List<BoxShadow> shadows;
}

enum AppBlur {

  none(0),
  small(2),
  medium(4),
  large(6),
  xLarge(10);
  const AppBlur(this.value);

  final int value;
}

enum AppSpacing {

  x2Small4(4),
  xSmall8(8),
  small12(12),
  medium16(16),
  big20(20),
  xBig24(24),
  x2Big28(28),
  x3Big32(32),
  large40(40),
  xLarge48(48),
  x2Large64(64),
  x3Large80(80),
  huge96(96),
  xHuge128(128),
  x2Huge160(160),
  x3Huge192(192);
  const AppSpacing(this.value);

  final double value;
}

enum AppScreen {

  small(width: 320,margin: 16,gutter: 12),
  medium(width: 600,margin: 32,gutter: 20),
  large(width: 1136,margin: 112,gutter: 32);
  const AppScreen({required this.width,required this.margin,required this.gutter});
  final int width;
  final int margin;
  final int gutter;
}