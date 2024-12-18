import 'package:flutter/widgets.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';

import '../../common/entities/user.dart';
import '../environment.dart';
import 'analytics.dart';
import 'package:posthog_flutter/posthog_flutter.dart';


class PostHogImpl implements Analytics {
  Posthog? _instance;

  @override
  Future<void> initialize() async {
    try {
      if(serviceLocator<AppConfig>().env.isAnalyticsEnabled){
        _instance = Posthog();
        printDebug("PostHogImpl initialize");
      }
    } catch (e) {
      printDebug("PostHogImpl error $e",printLevel: PrintLevel.error);
    }
  }

  @override
  Future<void> logAppOpen() async {
    try {
      await _instance?.capture(eventName: 'logAppOpen');
      printDebug("PostHogImpl logAppOpen");
    } catch (e) {
      printDebug("PostHogImpl error $e",printLevel: PrintLevel.error);
    }
  }

  @override
  Future<void> logEvent(String eventName,
      {Map<String, Object>? parameters}) async {
    try {
      await _instance?.capture(eventName: eventName,properties: parameters);
      printDebug("PostHogImpl logEvent $eventName ${parameters.toString()}");
    } catch (e) {
      printDebug("PostHogImpl error $e",printLevel: PrintLevel.error);
    }
  }

  @override
  Future<void> setCurrentScreen(String screenName) async {
    try {
      await _instance?.screen(
          screenName: serviceLocator<AppConfig>().isDemo? "demo/$screenName" : screenName);
      printDebug("PostHogImpl setCurrentScreen $screenName");
    } catch (e) {
      printDebug("PostHogImpl error $e",printLevel: PrintLevel.error);
    }
  }

  @override
  Future<void> setUserId(User user) async {
    try {
      await _instance?.identify(userId: user.id??"");
      printDebug("PostHogImpl setUserId ${user.id}");
    } catch (e) {
      printDebug("PostHogImpl error $e",printLevel: PrintLevel.error);
    }
  }

  @override
  NavigatorObserver navigatorObserver = PosthogObserver();

  @override
  Future<void> resetUser() async{
    try {
      await _instance?.reset();
      printDebug("PostHogImpl reset UserId");
    } catch (e) {
      printDebug("PostHogImpl error $e",printLevel: PrintLevel.error);
    }
  }

  @override
  Future<String> featureFlag(String featureKey) async {
    Object? result;
    try {
      result = await _instance?.getFeatureFlag(featureKey);
      printDebug("PostHogImpl featureFlag $result");
      return result.toString();
    } catch (e) {
    printDebug("PostHogImpl error $e",printLevel: PrintLevel.error);
    }
    return "";
  }
}
