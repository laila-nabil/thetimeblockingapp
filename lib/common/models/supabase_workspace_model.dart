import 'package:thetimeblockingapp/common/entities/workspace.dart';

import 'supabase_space_model.dart';

/// id : 1
/// name : "Main workspace"
/// user_id : "04fe62a0-9ae0-0000-ac9f-95539468cedd"
/// color : null

class WorkspaceModel extends Workspace {
  const WorkspaceModel({
    super.id,
    super.name,
    super.userId,
    super.color,
    super.spaces,
  });

  factory WorkspaceModel.fromJson(dynamic json) {
    return WorkspaceModel(
      id: json['id'] ?? json['workspace_id'],
      name: json['name'],
      userId: json['user_id'],
      color: json['color'],
      spaces: json['spaces'] == null ? null : spacesFromJson(json['spaces']));
  }

  WorkspaceModel copyWith({
    int? id,
    String? name,
    String? userId,
    String? color,
    List<SpaceModel>? spaces
  }) =>
      WorkspaceModel(
        id: id ?? this.id,
        name: name ?? this.name,
        userId: userId ?? this.userId,
        color: color ?? this.color,
        spaces: spaces ?? this.spaces
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['user_id'] = userId;
    map['color'] = color;
    map['spaces'] =
        spaces == null ? null : (spaces as List<SpaceModel>).toJson();
    return map;
  }
}
