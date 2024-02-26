import 'package:thetimeblockingapp/common/models/clickup_user_model.dart';
import 'package:thetimeblockingapp/features/tasks/data/models/clickup_task_model.dart';

import '../common/models/clickup_workspace_model.dart';
import '../features/auth/data/models/clickup_access_token_model.dart';
import '../features/tasks/data/models/clickup_folder_model.dart';
import '../features/tasks/data/models/clickup_list_model.dart';
import '../features/tasks/data/models/clickup_space_model.dart';

class Demo {
  static ClickupAccessTokenModel accessTokenModel =
      const ClickupAccessTokenModel(
          accessToken: "fake_accessToken", tokenType: "Bearer");

  static ClickupUserModel user = const ClickupUserModel(
    id: 24332434,
    username: "Demo Account",
    email: "demoEmail@gmail.com",
    color: "#7b68ee",
    profilePicture: null,
    initials: "D",
    weekStartDay: 0,
    globalFontSupport: true,
    timezone: "Africa/Cairo",
  );

  static List<ClickupWorkspaceModel> workspaces = [
    const ClickupWorkspaceModel(
        id: "9015057836",
        name: "The Workspace a",
        color: "#40BC86",
        avatar: null,
        members: [
          ClickupWorkspaceMembersModel(
              user: ClickupWorkspaceUserModel(
                  id: 24332434,
                  username: "Demo Account",
                  color: "",
                  profilePicture: null))
        ])
  ];

  static List<ClickupSpaceModel> spaces = [
    ClickupSpaceModel(id: "242442", name: "space", members: const [
      ClickupWorkspaceMembersModel(
          user: ClickupWorkspaceUserModel(
              id: 24332434,
              username: "Demo Account",
              color: "",
              profilePicture: null))
    ])
  ];
  static List<ClickupFolderModel> folders = [
    ClickupFolderModel(
        id: "242434242", name: "Home", space: spaces.first, lists: const [
      ClickupListModel(
        id: "242534242", name: "Cart",),
      ClickupListModel(
        id: "242534242", name: "Errands",),
      ClickupListModel(
        id: "242534242", name: "Renovation",),
    ])
  ];

  static List<ClickupListModel> folderlessLists = [

    const ClickupListModel(
      id: "2425342235", name: "Personal",)
  ];

  static List<ClickupTagModel> tags = [
    const ClickupTagModel(name: "design", tagBg: "#6A85FF"),
    const ClickupTagModel(name: "development", tagBg: "#6A00FF"),
    const ClickupTagModel(name: "documentation", tagBg: "#6A8500"),
  ];
}
