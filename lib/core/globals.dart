import '../common/entities/clickup_user.dart';
import '../common/entities/clickup_workspace.dart';

class Globals {
  static String appName = "Time blocking app";
  static String clickUpUrl = 'https://api.clickup.com/api/v2';
  static String clickUpClientId = "";
  static String clickUpClientSecret = "";
  static String clickUpRedirectUrl = "";
  static String clickUpAuthAccessToken = "";
  static ClickupUser? clickUpUser;
  static List<ClickupWorkspace>? clickUpWorkspaces;
}