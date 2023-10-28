import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_space.dart';

import '../common/entities/clickup_user.dart';
import '../common/entities/clickup_workspace.dart';
import '../features/auth/domain/entities/clickup_access_token.dart';

class Globals {
  static String appName = "Time blocking app";
  static String clickupUrl = 'https://api.clickup.com/api/v2';
  static String clickupClientId = "";
  static String clickupClientSecret = "";
  static String clickupRedirectUrl = "";
  static ClickupAccessToken clickupAuthAccessToken =
      const ClickupAccessToken(accessToken: "", tokenType: "");
  static ClickupUser? clickupUser;
  static List<ClickupWorkspace>? clickupWorkspaces;
  static List<ClickupSpace>? clickupSpaces;
  static ClickupWorkspace? selectedWorkspace;
  static ClickupSpace? selectedSpace;
  ///[isSpaceAppWide] space is selected from appbar/drawer only and is global to app or not
  static const bool isSpaceAppWide = true;
  static ClickupWorkspace? get defaultWorkspace =>
      Globals.clickupWorkspaces?.firstOrNull;

  static ClickupSpace? get defaultSpace =>
      Globals.clickupSpaces?.firstOrNull;

  static const Duration defaultTaskDuration = Duration(hours: 1);
}