import 'package:flutter_test/flutter_test.dart';
import 'package:thetimeblockingapp/core/network/clickup_header.dart';
import 'package:thetimeblockingapp/features/auth/domain/entities/access_token.dart';

void main() {
  test('clickup header test', () {
    const clickupAccessToken = "abcToken";
    expect(
        clickupHeader(
            clickupAccessToken:
                const AccessToken(accessToken: clickupAccessToken,tokenType: "Bearer")),
        {
          "Authorization": clickupAccessToken,
          "Content-Type": "application/json"
        });
  });
}
