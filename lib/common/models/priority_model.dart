import 'package:thetimeblockingapp/common/entities/priority.dart';
import 'package:thetimeblockingapp/core/extensions.dart';

List<TaskPriorityModel>? taskPriorityModelFromJson(json){
  if(json != null && json is List){
    List<TaskPriorityModel> list = [];
    for (var v in json) {
      list.add(TaskPriorityModel.fromJson(v));
    }
    return list;
  }
  return null;
}

class TaskPriorityModel extends TaskPriority {
  const TaskPriorityModel(
      {required super.id, required super.name, required super.color});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['color'] = color;
    return map;
  }

  factory TaskPriorityModel.fromJson(dynamic json) {
    return TaskPriorityModel(
        id: (json['id']as Object?)?.toStringOrNull(), name: json['name'], color: json['color']);
  }
}
