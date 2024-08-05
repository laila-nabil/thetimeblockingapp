import 'package:thetimeblockingapp/common/entities/workspace.dart';

import 'workspace_model.dart';

/// id : 1
/// name : "Main workspace"
/// user_id : "04fe62a0-9ae0-0000-ac9f-95539468cedd"
/// color : null

class SupabaseWorkspaceModel extends WorkspaceModel {
  const SupabaseWorkspaceModel({
    super.id,
    super.name,
    super.color,
  });

  @override
  SupabaseWorkspaceModel fromJson(dynamic json) {
    return SupabaseWorkspaceModel(
      id: json['id'].toString(),
      name: json['name'],
      color: json['color'],
    );
  }


  SupabaseWorkspaceModel copyWith({
    String? id,
    String? name,
    String? userId,
    String? color,
  }) =>
      SupabaseWorkspaceModel(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
      );

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['color'] = color;
    return map;
  }
}
