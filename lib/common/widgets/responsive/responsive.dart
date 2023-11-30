import 'package:flutter/material.dart';

enum ResponsiveDevice {
  mobile(400),
  tablet(800),
  startShowingSmallDesign(1100),
  laptop(1440);

  final int value;

  const ResponsiveDevice(this.value);
}

class ResponsiveTParams<T> {
  final T mobile;
  final T? tablet;
  final T? startShowingSmallDesign;
  final T? laptop;

  ResponsiveTParams(
      {required this.mobile,
      this.tablet,
      this.startShowingSmallDesign,
      this.laptop});
}

class Responsive {
  static bool showSmallDesign(BuildContext context) =>
      MediaQuery.sizeOf(context).width <=
      ResponsiveDevice.startShowingSmallDesign.value;

  static T responsiveT<T>({
    required ResponsiveTParams params,
    required BuildContext context,
  }) {
    final device = getDevice(context);
    var tablet = params.tablet ?? params.mobile;
    switch (device) {
      case (ResponsiveDevice.mobile):
        return params.mobile;
      case (ResponsiveDevice.tablet):
        return tablet;
      case (ResponsiveDevice.startShowingSmallDesign):
        return params.startShowingSmallDesign ?? tablet;
      case (ResponsiveDevice.laptop):
        return params.laptop ?? params.startShowingSmallDesign ?? tablet;
    }
  }

  static ResponsiveDevice getDevice(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= ResponsiveDevice.laptop.value) {
      return ResponsiveDevice.laptop;
    }
    if (width >= ResponsiveDevice.startShowingSmallDesign.value) {
      return ResponsiveDevice.startShowingSmallDesign;
    }
    if (width >= ResponsiveDevice.tablet.value) {
      return ResponsiveDevice.tablet;
    }
    return ResponsiveDevice.mobile;
  }
}
