import 'package:thetimeblockingapp/common/entities/tag.dart';

List<TagModel>? tagsFromJson(json){
  if(json != null && json is List){
    List<TagModel> list = [];
    for (var v in json) {
      list.add(TagModel.fromJson(v));
    }
    return list;
  }
  return null;
}

extension TagsExt on List<TagModel>?{
  List<Map<String, dynamic>>? toJson() {
    if(this == null){
      return null;
    }
    return this?.map((v) => (v).toJson()).toList();
  }
}


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
