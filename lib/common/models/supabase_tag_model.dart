import 'package:thetimeblockingapp/common/entities/tag.dart';

class TagModel extends Tag {
  const TagModel(
      {required super.id,
      required super.name,
      required super.workspaceId,
      required super.color});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['workspace_id'] = workspaceId;
    map['color'] = color;
    return map;
  }


  factory TagModel.fromJson(dynamic json) {
    return TagModel(
      id: json['id'],
      name: json['name'],
      workspaceId: json['workspace_id'],
      color: json['color']
    );
  }
}
