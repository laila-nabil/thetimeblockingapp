import 'package:thetimeblockingapp/common/entities/workspace.dart';

import 'clickup_user_model.dart';
import 'workspace_model.dart';

/// id : "1234"
/// name : "My ClickUp Workspace"
/// color : "#000000"
/// avatar : "https://clickup.com/avatar.jpg"
/// members : [{"user":{"id":123,"username":"John Doe","color":"#000000","profilePicture":"https://clickup.com/avatar.jpg"}}]

class ClickupWorkspaceModel extends WorkspaceModel {
  const ClickupWorkspaceModel({
    super.id,
    super.name,
    super.color,
    super.avatar,
    super.members,
  });

  @override
  ClickupWorkspaceModel fromJson(dynamic json) {
    String? id = json['id'];
    String? name = json['name'];
    String? color = json['color'];
    String? avatar = json['avatar'];
    List<WorkspaceMembers>? members;
    if (json['members'] != null) {
      members = [];
      json['members'].forEach((v) {
        members?.add(ClickupWorkspaceMembersModel.fromJson(v));
      });
    }
    return ClickupWorkspaceModel(
        id: id, name: name, color: color, avatar: avatar, members: members);
  }

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['color'] = color;
    map['avatar'] = avatar;
    if (members != null) {
      map['members'] =
          members?.map((v) => (v as ClickupWorkspaceMembersModel).toJson()).toList();
    }
    return map;
  }
}

/// user : {"id":123,"username":"John Doe","color":"#000000","profilePicture":"https://clickup.com/avatar.jpg"}

class ClickupWorkspaceMembersModel extends WorkspaceMembers {
  const ClickupWorkspaceMembersModel({
    super.user,
  });

  factory ClickupWorkspaceMembersModel.fromJson(Map<String,dynamic> json) {
    return ClickupWorkspaceMembersModel(
        user: json['user'] != null ? ClickupUserModel.fromJson(json['user']) : null);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (user != null) {
      map['user'] = (user as ClickupUserModel).toJson();
    }
    return map;
  }
}