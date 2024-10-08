import 'package:thetimeblockingapp/common/models/supabase_list_model.dart';
import 'package:thetimeblockingapp/common/entities/folder.dart';
import 'package:thetimeblockingapp/core/extensions.dart';

List<FolderModel>? foldersFromJson(json){
  if(json != null && json is List){
    List<FolderModel> list = [];
    for (var v in json) {
      list.add(FolderModel.fromJson(v));
    }
    return list;
  }
  return null;
}
extension FoldersExt on List<FolderModel>?{
  List<Map<String, dynamic>>? toJson() {
    if(this == null){
      return null;
    }
    return this?.map((v) => (v).toJson()).toList();
  }
}

class FolderModel extends Folder {
  const FolderModel({
    super.id,
    super.name,
    super.color,
    super.lists,
  });

  factory FolderModel.fromJson(dynamic json) {
    List<ListModel>? lists = listsFromJson(json['lists']);
    return FolderModel(
      id: (json['id']as Object?)?.toStringOrNull(),
      name: json['name'],
      color: json['color'],
      lists: lists
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['color'] = color;
    if (lists != null) {
      map['lists'] =  (lists as List<ListModel>).toJson();
    }
    return map;
  }
}
