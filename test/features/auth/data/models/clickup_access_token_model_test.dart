import 'package:thetimeblockingapp/features/auth/data/models/access_token_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

void main() {
  // ignore: unnecessary_string_escapes
  const jsonString = """{\"access_token\":\"55230798_5be9b2e9cd55c9b7e4352ba0c2a743bf6a3fbe047313ae451a8cd6276c7ea152\",\"token_type\":\"Bearer\"} """;

  test("ClickUpAccessTokenModel from json", () {
    expect(
      AccessTokenModel.fromJson(json.decode(jsonString)),
      const AccessTokenModel(
          accessToken:
              "55230798_5be9b2e9cd55c9b7e4352ba0c2a743bf6a3fbe047313ae451a8cd6276c7ea152",
          tokenType: "Bearer"),
    );
  });
}
