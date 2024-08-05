import 'package:thetimeblockingapp/common/models/supabase_list_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_space_model.dart';
import 'package:thetimeblockingapp/common/entities/folder.dart';

class FolderModel extends Folder {
  const FolderModel({
    super.id,
    super.name,
    super.spaceId,
    super.color,
    super.lists,
  });

  factory FolderModel.fromJson(dynamic json) {
    List<ListModel>? lists;
    if (json['lists'] != null) {
      lists = [];
      json['lists'].forEach((v) {
        lists?.add(ListModel.fromJson(v));
      });
    }
    return FolderModel(
      id: json['id'],
      name: json['name'],
      spaceId: json['space_id'],
      color: json['color'],
      lists: lists
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['space_id'] = spaceId;
    map['color'] = color;
    if (lists != null) {
      map['lists'] = lists;
    }
    return map;
  }
}
