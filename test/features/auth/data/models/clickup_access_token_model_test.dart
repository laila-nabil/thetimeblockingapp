import 'package:thetimeblockingapp/features/auth/data/models/clickup_access_token_model.dart';
import 'package:flutter_test/flutter_test.dart';
void main() {
  final json = {
    "access_token":
        "55230798_5be9b2e9cd55c9b7e4352ba0c2a743bf6a3fbe047313ae451a8cd6276c7ea152",
    "token_type": "Bearer"
  };

  test("ClickUpAccessTokenModel from json", () {
    expect(
      ClickUpAccessTokenModel.fromJson(json),
      const ClickUpAccessTokenModel(
          accessToken:
              "55230798_5be9b2e9cd55c9b7e4352ba0c2a743bf6a3fbe047313ae451a8cd6276c7ea152",
          tokenType: "Bearer"),
    );
  });
}
