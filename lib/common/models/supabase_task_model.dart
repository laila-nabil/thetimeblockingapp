import 'package:thetimeblockingapp/common/models/priority_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_status_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_tag_model.dart';

import '../entities/task.dart';

class TaskModel extends TaskEntity {
  const TaskModel(
      {required super.id,
      required super.title,
      required super.description,
      required super.status,
      required super.priority,
      required super.tags});

  Map<String, dynamic> toJson() {

    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'tags': tags,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
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
