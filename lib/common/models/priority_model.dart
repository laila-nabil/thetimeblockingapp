import 'package:thetimeblockingapp/common/entities/priority.dart';

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
        id: json['id'], name: json['name'], color: json['color']);
  }
}
