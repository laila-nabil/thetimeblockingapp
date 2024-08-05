import 'package:equatable/equatable.dart';

import 'user.dart';

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
  final List<WorkspaceMembers>? members;

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

class WorkspaceMembers extends Equatable {
  const WorkspaceMembers({
    this.user,
  });

  final User? user;

  @override
  List<Object?> get props => [user];
}
