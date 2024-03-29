// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:thetimeblockingapp/common/models/clickup_workspace_model.dart';

void main() {
  group("clickup workspace model tests", () {
    test('clickup workspace model from json', () {
      const json =
          "{\"id\":\"9015057836\",\"name\":\"The Workspace a\",\"color\":\"#40BC86\",\"avatar\":null,\"members\":[{\"user\":{\"id\":61769378,\"username\":\"laila nabil\",\"color\":\"\",\"profilePicture\":null}}]}";

      const model = ClickupWorkspaceModel(
          id: "9015057836",
          name: "The Workspace a",
          color: "#40BC86",
          avatar: null,
          members: [
            ClickupWorkspaceMembersModel(
                user: ClickupWorkspaceUserModel(
                    id: 61769378,
                    username: "laila nabil",
                    color: "",
                    profilePicture: null))
          ]);
      expect(ClickupWorkspaceModel.fromJson(jsonDecode(json)), model);
    });
    test('clickup workspace model to json', () {
      const json =
          "{\"id\":\"9015057836\",\"name\":\"The Workspace a\",\"color\":\"#40BC86\",\"avatar\":null,\"members\":[{\"user\":{\"id\":61769378,\"username\":\"laila nabil\",\"color\":\"\",\"profilePicture\":null}}]}";

      const model = ClickupWorkspaceModel(
          id: "9015057836",
          name: "The Workspace a",
          color: "#40BC86",
          avatar: null,
          members: [
            ClickupWorkspaceMembersModel(
                user: ClickupWorkspaceUserModel(
                    id: 61769378,
                    username: "laila nabil",
                    color: "",
                    profilePicture: null))
          ]);
      expect(jsonEncode(model.toJson()),jsonEncode(jsonDecode(json)));
    });
  });
}