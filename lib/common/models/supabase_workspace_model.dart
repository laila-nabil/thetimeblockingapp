import 'package:thetimeblockingapp/common/entities/workspace.dart';

/// id : 1
/// name : "Main workspace"
/// user_id : "04fe62a0-9ae0-0000-ac9f-95539468cedd"
/// color : null

class SupabaseWorkspaceModel extends Workspace {
  const SupabaseWorkspaceModel({
    super.id,
    super.name,
    this.userId,
    super.color,
  });

  factory SupabaseWorkspaceModel.fromJson(dynamic json) {
    return SupabaseWorkspaceModel(
      id: json['id'],
      name: json['name'],
      userId: json['user_id'],
      color: json['color'],
    );
  }

  final String? userId;

  SupabaseWorkspaceModel copyWith({
    String? id,
    String? name,
    String? userId,
    String? color,
  }) =>
      SupabaseWorkspaceModel(
        id: id ?? this.id,
        name: name ?? this.name,
        userId: userId ?? this.userId,
        color: color ?? this.color,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['user_id'] = userId;
    map['color'] = color;
    return map;
  }
}
