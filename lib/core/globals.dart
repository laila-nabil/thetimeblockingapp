import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/space.dart';

import '../common/entities/user.dart';
import '../common/entities/workspace.dart';
import '../common/enums/backend_mode.dart';
import '../features/auth/domain/entities/access_token.dart';
import 'environment.dart';

String _appName = "Time blocking app";


AccessToken _accessToken =
    const AccessToken(accessToken: "", tokenType: "");
User? _user;

Workspace? _selectedWorkspace;

String? _selectedSpaceId;

///[isSpaceAppWide] space is selected from appbar/drawer only and is global to app or not
bool _isSpaceAppWide = true;

Duration _defaultTaskDuration = const Duration(hours: 1);

List<Workspace>? _workspaces;

List<Space>? _spaces;

class Globals {
  static String get appName => _appName;

  static ClickupGlobals clickupGlobals = ClickupGlobals();

  static const Env defaultEnv  = Env.debugLocally;

  static Env env = defaultEnv;

  static get isAnalyticsEnabled => env.isAnalyticsEnabled;

  static AccessToken get accessToken =>
      _accessToken;

  static User? get user => _user;

  static Workspace? get selectedWorkspace => _selectedWorkspace;

  static String? get selectedSpaceId => _selectedSpaceId;

  static Space? get selectedSpace => spaces
      ?.where((element) => element.id == _selectedSpaceId)
      .firstOrNull;

  static bool get isSpaceAppWide => _isSpaceAppWide;

  static Duration get defaultTaskDuration => _defaultTaskDuration;

  static List<Workspace>? get workspaces => _workspaces;

  static List<Space>? get spaces => _spaces;

  static Workspace? get defaultWorkspace =>
      _workspaces?.firstOrNull;

  static Space? get defaultSpace => _spaces?.firstOrNull;

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
    _selectedSpaceId = null;
    _workspaces = null;
    _spaces = null;
  }

  set user(User value) {
    _user = value;
  }

  set selectedWorkspace(Workspace value) {
    _selectedWorkspace = value;
  }

   void setSelectedSpace(Space? space) {
    _selectedSpaceId = space?.id;
    setSpaces =  ClickupSpaceListExtensions.updateItemInList(
        list: Globals.spaces, updatedSpace: space);
  }

  set isSpaceAppWide(bool value) {
    _isSpaceAppWide = value;
  }

  set defaultTaskDuration(Duration value) {
    _defaultTaskDuration = value;
  }

  set workspaces(List<Workspace> value) {
    _workspaces = value;
  }

  set setSpaces(List<Space>? value) {
    _spaces = value;
  }

}


class ClickupGlobals {
  final String clickupUrl;

  final String clickupClientId;

  final String clickupClientSecret;

  final String clickupRedirectUrl;

  final String clickupTerms = "https://clickup.com/terms";
  final String clickupPrivacy = "https://clickup.com/terms/privacy";
  String get clickupAuthUrl =>
      "https://app.clickup.com/api?client_id=$clickupClientId&redirect_uri=$clickupRedirectUrl";

  ClickupGlobals(
      {this.clickupUrl = "",
        this.clickupClientId = "",
        this.clickupClientSecret = "",
        this.clickupRedirectUrl = ""});

  ClickupGlobals copyWith({
    String? clickupUrl,
    String? clickupClientId,
    String? clickupClientSecret,
    String? clickupRedirectUrl,
  }) {
    return ClickupGlobals(
      clickupUrl: clickupUrl ?? this.clickupUrl,
      clickupClientId: clickupClientId ?? this.clickupClientId,
      clickupClientSecret: clickupClientSecret ?? this.clickupClientSecret,
      clickupRedirectUrl: clickupRedirectUrl ?? this.clickupRedirectUrl,
    );
  }
}