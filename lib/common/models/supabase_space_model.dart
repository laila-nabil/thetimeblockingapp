import 'package:thetimeblockingapp/common/models/supabase_folder_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_list_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_tag_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_task_model.dart';
import '../entities/space.dart';

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
    List<FolderModel>? folders;
    if (json['folders'] != null) {
      folders = [];
      json['folders'].forEach((v) {
        folders?.add(FolderModel.fromJson(v));
      });
    }
    List<ListModel>? lists;
    if (json['lists'] != null) {
      lists = [];
      json['lists'].forEach((v) {
        lists?.add(ListModel.fromJson(v));
      });
    }
    List<TagModel>? tags;
    if (json['tags'] != null) {
      tags = [];
      json['tags'].forEach((v) {
        tags?.add(TagModel.fromJson(v));
      });
    }
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
      map['lists'] =
          lists?.map((v) => (v as ListModel).toJson()).toList();
    }
    if (folders != null) {
      map['folders'] =
          folders?.map((v) => (v as FolderModel).toJson()).toList();
    }
    if (tags != null) {
      map['tags'] =
          tags?.map((v) => (v as TagModel).toJson()).toList();
    }
    return map;
  }
}
