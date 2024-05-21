import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thetimeblockingapp/firebase_options.dart';

import '../globals.dart';
import 'analytics.dart';

class FirebaseAnalyticsImpl implements Analytics {
  late FirebaseAnalytics _firebaseAnalytics;

  @override
  Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await FirebaseAnalytics.instance
          .setAnalyticsCollectionEnabled(Globals.isAnalyticsEnabled);
      _firebaseAnalytics = FirebaseAnalytics.instance;
      printDebug("FirebaseAnalyticsImpl initialize");
    } catch (e) {
      printDebug(e);
    }
  }

  @override
  Future<void> logAppOpen() async {
    try {
      await _firebaseAnalytics.logAppOpen();
      printDebug("FirebaseAnalyticsImpl logAppOpen");
    } catch (e) {
      printDebug(e);
    }
  }

  @override
  Future<void> logEvent(String eventName,
      {Map<String, Object?>? parameters}) async {
    try {
      await _firebaseAnalytics.logEvent(name: eventName,parameters: parameters);
      printDebug("FirebaseAnalyticsImpl logEvent $eventName ${parameters.toString()}");
    } catch (e) {
      printDebug(e);
    }
  }

  @override
  Future<void> setCurrentScreen(String screenName) async {
    try {
      await _firebaseAnalytics.setCurrentScreen(
          screenName: Globals.isDemo ? "demo/$screenName" : screenName);
      printDebug("FirebaseAnalyticsImpl setCurrentScreen $screenName");
    } catch (e) {
      printDebug(e);
    }
  }

  @override
  Future<void> setUserId(String userId) async {
    try {
      await _firebaseAnalytics.setUserId(id: userId);
      printDebug("FirebaseAnalyticsImpl setUserId $userId");
    } catch (e) {
      printDebug(e);
    }
  }
}
