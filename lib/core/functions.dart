import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'dart:html' as html;

enum AppPlatform {
  desktopWeb,
  mobileWeb,
  androidApp,
  iosApp,
  macOSDesktop,
  windowsDesktop,
  linuxDesktop;

  bool get isMobile =>
      this == AppPlatform.mobileWeb ||
      this == AppPlatform.androidApp ||
      this == AppPlatform.iosApp ||
      this == AppPlatform.macOSDesktop;
}

AppPlatform getAppPlatformType() {
  if (kIsWeb) {
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    printDebug("userAgent $userAgent");
    // Web platform
    if (userAgent.contains("android") || userAgent.contains("iphone") || userAgent.contains("ipad")) {
      printDebug("getAppPlatformType mobileWeb");
      return AppPlatform.mobileWeb; // Running on desktop browser
    } else {
      printDebug("getAppPlatformType desktopWeb");
      return AppPlatform.desktopWeb; // Running on a mobile browser
    }
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
  printDebug("getAppPlatformType desktopWeb");
  return AppPlatform.desktopWeb;
}
