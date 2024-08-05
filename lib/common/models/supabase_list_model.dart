import '../entities/list_entity.dart';

class ListModel extends ListEntity {
  const ListModel({
    super.id,
    super.name,
    super.folderId,
    super.color,
    super.spaceId
  });


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['space_id'] = spaceId;
    map['folder_id'] = folderId;
    map['color'] = color;
    return map;
  }


  factory ListModel.fromJson(dynamic json) {
    return ListModel(
        id: json['id'],
        name: json['name'],
        spaceId: json['space_id'],
        color: json['color'],
        folderId: json['folder_id'],
    );
  }
}