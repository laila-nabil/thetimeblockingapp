import 'package:thetimeblockingapp/common/models/supabase_folder_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_list_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_tag_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_task_model.dart';
import '../entities/space.dart';

List<SpaceModel>? spacesFromJson(json){
    if(json != null && json is List){
      List<SpaceModel> list = [];
      for (var v in json) {
        list.add(SpaceModel.fromJson(v));
      }
      return list;
  }
    return null;
}

extension SpacessExt on List<SpaceModel>?{
  List<Map<String, dynamic>>? toJson() {
    if(this == null){
      return null;
    }
    return this?.map((v) => (v).toJson()).toList();
  }
}

class SpaceModel extends Space {
  const SpaceModel({
    super.id,
    super.name,
    super.color,
    super.folders,
    super.lists,
    super.tags,
    super.workspaceId,
  });

  factory SpaceModel.fromJson(dynamic json) {
    String? id = json['id'];
    String? name = json['name'];
    String? color = json['color'];
    List<FolderModel>? folders = foldersFromJson(json['folders']);
    List<ListModel>? lists = listsFromJson(json['lists']);
    List<TagModel>? tags = tagsFromJson(json['tags']);
    return SpaceModel(
        id: id,
        color: color,
        name: name,
        folders: folders,
        lists: lists,
        tags: tags,
        workspaceId: json['workspace_id']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['color'] = color;
    map['workspace_id'] = workspaceId;
    if (lists != null) {
      map['lists'] = (lists as List<ListModel>).toJson();
    }
    if (folders != null) {
      map['folders'] = (folders as List<FolderModel>).toJson();
    }
    if (tags != null) {
      map['tags'] =
          (tags as List<TagModel>).toJson();
    }
    return map;
  }
}
