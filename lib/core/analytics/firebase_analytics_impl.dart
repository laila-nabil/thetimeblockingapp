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
          .setAnalyticsCollectionEnabled(Globals.analyticsEnabled);
      _firebaseAnalytics = FirebaseAnalytics.instance;
    } catch (e) {
      printDebug(e);
    }
  }

  @override
  Future<void> logAppOpen() async {
    try {
      await _firebaseAnalytics.logAppOpen();
    } catch (e) {
      printDebug(e);
    }
  }

  @override
  Future<void> logEvent(String eventName) async {
    try {
      await _firebaseAnalytics.logEvent(name: eventName);
    } catch (e) {
      printDebug(e);
    }
  }

  @override
  Future<void> setCurrentScreen(String screenName) async {
    try {
      await _firebaseAnalytics.setCurrentScreen(screenName: screenName);
    } catch (e) {
      printDebug(e);
    }
  }
}
