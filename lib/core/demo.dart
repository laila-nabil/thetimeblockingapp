import 'package:thetimeblockingapp/common/models/clickup_user_model.dart';
import 'package:thetimeblockingapp/core/extensions.dart';
import 'package:thetimeblockingapp/features/tasks/data/models/clickup_task_model.dart';

import '../common/models/clickup_workspace_model.dart';
import '../features/auth/data/models/clickup_access_token_model.dart';
import '../features/tasks/data/models/clickup_folder_model.dart';
import '../features/tasks/data/models/clickup_list_model.dart';
import '../features/tasks/data/models/clickup_space_model.dart';
import '../features/tasks/domain/entities/clickup_task.dart';

class Demo {
  static ClickupAccessTokenModel accessTokenModel =
      const ClickupAccessTokenModel(
          accessToken: "fake_accessToken", tokenType: "Bearer");

  static const int userId = 24332434;
  static const String userEmail = "demoEmail@gmail.com";
  static const String userName = "Demo Account";
  static const String userColor = "#7b68ee";
  static ClickupUserModel user = const ClickupUserModel(
    id: userId,
    username: userName,
    email: userEmail,
    color: userColor,
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
                  id: userId,
                  username: userName,
                  color: "",
                  profilePicture: null))
        ])
  ];
  static ClickupStatus todo = const ClickupStatus(
    id: "324312",
    status: "todo",
    color: "#d3d3d3",
  );
  static ClickupStatus workingOn = const ClickupStatus(
    id: "324312",
    status: "working on",
    color: "#00d3d3",
  );
  static ClickupStatus done = const ClickupStatus(
    id: "324312",
    status: "done",
    color: "#d3d300",
  );
  static List<ClickupSpaceModel> spaces = [
    ClickupSpaceModel(id: "242442", name: "space", members: const [
      ClickupWorkspaceMembersModel(
          user: ClickupWorkspaceUserModel(
              id: userId,
              username: userName,
              color: userColor,
              profilePicture: null))
    ], statuses: [
      todo,
      workingOn,
      done,
    ])
  ];

  static List<ClickupFolderModel> folders = [
    ClickupFolderModel(
        id: "242434242",
        name: "Home",
        space: spaces.first,
        lists: const [
          ClickupListModel(
            id: "242534242",
            name: "Cart",
          ),
          ClickupListModel(
            id: "242534242",
            name: "Errands",
          ),
          ClickupListModel(
            id: "242534242",
            name: "Renovation",
          ),
        ])
  ];

  static List<ClickupListModel> folderlessLists = [
    const ClickupListModel(
      id: "2425342235",
      name: "Personal",
    )
  ];

  static List<ClickupListModel> allLists = folderlessLists +
          const [
            ClickupListModel(
              id: "242534242",
              name: "Cart",
            ),
            ClickupListModel(
              id: "242534242",
              name: "Errands",
            ),
            ClickupListModel(
              id: "242534242",
              name: "Renovation",
            ),
          ] ??
      [];

  static ClickupTagModel designTag =
      const ClickupTagModel(name: "design", tagBg: "#6A85FF");
  static ClickupTagModel developmentTag =
      const ClickupTagModel(name: "development", tagBg: "#6A00FF");
  static ClickupTagModel documentationTag =
      const ClickupTagModel(name: "documentation", tagBg: "#6A8500");
  static List<ClickupTagModel> tags = [
    designTag,
    developmentTag,
    documentationTag,
  ];

  static List<ClickupTaskModel> tasks = [
    ClickupTaskModel(
        id: "42432",
        name: "create design in figma",
        space: spaces.first,
        assignees: [user.asAssignee],
        tags: [designTag],
        status: ClickupStatus(),
        startDateUtcTimestamp: DateTime.now()
            .dateAtZeroHour
            .subtract(const Duration(
              hours: 12,
            ))
            .millisecondsSinceEpoch
            .toString(),
        dueDateUtcTimestamp: DateTime.now()
            .dateAtZeroHour
            .subtract(const Duration(
              hours: 8,
            ))
            .millisecondsSinceEpoch
            .toString())
  ];
}
