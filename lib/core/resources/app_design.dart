import 'package:flutter/widgets.dart';

enum BorderRadius {
  r0(0),
  rXxs(2),
  rXs(4),
  rMd(8),
  rLg(10),
  rXlg(12),
  rX2lg(16),
  rX3lg(20),
  rX4lg(24),
  rMax(999);

  const BorderRadius(this.value);

  final int value;
}

enum Shadow {
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

  const Shadow(this.shadows);

  final List<BoxShadow> shadows;
}

class AppDesign {}
