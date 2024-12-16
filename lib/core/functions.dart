import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:thetimeblockingapp/core/print_debug.dart';

enum AppPlatform {
  web,
  androidApp,
  iosApp,
  macOSDesktop,
  windowsDesktop,
  linuxDesktop;

  ///TODO
  bool isMobile(bool showSmallDesign) =>
      this == AppPlatform.androidApp ||
      this == AppPlatform.iosApp ||
      this == AppPlatform.macOSDesktop;
}

AppPlatform getAppPlatformType() {
  if (kIsWeb) {
    printDebug("getAppPlatformType web");
    return AppPlatform.web;
  }
  // Native mobile or desktop app
  try {
    if (Platform.isAndroid) {
      printDebug("getAppPlatformType androidApp");
      return AppPlatform.androidApp;
    } else if (Platform.isIOS) {
      printDebug("getAppPlatformType iosApp");
      return AppPlatform.iosApp;
    } else if (Platform.isMacOS) {
      printDebug("getAppPlatformType macOSDesktop");
      return AppPlatform.macOSDesktop;
    } else if (Platform.isWindows) {
      printDebug("getAppPlatformType windowsDesktop");
      return AppPlatform.windowsDesktop;
    } else if (Platform.isLinux) {
      printDebug("getAppPlatformType linuxDesktop");
      return AppPlatform.linuxDesktop;
    }
  } catch (e) {
    printDebug(e, printLevel: PrintLevel.error);
  }
  printDebug("getAppPlatformType web");
  return AppPlatform.web;
}
