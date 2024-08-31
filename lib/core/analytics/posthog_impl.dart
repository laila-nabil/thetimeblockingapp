import 'package:flutter/widgets.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';

import '../environment.dart';
import 'analytics.dart';
import 'package:posthog_flutter/posthog_flutter.dart';


class PostHogImpl implements Analytics {
  late Posthog _instance;

  @override
  Future<void> initialize() async {
    try {
      _instance = Posthog();
      if(serviceLocator<Env>(instanceName: ServiceLocatorName.env.name).isAnalyticsEnabled){
        await _instance.enable();
        await _instance.debug(serviceLocator<Env>(instanceName: ServiceLocatorName.env.name).isDebug);
      }
      printDebug("PostHogImpl initialize");
    } catch (e) {
      printDebug(e);
    }
  }

  @override
  Future<void> logAppOpen() async {
    try {
      await _instance.capture(eventName: 'logAppOpen');
      printDebug("PostHogImpl logAppOpen");
    } catch (e) {
      printDebug(e);
    }
  }

  @override
  Future<void> logEvent(String eventName,
      {Map<String, Object>? parameters}) async {
    try {
      await _instance.capture(eventName: eventName,properties: parameters);
      printDebug("PostHogImpl logEvent $eventName ${parameters.toString()}");
    } catch (e) {
      printDebug(e);
    }
  }

  @override
  Future<void> setCurrentScreen(String screenName) async {
    try {
      await _instance.screen(
          screenName: serviceLocator<bool>(instanceName: ServiceLocatorName.isDemo.name) ? "demo/$screenName" : screenName);
      printDebug("PostHogImpl setCurrentScreen $screenName");
    } catch (e) {
      printDebug(e);
    }
  }

  @override
  Future<void> setUserId(String userId) async {
    try {
      await _instance.identify(userId: userId);
      printDebug("PostHogImpl setUserId $userId");
    } catch (e) {
      printDebug(e);
    }
  }

  @override
  NavigatorObserver navigatorObserver = PosthogObserver();

  @override
  Future<void> resetUser() async{
    try {
      await _instance.reset();
      printDebug("PostHogImpl reset UserId");
    } catch (e) {
      printDebug(e);
    }
  }
}
