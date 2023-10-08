import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_folder.dart';

import '../common/entities/clickup_user.dart';
import '../common/entities/clickup_workspace.dart';
import '../features/auth/domain/entities/clickup_access_token.dart';

class Globals {
  static String appName = "Time blocking app";
  static String clickUpUrl = 'https://api.clickup.com/api/v2';
  static String clickUpClientId = "";
  static String clickUpClientSecret = "";
  static String clickUpRedirectUrl = "";
  static ClickUpAccessToken clickUpAuthAccessToken =
      const ClickUpAccessToken(accessToken: "", tokenType: "");
  static ClickupUser? clickUpUser;
  static List<ClickupWorkspace>? clickUpWorkspaces;
  static List<ClickupFolder>? clickUpFolders;
  static ClickupWorkspace? selectedWorkspace;
}