import 'package:thetimeblockingapp/common/entities/status.dart';
import 'package:thetimeblockingapp/core/extensions.dart';
import '../common/models/supabase_folder_model.dart';
import '../common/models/supabase_list_model.dart';
import '../common/models/supabase_tag_model.dart';
import '../common/models/supabase_task_model.dart';
import '../common/models/supabase_user_model.dart';
import '../common/models/access_token_model.dart';
import '../common/models/supabase_workspace_model.dart';

class Demo {
  static AccessTokenModel accessTokenModel = const AccessTokenModel(
      accessToken: "fake_accessToken", tokenType: "Bearer");

  static const int userId = 24332434;
  static const String userEmail = "demoEmail@gmail.com";
  static const String userName = "Demo Account";
  static const String userColor = "#7b68ee";
  static SupabaseUserModel supabaseUser = const SupabaseUserModel(
    id: "24332434",
    email: userEmail,
  );

  static List<WorkspaceModel> workspaces = [
    const WorkspaceModel(
      id: 9015057836,
      name: "The Workspace a",
      color: "#40BC86",
    )
  ];
  static TaskStatus todo = const TaskStatus(
    id: "324312",
    name: "todo",
    color: "#d3d3d3",
    isDone: false,
  );
  static TaskStatus workingOn = const TaskStatus(
    id: "324312",
    name: "working on",
    color: "#00d3d3",
    isDone: false,
  );
  static TaskStatus done = const TaskStatus(
    id: "324312",
    name: "done",
    color: "#d3d300",
    isDone: false,
  );

  static List<FolderModel> folders = [
    FolderModel(id: "242434242", name: "Home", lists: [
      cartList,
    ])
  ];

  static ListModel timeBlockingList = const ListModel(
    id: "52346363432",
    name: "Time blocking app",
  );
  static ListModel cartList = const ListModel(
    id: "242534242",
    name: "🛒 Cart",
  );
  static List<ListModel> folderlessLists = [timeBlockingList];

  static List<ListModel> allLists = folderlessLists +
      [
        cartList,
      ];

  static TagModel designTag = TagModel(
      name: "design",
      color: "#6A85FF",
      id: '1',
      workspaceId: workspaces.first.id.toString());
  static TagModel developmentTag = TagModel(
      name: "development",
      color: "#6A00FF",
      id: '2',
      workspaceId: workspaces.first.id.toString());
  static TagModel documentationTag = TagModel(
      name: "documentation",
      color: "#6A8500",
      id: '3',
      workspaceId: workspaces.first.id.toString());
  static List<TagModel> tags = [
    designTag,
    developmentTag,
    documentationTag,
  ];

  static List<TaskModel> tasks = [
    TaskModel(
        id: "42432",
        title: "create design in figma",
        tags: [designTag],
        status: done,
        list: timeBlockingList,
        startDate: DateTime.now().dateAtZeroHour.subtract(const Duration(
              days: 2,
              hours: 12,
            )),
        dueDate: DateTime.now().dateAtZeroHour.subtract(const Duration(
              days: 2,
              hours: 8,
            )),
        description: '',
        priority: null,
        folder: null,
        workspace: null),
    TaskModel(
        id: "5433rtw",
        title: "Buy new mobile cover",
        tags: const [],
        status: done,
        list: cartList,
        startDate: DateTime.now().dateAtZeroHour.subtract(const Duration(
              days: 2,
              hours: 8,
            )),
        dueDate: DateTime.now().dateAtZeroHour.subtract(const Duration(
              days: 2,
              hours: 6,
            )),
        description: '',
        priority: null,
        folder: null,
        workspace: null),
    TaskModel(
        id: "45436256",
        title: "main widgets",
        tags: [developmentTag],
        status: workingOn,
        list: timeBlockingList,
        startDate: DateTime.now().dateAtZeroHour.subtract(const Duration(
              days: 1,
              hours: 8,
            )),
        dueDate: DateTime.now().dateAtZeroHour.subtract(const Duration(
              days: 1,
              hours: 4,
            )),
        description: '',
        priority: null,
        folder: null,
        workspace: null),
    TaskModel(
        id: "45436256",
        title: "create demo version",
        tags: [developmentTag],
        status: todo,
        list: timeBlockingList,
        startDate: DateTime.now().subtract(const Duration(
          hours: 3,
        )),
        dueDate: DateTime.now(),
        description: '',
        priority: null,
        folder: null,
        workspace: null),
    TaskModel(
        id: "45436256",
        title: "plan the app",
        tags: [developmentTag, designTag, documentationTag],
        status: done,
        list: timeBlockingList,
        startDate: DateTime.now().dateAtZeroHour.subtract(const Duration(
              days: 3,
              hours: 8,
            )),
        dueDate: DateTime.now().dateAtZeroHour.subtract(const Duration(
              days: 3,
              hours: 4,
            )),
        description: '',
        priority: null,
        folder: null,
        workspace: null),
    TaskModel(
        id: "6545346763",
        title: "create task popup",
        tags: [designTag],
        status: todo,
        list: timeBlockingList,
        startDate: DateTime.now().dateAtZeroHour.add(const Duration(
              days: 2,
              hours: 8,
            )),
        dueDate: DateTime.now().dateAtZeroHour.add(const Duration(
              days: 2,
              hours: 12,
            )),
        description: '',
        priority: null,
        folder: null,
        workspace: null),
    TaskModel(
        id: "65435344",
        title: "schedule",
        tags: [developmentTag],
        status: todo,
        list: timeBlockingList,
        startDate: DateTime.now().dateAtZeroHour.add(const Duration(
              days: 1,
              hours: 4,
            )),
        dueDate: DateTime.now().dateAtZeroHour.add(const Duration(
              days: 1,
              hours: 9,
            )),
        description: '',
        priority: null,
        folder: null,
        workspace: null),
    TaskModel(
        id: "54456234",
        title: "onboarding",
        tags: [developmentTag],
        list: timeBlockingList,
        status: todo,
        startDate: DateTime.now().add(const Duration(
          hours: 3,
        )),
        dueDate: DateTime.now().add(const Duration(
          hours: 9,
        )),
        description: '',
        priority: null,
        folder: null,
        workspace: null),
    TaskModel(
        id: "343243545",
        title: "update readme file",
        tags: [documentationTag],
        status: todo,
        startDate: DateTime.now().dateAtZeroHour.add(const Duration(
              days: 3,
              hours: 4,
            )),
        dueDate: DateTime.now().dateAtZeroHour.add(const Duration(
              days: 3,
              hours: 6,
            )),
        description: '',
        priority: null,
        folder: null,
        workspace: null,
        list: null),
  ];
}
