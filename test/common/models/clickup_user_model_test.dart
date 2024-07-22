import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:thetimeblockingapp/common/models/clickup_user_model.dart';

void main() {
  test("clickup user from json", () {
    const jsonString =
    """{"id":55230798,"username":"Laila Nabil","email":"laila.nabil.mustafa1@gmail.com","color":"#7b68ee","initials":"LN","week_start_day":0,"global_font_support":true,"timezone":"Africa/Cairo"} """;
    const model = ClickupUserModel(
      id: 55230798,
      username:"Laila Nabil",
      email : "laila.nabil.mustafa1@gmail.com",
      color : "#7b68ee",
      profilePicture : null,
      initials : "LN",
      weekStartDay : 0,
      timezone : "Africa/Cairo",
    );
    expect(ClickupUserModel.fromJson(json.decode(jsonString)), model);
  });
}
