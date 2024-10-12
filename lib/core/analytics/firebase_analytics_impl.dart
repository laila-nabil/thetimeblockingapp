import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thetimeblockingapp/firebase_options.dart';

import '../../common/entities/user.dart';
import '../environment.dart';
import '../injection_container.dart';
import 'analytics.dart';

class FirebaseAnalyticsImpl implements Analytics {
  late FirebaseAnalytics _instance;

  @override
  Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(
          serviceLocator<AppConfig>().env.isAnalyticsEnabled);
      _instance = FirebaseAnalytics.instance;
      printDebug("FirebaseAnalyticsImpl initialize");
    } catch (e) {
      printDebug(e);
    }
  }

  @override
  Future<void> logAppOpen() async {
    try {
      await _instance.logAppOpen();
      printDebug("FirebaseAnalyticsImpl logAppOpen");
    } catch (e) {
      printDebug(e);
    }
  }

  @override
  Future<void> logEvent(String eventName,
      {Map<String, Object>? parameters}) async {
    try {
      await _instance.logEvent(
          name: eventName, parameters: parameters);
      printDebug(
          "FirebaseAnalyticsImpl logEvent $eventName ${parameters.toString()}");
    } catch (e) {
      printDebug(e);
    }
  }

  @override
  Future<void> setCurrentScreen(String screenName) async {
    try {
      await _instance.setCurrentScreen(
          screenName: serviceLocator<AppConfig>().isDemo? "demo/$screenName" : screenName);
      printDebug("FirebaseAnalyticsImpl setCurrentScreen $screenName");
    } catch (e) {
      printDebug(e);
    }
  }

  @override
  Future<void> setUserId(User user) async {
    try {
      await _instance.setUserId(id: user.id);
      printDebug("FirebaseAnalyticsImpl setUserId ${user.id}");
    } catch (e) {
      printDebug(e);
    }
  }

  @override
  NavigatorObserver navigatorObserver = FirebaseAnalyticsObserver();

  @override
  Future<void> resetUser() async {
    try {
      await _instance.setUserId();
      printDebug("FirebaseAnalyticsImpl reset UserId");
    } catch (e) {
      printDebug(e);
    }
  }
}

class FirebaseAnalyticsObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    serviceLocator<Analytics>().setCurrentScreen(
        "${route.settings.name}/${route.settings.arguments}");
  }
}