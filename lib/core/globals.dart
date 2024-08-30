import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/common/entities/priority.dart';
import 'package:thetimeblockingapp/common/entities/status.dart';
import 'package:thetimeblockingapp/common/enums/backend_mode.dart';
import 'package:thetimeblockingapp/common/entities/space.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';

import '../common/entities/user.dart';
import '../common/entities/workspace.dart';
import '../common/entities/access_token.dart';
import 'environment.dart';

String _appName = "Time blocking app";


AccessToken _accessToken =
    const AccessToken(accessToken: "", tokenType: "");
User? _user;

Workspace? _selectedWorkspace;

///[isWorkspaceAndSpaceAppWide] Workspace and space is selected from appbar/drawer only and is global to app or not
bool _isWorkspaceAndSpaceAppWide = true;

Duration _defaultTaskDuration = const Duration(hours: 1);

List<Workspace>? _workspaces;

///TODO B move to global bloc

class Globals {
  static BackendMode backendMode = BackendMode.supabase;

  static String get appName => _appName;

  static SupabaseGlobals supabaseGlobals = SupabaseGlobals();

  static const Env defaultEnv  = Env.debugLocally;

  static Env env = defaultEnv;

  static get isAnalyticsEnabled => env.isAnalyticsEnabled;

  static AccessToken get accessToken =>
      _accessToken;

  static User? get user => _user;

  static Workspace? get selectedWorkspace =>
      _selectedWorkspace ?? workspaces?.firstOrNull;

  static Space? get selectedSpace => selectedWorkspace?.spaces?.firstOrNull;

  static bool get isWorkspaceAndSpaceAppWide => _isWorkspaceAndSpaceAppWide;

  static Duration get defaultTaskDuration => _defaultTaskDuration;

  static List<Workspace>? get workspaces => _workspaces;

  static Workspace? get defaultWorkspace =>
      _workspaces?.firstOrNull;

  static String redirectAfterAuthRouteName = "";

  static const ThemeMode defaultThemeMode = ThemeMode.light;

  static const bool isDemo = false;

  static String demoUrl =
      "https://demoo-timeblocking.web.app";


}

///just to make it harder to write global variable
///with priority to repo>use case
mixin class GlobalsWriteAccess {
  set appName(String value) {
    _appName = value;
  }

  set accessToken(AccessToken value) {
    _accessToken = value;
  }

  void clearGlobals() {
    _accessToken =
        const AccessToken(accessToken: "", tokenType: "");
    _user = null;
    _selectedWorkspace = null;
    _workspaces = null;
  }

  set user(User value) {
    _user = value;
  }

  set selectedWorkspace(Workspace value) {
    printDebug("set workspace $value");
    _selectedWorkspace = value;
  }

  set isSpaceAppWide(bool value) {
    _isWorkspaceAndSpaceAppWide = value;
  }

  set defaultTaskDuration(Duration value) {
    _defaultTaskDuration = value;
  }

  set workspaces(List<Workspace> value) {
    _workspaces = value;
  }

}

class SupabaseGlobals {
  final String url;
  final String key;

  SupabaseGlobals({this.url = "", this.key = ""});

  SupabaseGlobals copyWith({
    String? url,
    String? key,
  }) {
    return SupabaseGlobals(
      url: url ?? this.url,
      key: key ?? this.key,
    );
  }
}