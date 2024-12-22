import 'package:flutter/foundation.dart';
import 'package:universal_platform/universal_platform.dart';

/// Check if the current platform is a mobile device.
///
/// Using the [UniversalPlatform] package,to cater for web and other platforms.
bool get isMobileDevice {
  return UniversalPlatform.isAndroid ||
      UniversalPlatform.isIOS ||
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;
}
