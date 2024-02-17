import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_space.dart';

import '../common/entities/clickup_user.dart';
import '../common/entities/clickup_workspace.dart';
import '../features/auth/domain/entities/clickup_access_token.dart';

String _appName = "Time blocking app";


ClickupAccessToken _clickupAuthAccessToken =
    const ClickupAccessToken(accessToken: "", tokenType: "");
ClickupUser? _clickupUser;

ClickupWorkspace? _selectedWorkspace;

String? _selectedSpaceId;

///[isSpaceAppWide] space is selected from appbar/drawer only and is global to app or not
bool _isSpaceAppWide = true;

Duration _defaultTaskDuration = const Duration(hours: 1);

List<ClickupWorkspace>? _clickupWorkspaces;

List<ClickupSpace>? _clickupSpaces;

class Globals {
  static String get appName => _appName;

  static String clickupUrl = "";

  static String clickupClientId = "";

  static String clickupClientSecret = "";

  static String clickupRedirectUrl = "";

  static bool analyticsEnabledDefault  = false;

  static bool analyticsEnabled = analyticsEnabledDefault;

  static ClickupAccessToken get clickupAuthAccessToken =>
      _clickupAuthAccessToken;

  static ClickupUser? get clickupUser => _clickupUser;

  static ClickupWorkspace? get selectedWorkspace => _selectedWorkspace;

  static String? get selectedSpaceId => _selectedSpaceId;

  static ClickupSpace? get selectedSpace => clickupSpaces
      ?.where((element) => element.id == _selectedSpaceId)
      .firstOrNull;

  static bool get isSpaceAppWide => _isSpaceAppWide;

  static Duration get defaultTaskDuration => _defaultTaskDuration;

  static List<ClickupWorkspace>? get clickupWorkspaces => _clickupWorkspaces;

  static List<ClickupSpace>? get clickupSpaces => _clickupSpaces;

  static ClickupWorkspace? get defaultWorkspace =>
      _clickupWorkspaces?.firstOrNull;

  static ClickupSpace? get defaultSpace => _clickupSpaces?.firstOrNull;

  static String redirectAfterAuthRouteName = "";
}

///just to make it harder to write global variable
///with priority to repo>use case
mixin class GlobalsWriteAccess {
  set appName(String value) {
    _appName = value;
  }

  set clickupAuthAccessToken(ClickupAccessToken value) {
    _clickupAuthAccessToken = value;
  }

  set clickupUser(ClickupUser value) {
    _clickupUser = value;
  }

  set selectedWorkspace(ClickupWorkspace value) {
    _selectedWorkspace = value;
  }

   void setSelectedSpace(ClickupSpace? space) {
    _selectedSpaceId = space?.id;
    clickupSpaces =  ClickupSpaceListExtensions.updateItemInList(
        list: Globals.clickupSpaces, updatedSpace: space);
  }

  set isSpaceAppWide(bool value) {
    _isSpaceAppWide = value;
  }

  set defaultTaskDuration(Duration value) {
    _defaultTaskDuration = value;
  }

  set clickupWorkspaces(List<ClickupWorkspace> value) {
    _clickupWorkspaces = value;
  }

  set clickupSpaces(List<ClickupSpace>? value) {
    _clickupSpaces = value;
  }
}
