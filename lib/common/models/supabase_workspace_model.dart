import 'package:thetimeblockingapp/common/entities/folder.dart';
import 'package:thetimeblockingapp/common/entities/tasks_list.dart';
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/common/models/supabase_tag_model.dart';

import 'supabase_folder_model.dart';
import 'supabase_list_model.dart';


class WorkspaceModel extends Workspace {
  const WorkspaceModel({
    super.id,
    super.name,
    super.userId,
    super.color,
    super.folders,
    super.lists,
    super.tags,
  });

  factory WorkspaceModel.fromJson(dynamic json) {
    List<ListModel>? lists = listsFromJson(json['lists']);
    List<FolderModel>? folders = foldersFromJson(json['folders']);
    return WorkspaceModel(
      id: json['id'] ?? json['workspace_id'],
      name: json['name'],
      userId: json['user_id'],
      color: json['color'],
      lists: lists,
      folders: folders,
      tags: json['tags'] == null ? null : tagsFromJson(json['tags']),
    );
  }

  WorkspaceModel copyWith({
    int? id,
    String? name,
    String? userId,
    String? color,
    List<Folder>? folders,
    List<TasksList>? lists,
    List<TagModel>? tags
  }) =>
      WorkspaceModel(
        id: id ?? this.id,
        name: name ?? this.name,
        userId: userId ?? this.userId,
        color: color ?? this.color,
        folders: folders ?? this.folders,
        lists: lists ?? this.lists,
        tags: tags ?? this.tags
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['user_id'] = userId;
    map['color'] = color;
    if (lists != null) {
      map['lists'] = (lists as List<ListModel>).toJson();
    }
    if (folders != null) {
      map['folders'] = (folders as List<FolderModel>).toJson();
    }
    map['tags'] =
    tags == null ? null : (tags as List<TagModel>).toJson();
    return map;
  }
}
