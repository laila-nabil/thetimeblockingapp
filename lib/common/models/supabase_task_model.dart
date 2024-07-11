import 'package:thetimeblockingapp/common/models/priority_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_folder_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_list_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_space_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_status_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_tag_model.dart';
import 'package:thetimeblockingapp/core/extensions.dart';

import '../entities/tag.dart';
import '../entities/task.dart';
import 'supabase_workspace_model.dart';


List<TaskModel>? tasksFromJson(Object? json){
  if(json != null && json is List){
    List<TaskModel> list = [];
    for (var v in json) {
      list.add(TaskModel.fromJson(v));
    }
    return list;
  }
  return null;
}

extension TasksExt on List<TaskModel>?{
  List<Map<String, dynamic>>? toJson() {
    if(this == null){
      return null;
    }
    return this?.map((v) => (v).toJson()).toList();
  }
}

class TaskModel extends Task {
  const TaskModel(
      {required super.id,
      required super.title,
      required super.description,
      required super.status,
      required super.priority,
      required super.tags,
      required super.startDate,
      required super.dueDate,
      required super.list,
      required super.folder,
      required super.space,
      required super.workspace});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'tags': tags,
      'due_date': dueDate,
      'start_date': startDate,
      'list': list,
      'folder': folder,
      'space': space,
      'workspace': workspace,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> map) {
    return TaskModel(
      id: (map['id']as Object?)?.toStringOrNull(),
      title: map['title'] ,
      description: map['description'] ,
      startDate:DateTime.tryParse( map['start_date']??""),
      dueDate: DateTime.tryParse(map['due_date']??""),
      list: map['list'] == null
          ? null
          : ListModel.fromJson(map['list'][0]),
      folder: map['folder'] == null
          ? null
          : FolderModel.fromJson(map['folder'][0]),
      space: map['space'] == null
          ? null
          : SpaceModel.fromJson(map['space'][0]),
      workspace: map['workspace'] == null
          ? null
          : WorkspaceModel.fromJson(map['workspace'][0]),
      status: map['status'] == null
          ? null
          : TaskStatusModel.fromJson(map['status'][0]),
      priority: map['priority'] == null
          ? null
          : TaskPriorityModel.fromJson(map['priority'][0]),
      tags: (tagsFromJson(map['tags']) ?? []) as List<Tag>,
    );
  }
}
