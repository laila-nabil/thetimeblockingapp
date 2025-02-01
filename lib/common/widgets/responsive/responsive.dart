import 'package:flutter/material.dart';

import '../../../core/resources/app_design.dart';

class ResponsiveTParams<T> {
  final T small;
  final T? medium;
  final T? large;

  ResponsiveTParams(
      {required this.small,
      this.medium,
      this.large,});
}

extension AppResponsive on BuildContext {
  bool get showSmallDesign =>
      MediaQuery.sizeOf(this).width <=
          AppScreen.large.width;

  T responsiveT<T>({
    required ResponsiveTParams params,
  }) {
    final device = getDevice;
    var tablet = params.medium ?? params.small;
    switch (device) {
      case (AppScreen.small):
        return params.small;
      case (AppScreen.medium):
        return tablet;
      case (AppScreen.large):
        return params.large ?? tablet;
    }
  }

  Widget responsiveListWidgets({
    required List<Widget> children,
    double spacingHorizontal = 0,
  }) {
    final device = getDevice;
    switch (device) {
      case (AppScreen.small):
        return Column(
          children: children,
        );
      case (AppScreen.medium):
        return Column(
          children: children,
        );
      case (AppScreen.large):
        return Row(
          children: children
                  .map<Widget>((child) => Expanded(
                    child: Padding(
                      padding:
                            EdgeInsetsDirectional.only(end: spacingHorizontal),
                      child: child,
                    ),
                  ))
                  .toList()
              ,
        );
    }
  }

  AppScreen get getDevice {
    final width = MediaQuery.sizeOf(this).width;
    if (width >= AppScreen.large.width) {
      return AppScreen.large;
    }
    if (width >= AppScreen.medium.width) {
      return AppScreen.medium;
    }
    return AppScreen.small;
  }

  int get getMargin {
    return getDevice.margin;
  }

  int get getGutter {
    return getDevice.gutter;
  }
}