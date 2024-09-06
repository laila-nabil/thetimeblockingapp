import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/common/models/supabase_tag_model.dart';

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
    super.tags,
  });

  factory WorkspaceModel.fromJson(dynamic json) {
    return WorkspaceModel(
      id: json['id'] ?? json['workspace_id'],
      name: json['name'],
      userId: json['user_id'],
      color: json['color'],
      spaces: json['spaces'] == null ? null : spacesFromJson(json['spaces']),
      tags: json['tags'] == null ? null : tagsFromJson(json['tags']),
    );
  }

  WorkspaceModel copyWith({
    int? id,
    String? name,
    String? userId,
    String? color,
    List<SpaceModel>? spaces,
    List<TagModel>? tags
  }) =>
      WorkspaceModel(
        id: id ?? this.id,
        name: name ?? this.name,
        userId: userId ?? this.userId,
        color: color ?? this.color,
        spaces: spaces ?? this.spaces,
        tags: tags ?? this.tags
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['user_id'] = userId;
    map['color'] = color;
    map['spaces'] =
        spaces == null ? null : (spaces as List<SpaceModel>).toJson();
    map['tags'] =
    tags == null ? null : (tags as List<TagModel>).toJson();
    return map;
  }
}
