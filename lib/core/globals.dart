import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_space.dart';

import '../common/entities/clickup_user.dart';
import '../common/entities/clickup_workspace.dart';
import '../features/auth/domain/entities/clickup_access_token.dart';
import 'backend.dart';
import 'environment.dart';

String _appName = "Time blocking app";


///[isSpaceAppWide] space is selected from appbar/drawer only and is global to app or not
bool _isSpaceAppWide = true;

Duration _defaultTaskDuration = const Duration(hours: 1);


class Globals {

  static Backend backend = Backend.clickup;

  static String get appName => _appName;

  static const Env defaultEnv  = Env.debugLocally;

  static Env env = defaultEnv;

  static get isAnalyticsEnabled => env.isAnalyticsEnabled;

  static bool get isSpaceAppWide => _isSpaceAppWide;

  static Duration get defaultTaskDuration => _defaultTaskDuration;

  static String redirectAfterAuthRouteName = "";

  static const ThemeMode defaultThemeMode = ThemeMode.light;

  static const bool isDemo = false;

  static String demoUrl =
      "https://demoo-timeblocking.web.app";

  static ClickupGlobals? clickupGlobals ;

}
