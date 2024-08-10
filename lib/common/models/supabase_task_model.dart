import 'package:thetimeblockingapp/common/models/priority_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_status_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_tag_model.dart';

import '../entities/task.dart';

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
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      startDate: map['start_date'],
      dueDate: map['due_date'],
      list: map['list'],
      folder: map['folder'],
      space: map['space'],
      workspace: map['workspace'],
      status: map['status'] == null
          ? null
          : TaskStatusModel.fromJson(map['status']),
      priority: map['priority'] == null
          ? null
          : TaskPriorityModel.fromJson(map['status']),
      tags: map['tags'] as List<TagModel>,
    );
  }
}
