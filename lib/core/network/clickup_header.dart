import 'package:thetimeblockingapp/features/auth/domain/entities/clickup_access_token.dart';

Map<String, String>? clickUpHeader({required ClickUpAccessToken clickUpAccessToken}) {
  return {
    "Authorization":
        clickUpAccessToken.accessToken
  };
}
