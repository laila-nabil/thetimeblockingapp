import 'package:thetimeblockingapp/common/entities/clickup_workspace.dart';

/// id : "1234"
/// name : "My ClickUp Workspace"
/// color : "#000000"
/// avatar : "https://clickup.com/avatar.jpg"
/// members : [{"user":{"id":123,"username":"John Doe","color":"#000000","profilePicture":"https://clickup.com/avatar.jpg"}}]

class ClickupWorkspaceModel extends ClickupWorkspace {
  const ClickupWorkspaceModel({
    super.id,
    super.name,
    super.color,
    super.avatar,
    super.members,
  });

  factory ClickupWorkspaceModel.fromJson(dynamic json) {
    String? id = json['id'];
    String? name = json['name'];
    String? color = json['color'];
    String? avatar = json['avatar'];
    List<ClickupWorkspaceMembers>? members;
    if (json['members'] != null) {
      members = [];
      json['members'].forEach((v) {
        members?.add(ClickupWorkspaceMembersModel.fromJson(v));
      });
    }
    return ClickupWorkspaceModel(
        id: id, name: name, color: color, avatar: avatar, members: members);
  }

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

class ClickupWorkspaceMembersModel extends ClickupWorkspaceMembers {
  const ClickupWorkspaceMembersModel({
    super.user,
  });

  factory ClickupWorkspaceMembersModel.fromJson(dynamic json) {
    return ClickupWorkspaceMembersModel(
        user: json['user'] != null ? ClickupWorkspaceUserModel.fromJson(json['user']) : null);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (user != null) {
      map['user'] = (user as ClickupWorkspaceUserModel).toJson();
    }
    return map;
  }
}

/// id : 123
/// username : "John Doe"
/// color : "#000000"
/// profilePicture : "https://clickup.com/avatar.jpg"

class ClickupWorkspaceUserModel extends ClickupWorkspaceUser {
  const ClickupWorkspaceUserModel({
    super.id,
    super.username,
    super.color,
    super.profilePicture,
  });

  factory ClickupWorkspaceUserModel.fromJson(dynamic json) {
    return ClickupWorkspaceUserModel(
      id: json['id'],
      username: json['username'],
      color: json['color'],
      profilePicture: json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['username'] = username;
    map['color'] = color;
    map['profilePicture'] = profilePicture;
    return map;
  }
}
