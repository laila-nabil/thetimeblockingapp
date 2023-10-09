import 'package:thetimeblockingapp/features/auth/domain/entities/clickup_access_token.dart';

Map<String, String>? clickupHeader({required ClickupAccessToken clickupAccessToken}) {
  return {
    "Authorization":
        clickupAccessToken.accessToken,
    // "Content-Type" : "application/json"
  };
}
