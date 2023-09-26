import '../common/enums/auth_mode.dart';

class Globals{

  static const appName = "Time blocking app";
  static const clickUpUrl = 'https://api.clickup.com/api/v2/';
  static const authMode = AuthMode.clickUpOnly;
  static String clickUpAuthAccessToken = "";
  static String clickUpClientId = "";
  static String clickUpClientSecret = "";
  static String clickUpRedirectUrl = "";
}