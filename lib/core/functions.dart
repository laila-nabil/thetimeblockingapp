import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:thetimeblockingapp/core/print_debug.dart';

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
    // Web platform
    if (Uri.parse(Uri.base.toString()).host.isEmpty) {
      return AppPlatform.desktopWeb; // Running on desktop browser
    } else {
      return AppPlatform.mobileWeb; // Running on a mobile browser
    }
  }
  // Native mobile or desktop app
  try {
    if (Platform.isAndroid) {
      return AppPlatform.androidApp;
    } else if (Platform.isIOS) {
      return AppPlatform.iosApp;
    } else if (Platform.isMacOS) {
      return AppPlatform.macOSDesktop;
    } else if (Platform.isWindows) {
      return AppPlatform.windowsDesktop;
    } else if (Platform.isLinux) {
      return AppPlatform.linuxDesktop;
    }
  } catch (e) {
    printDebug(e, printLevel: PrintLevel.error);
  }
  return AppPlatform.desktopWeb;
}
