import 'package:thetimeblockingapp/common/models/clickup_user_model.dart';
import 'package:thetimeblockingapp/core/extensions.dart';
import 'package:thetimeblockingapp/features/tasks/data/models/clickup_task_model.dart';

import '../common/models/clickup_workspace_model.dart';
import '../features/auth/data/models/access_token_model.dart';
import '../features/tasks/data/models/clickup_folder_model.dart';
import '../features/tasks/data/models/clickup_list_model.dart';
import '../features/tasks/data/models/clickup_space_model.dart';
import '../features/tasks/domain/entities/task.dart';

class Demo {
  static AccessTokenModel accessTokenModel =
      const AccessTokenModel(
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
  static Status todo = const Status(
    id: "324312",
    status: "todo",
    color: "#d3d3d3",
  );
  static Status workingOn = const Status(
    id: "324312",
    status: "working on",
    color: "#00d3d3",
  );
  static Status done = const Status(
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
        lists: [
          cartList,
        ])
  ];

  static ClickupListModel timeBlockingList = const ClickupListModel(
    id: "52346363432",
    name: "Time blocking app",
  );
  static ClickupListModel cartList = const ClickupListModel(
    id: "242534242",
    name: "🛒 Cart",
  );
  static List<ClickupListModel> folderlessLists = [
    timeBlockingList
  ];

  static List<ClickupListModel> allLists = folderlessLists +
          [
            cartList,
          ] ;

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
        status: done,
        list: timeBlockingList,
        startDateUtcTimestamp: DateTime.now()
            .dateAtZeroHour
            .subtract(const Duration(
              days: 2,
              hours: 12,
            ))
            .millisecondsSinceEpoch
            .toString(),
        dueDateUtcTimestamp: DateTime.now()
            .dateAtZeroHour
            .subtract(const Duration(
              days: 2,
              hours: 8,
            ))
            .millisecondsSinceEpoch
            .toString()),
    ClickupTaskModel(
        id: "5433rtw",
        name: "Buy new mobile cover",
        space: spaces.first,
        assignees: [user.asAssignee],
        tags: const [],
        status: done,
        list: cartList,
        startDateUtcTimestamp: DateTime.now()
            .dateAtZeroHour
            .subtract(const Duration(
              days: 2,
              hours: 8,
            ))
            .millisecondsSinceEpoch
            .toString(),
        dueDateUtcTimestamp: DateTime.now()
            .dateAtZeroHour
            .subtract(const Duration(
              days: 2,
              hours: 6,
            ))
            .millisecondsSinceEpoch
            .toString()),
    ClickupTaskModel(
        id: "45436256",
        name: "main widgets",
        space: spaces.first,
        assignees: [user.asAssignee],
        tags: [developmentTag],
        status: workingOn,
        list: timeBlockingList,
        startDateUtcTimestamp: DateTime.now()
            .dateAtZeroHour
            .subtract(const Duration(
              days: 1,
              hours: 8,
            ))
            .millisecondsSinceEpoch
            .toString(),
        dueDateUtcTimestamp: DateTime.now()
            .dateAtZeroHour
            .subtract(const Duration(
              days: 1,
              hours: 4,
            ))
            .millisecondsSinceEpoch
            .toString()),
    ClickupTaskModel(
        id: "45436256",
        name: "create demo version",
        space: spaces.first,
        assignees: [user.asAssignee],
        tags: [developmentTag],
        status: todo,
        list: timeBlockingList,
        startDateUtcTimestamp: DateTime.now()
            .subtract(const Duration(
              hours: 3,
            ))
            .millisecondsSinceEpoch
            .toString(),
        dueDateUtcTimestamp: DateTime.now().millisecondsSinceEpoch.toString()),
    ClickupTaskModel(
        id: "45436256",
        name: "plan the app",
        space: spaces.first,
        assignees: [user.asAssignee],
        tags: [developmentTag, designTag, documentationTag],
        status: done,
        list: timeBlockingList,
        startDateUtcTimestamp: DateTime.now()
            .dateAtZeroHour
            .subtract(const Duration(
              days: 3,
              hours: 8,
            ))
            .millisecondsSinceEpoch
            .toString(),
        dueDateUtcTimestamp: DateTime.now()
            .dateAtZeroHour
            .subtract(const Duration(
              days: 3,
              hours: 4,
            ))
            .millisecondsSinceEpoch
            .toString()),
    ClickupTaskModel(
        id: "6545346763",
        name: "create task popup",
        space: spaces.first,
        assignees: [user.asAssignee],
        tags: [designTag],
        status: todo,
        list: timeBlockingList,
        startDateUtcTimestamp: DateTime.now()
            .dateAtZeroHour
            .add(const Duration(
              days: 2,
              hours: 8,
            ))
            .millisecondsSinceEpoch
            .toString(),
        dueDateUtcTimestamp: DateTime.now()
            .dateAtZeroHour
            .add(const Duration(
              days: 2,
              hours: 12,
            ))
            .millisecondsSinceEpoch
            .toString()),
    ClickupTaskModel(
        id: "65435344",
        name: "schedule",
        space: spaces.first,
        assignees: [user.asAssignee],
        tags: [developmentTag],
        status: todo,
        list: timeBlockingList,
        startDateUtcTimestamp: DateTime.now()
            .dateAtZeroHour
            .add(const Duration(
              days: 1,
              hours: 4,
            ))
            .millisecondsSinceEpoch
            .toString(),
        dueDateUtcTimestamp: DateTime.now()
            .dateAtZeroHour
            .add(const Duration(
              days: 1,
              hours: 9,
            ))
            .millisecondsSinceEpoch
            .toString()),
    ClickupTaskModel(
        id: "54456234",
        name: "onboarding",
        space: spaces.first,
        assignees: [user.asAssignee],
        tags: [developmentTag],
        list: timeBlockingList,
        status: todo,
        startDateUtcTimestamp: DateTime.now()
            .add(const Duration(
              hours: 3,
            ))
            .millisecondsSinceEpoch
            .toString(),
        dueDateUtcTimestamp: DateTime.now()
            .add(const Duration(
              hours: 9,
            ))
            .millisecondsSinceEpoch
            .toString()),
    ClickupTaskModel(
        id: "343243545",
        name: "update readme file",
        space: spaces.first,
        assignees: [user.asAssignee],
        tags: [documentationTag],
        status: todo,
        startDateUtcTimestamp: DateTime.now()
            .dateAtZeroHour
            .add(const Duration(
              days: 3,
              hours: 4,
            ))
            .millisecondsSinceEpoch
            .toString(),
        dueDateUtcTimestamp: DateTime.now()
            .dateAtZeroHour
            .add(const Duration(
              days: 3,
              hours: 6,
            ))
            .millisecondsSinceEpoch
            .toString()),
  ];
}
