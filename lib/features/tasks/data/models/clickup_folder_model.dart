import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_folder.dart';

/// id : "457"
/// name : "Updated Folder Name"
/// orderindex : 0
/// override_statuses : false
/// hidden : false
/// space : {"id":"789","name":"Space Name","access":true}
/// task_count : "0"
/// lists : []

class ClickupFolderModel extends ClickupFolder {
  const ClickupFolderModel({
    super.id,
    super.name,
    super.overrideStatuses,
    super.hidden,
    super.access,
    super.space,
    super.taskCount,
    super.lists,
  });

  factory ClickupFolderModel.fromJson(dynamic json) {
    List<String>? lists;
    if (json['lists'] != null) {
      lists = [];
      json['lists'].forEach((v) {
        lists?.add(v);
      });
    }
    return ClickupFolderModel(
      id: json['id'],
      name: json['name'],
      overrideStatuses: json['override_statuses'],
      hidden: json['hidden'],
      space: json['space'] != null
          ? ClickupFolderSpaceModel.fromJson(json['space'])
          : null,
      taskCount: json['task_count'],
      access: json['access'],
      lists: lists
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['override_statuses'] = overrideStatuses;
    map['hidden'] = hidden;
    map['access'] = access;
    if (space != null) {
      map['space'] = (space as ClickupFolderSpaceModel).toJson();
    }
    map['task_count'] = taskCount;
    if (lists != null) {
      map['lists'] = lists;
    }
    return map;
  }
}

/// id : "789"
/// name : "Space Name"
/// access : true

class ClickupFolderSpaceModel extends ClickupFolderSpace {
  const ClickupFolderSpaceModel({
    super.id,
    super.name,
    super.access,
  });

  factory ClickupFolderSpaceModel.fromJson(dynamic json) {
    return ClickupFolderSpaceModel(
      id: json['id'],
      name: json['name'],
      access: json['access'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['access'] = access;
    return map;
  }
}
