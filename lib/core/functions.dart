import 'package:flutter/foundation.dart';
import 'package:universal_platform/universal_platform.dart';

import 'print_debug.dart';

/// Check if the current platform is a mobile device.
///
/// Using the [UniversalPlatform] package,to cater for web and other platforms.
bool isMobileDevice() {
  printDebug("UniversalPlatform.isAndroid ${UniversalPlatform.isAndroid}");
  printDebug("UniversalPlatform.isIOS ${UniversalPlatform.isIOS}");
  printDebug("defaultTargetPlatform ${defaultTargetPlatform}");
  var result = UniversalPlatform.isAndroid ||
      UniversalPlatform.isIOS ||
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;
  printDebug("isMobileDevice $isMobileDevice");
  return result;
}