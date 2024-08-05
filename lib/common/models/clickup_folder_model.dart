import 'package:thetimeblockingapp/common/models/clickup_list_model.dart';
import 'package:thetimeblockingapp/common/models/clickup_space_model.dart';
import 'package:thetimeblockingapp/common/entities/folder.dart';

/// id : "457"
/// name : "Updated Folder Name"
/// orderindex : 0
/// override_statuses : false
/// hidden : false
/// space : {"id":"789","name":"Space Name","access":true}
/// task_count : "0"
/// lists : []

class ClickupFolderModel extends Folder {
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
    List<ClickupListModel>? lists;
    if (json['lists'] != null) {
      lists = [];
      json['lists'].forEach((v) {
        lists?.add(ClickupListModel.fromJson(v));
      });
    }
    return ClickupFolderModel(
      id: json['id'],
      name: json['name'],
      overrideStatuses: json['override_statuses'],
      hidden: json['hidden'],
      space: json['space'] != null
          ? ClickupSpaceModel.fromJson(json['space'])
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
      map['space'] = (space as ClickupSpaceModel).toJson();
    }
    map['task_count'] = taskCount;
    if (lists != null) {
      map['lists'] = lists;
    }
    return map;
  }
}
