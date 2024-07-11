import 'package:equatable/equatable.dart';

class Workspace extends Equatable {
  const Workspace({
    this.id,
    this.name,
    this.color,
    this.avatar,
    this.members,
  });

  final String? id;
  final String? name;
  final String? color;
  final String? avatar;
  final List<ClickupWorkspaceMembers>? members;

  @override
  List<Object?> get props => [
        id,
        name,
        color,
        avatar,
        members,
      ];
}

/// user : {"id":123,"username":"John Doe","color":"#000000","profilePicture":"https://clickup.com/avatar.jpg"}

class ClickupWorkspaceMembers extends Equatable {
  const ClickupWorkspaceMembers({
    this.user,
  });

  final ClickupWorkspaceUser? user;

  @override
  List<Object?> get props => [user];
}

/// id : 123
/// username : "John Doe"
/// color : "#000000"
/// profilePicture : "https://clickup.com/avatar.jpg"

class ClickupWorkspaceUser extends Equatable {
  const ClickupWorkspaceUser({
    this.id,
    this.username,
    this.color,
    this.profilePicture,
  });

  final num? id;
  final String? username;
  final String? color;
  final String? profilePicture;

  @override
  List<Object?> get props => [
        id,
        username,
        color,
        profilePicture,
      ];
}
