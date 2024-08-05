import 'package:thetimeblockingapp/common/entities/access_token.dart';

Map<String, String>? clickupHeader({required AccessToken clickupAccessToken}) {
  return {
    "Authorization":
        clickupAccessToken.accessToken,
    "Content-Type" : "application/json"
  };
}
