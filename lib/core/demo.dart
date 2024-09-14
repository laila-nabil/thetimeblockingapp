// import 'package:thetimeblockingapp/core/extensions.dart';
// import '../common/models/supabase_space_model.dart';
// import '../common/models/supabase_user_model.dart';
// import '../common/models/access_token_model.dart';
// import '../common/models/supabase_workspace_model.dart';
//
// class Demo {
//   static AccessTokenModel accessTokenModel =
//       const AccessTokenModel(
//           accessToken: "fake_accessToken", tokenType: "Bearer");
//
//   static const int userId = 24332434;
//   static const String userEmail = "demoEmail@gmail.com";
//   static const String userName = "Demo Account";
//   static const String userColor = "#7b68ee";
//   static SupabaseUserModel clickUpUser = const SupabaseUserModel(
//     id: userId,
//     email: userEmail,
//   );
//   static SupabaseUserModel supabaseUser = const SupabaseUserModel(
//     id: userId,
//     email: userEmail,
//   );
//
//   static List<WorkspaceModel> workspaces = [
//     const WorkspaceModel(
//         id: "9015057836",
//         name: "The Workspace a",
//         color: "#40BC86",
//        )
//   ];
//   static Status todo = const Status(
//     id: "324312",
//     status: "todo",
//     color: "#d3d3d3",
//   );
//   static Status workingOn = const Status(
//     id: "324312",
//     status: "working on",
//     color: "#00d3d3",
//   );
//   static Status done = const Status(
//     id: "324312",
//     status: "done",
//     color: "#d3d300",
//   );
//
//   static List<FolderModel> folders = [
//     FolderModel(
//         id: "242434242",
//         name: "Home",
//         space: spaces.first,
//         lists: [
//           cartList,
//         ])
//   ];
//
//   static ListModel timeBlockingList = const ListModel(
//     id: "52346363432",
//     name: "Time blocking app",
//   );
//   static ListModel cartList = const ListModel(
//     id: "242534242",
//     name: "🛒 Cart",
//   );
//   static List<ListModel> folderlessLists = [
//     timeBlockingList
//   ];
//
//   static List<ListModel> allLists = folderlessLists +
//           [
//             cartList,
//           ] ;
//
//   static TagModel designTag =
//       const TagModel(name: "design", tagBg: "#6A85FF");
//   static TagModel developmentTag =
//       const TagModel(name: "development", tagBg: "#6A00FF");
//   static TagModel documentationTag =
//       const TagModel(name: "documentation", tagBg: "#6A8500");
//   static List<TagModel> tags = [
//     designTag,
//     developmentTag,
//     documentationTag,
//   ];
//
//   static List<TaskModel> tasks = [
//     TaskModel(
//         id: "42432",
//         name: "create design in figma",
//         space: spaces.first,
//         assignees: [clickUpUser.asAssignee],
//         tags: [designTag],
//         status: done,
//         list: timeBlockingList,
//         startDateUtcTimestamp: DateTime.now()
//             .dateAtZeroHour
//             .subtract(const Duration(
//               days: 2,
//               hours: 12,
//             ))
//             .millisecondsSinceEpoch
//             .toString(),
//         dueDateUtcTimestamp: DateTime.now()
//             .dateAtZeroHour
//             .subtract(const Duration(
//               days: 2,
//               hours: 8,
//             ))
//             .millisecondsSinceEpoch
//             .toString()),
//     TaskModel(
//         id: "5433rtw",
//         name: "Buy new mobile cover",
//         space: spaces.first,
//         assignees: [clickUpUser.asAssignee],
//         tags: const [],
//         status: done,
//         list: cartList,
//         startDateUtcTimestamp: DateTime.now()
//             .dateAtZeroHour
//             .subtract(const Duration(
//               days: 2,
//               hours: 8,
//             ))
//             .millisecondsSinceEpoch
//             .toString(),
//         dueDateUtcTimestamp: DateTime.now()
//             .dateAtZeroHour
//             .subtract(const Duration(
//               days: 2,
//               hours: 6,
//             ))
//             .millisecondsSinceEpoch
//             .toString()),
//     TaskModel(
//         id: "45436256",
//         name: "main widgets",
//         space: spaces.first,
//         assignees: [clickUpUser.asAssignee],
//         tags: [developmentTag],
//         status: workingOn,
//         list: timeBlockingList,
//         startDateUtcTimestamp: DateTime.now()
//             .dateAtZeroHour
//             .subtract(const Duration(
//               days: 1,
//               hours: 8,
//             ))
//             .millisecondsSinceEpoch
//             .toString(),
//         dueDateUtcTimestamp: DateTime.now()
//             .dateAtZeroHour
//             .subtract(const Duration(
//               days: 1,
//               hours: 4,
//             ))
//             .millisecondsSinceEpoch
//             .toString()),
//     TaskModel(
//         id: "45436256",
//         name: "create demo version",
//         space: spaces.first,
//         assignees: [clickUpUser.asAssignee],
//         tags: [developmentTag],
//         status: todo,
//         list: timeBlockingList,
//         startDateUtcTimestamp: DateTime.now()
//             .subtract(const Duration(
//               hours: 3,
//             ))
//             .millisecondsSinceEpoch
//             .toString(),
//         dueDateUtcTimestamp: DateTime.now().millisecondsSinceEpoch.toString()),
//     TaskModel(
//         id: "45436256",
//         name: "plan the app",
//         space: spaces.first,
//         assignees: [clickUpUser.asAssignee],
//         tags: [developmentTag, designTag, documentationTag],
//         status: done,
//         list: timeBlockingList,
//         startDateUtcTimestamp: DateTime.now()
//             .dateAtZeroHour
//             .subtract(const Duration(
//               days: 3,
//               hours: 8,
//             ))
//             .millisecondsSinceEpoch
//             .toString(),
//         dueDateUtcTimestamp: DateTime.now()
//             .dateAtZeroHour
//             .subtract(const Duration(
//               days: 3,
//               hours: 4,
//             ))
//             .millisecondsSinceEpoch
//             .toString()),
//     TaskModel(
//         id: "6545346763",
//         name: "create task popup",
//         space: spaces.first,
//         assignees: [clickUpUser.asAssignee],
//         tags: [designTag],
//         status: todo,
//         list: timeBlockingList,
//         startDateUtcTimestamp: DateTime.now()
//             .dateAtZeroHour
//             .add(const Duration(
//               days: 2,
//               hours: 8,
//             ))
//             .millisecondsSinceEpoch
//             .toString(),
//         dueDateUtcTimestamp: DateTime.now()
//             .dateAtZeroHour
//             .add(const Duration(
//               days: 2,
//               hours: 12,
//             ))
//             .millisecondsSinceEpoch
//             .toString()),
//     TaskModel(
//         id: "65435344",
//         name: "schedule",
//         space: spaces.first,
//         assignees: [clickUpUser.asAssignee],
//         tags: [developmentTag],
//         status: todo,
//         list: timeBlockingList,
//         startDateUtcTimestamp: DateTime.now()
//             .dateAtZeroHour
//             .add(const Duration(
//               days: 1,
//               hours: 4,
//             ))
//             .millisecondsSinceEpoch
//             .toString(),
//         dueDateUtcTimestamp: DateTime.now()
//             .dateAtZeroHour
//             .add(const Duration(
//               days: 1,
//               hours: 9,
//             ))
//             .millisecondsSinceEpoch
//             .toString()),
//     TaskModel(
//         id: "54456234",
//         name: "onboarding",
//         space: spaces.first,
//         assignees: [clickUpUser.asAssignee],
//         tags: [developmentTag],
//         list: timeBlockingList,
//         status: todo,
//         startDateUtcTimestamp: DateTime.now()
//             .add(const Duration(
//               hours: 3,
//             ))
//             .millisecondsSinceEpoch
//             .toString(),
//         dueDateUtcTimestamp: DateTime.now()
//             .add(const Duration(
//               hours: 9,
//             ))
//             .millisecondsSinceEpoch
//             .toString()),
//     TaskModel(
//         id: "343243545",
//         name: "update readme file",
//         space: spaces.first,
//         assignees: [clickUpUser.asAssignee],
//         tags: [documentationTag],
//         status: todo,
//         startDateUtcTimestamp: DateTime.now()
//             .dateAtZeroHour
//             .add(const Duration(
//               days: 3,
//               hours: 4,
//             ))
//             .millisecondsSinceEpoch
//             .toString(),
//         dueDateUtcTimestamp: DateTime.now()
//             .dateAtZeroHour
//             .add(const Duration(
//               days: 3,
//               hours: 6,
//             ))
//             .millisecondsSinceEpoch
//             .toString()),
//   ];
// }
