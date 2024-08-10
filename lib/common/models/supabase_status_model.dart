import '../entities/status.dart';

class TaskStatusModel extends TaskStatus {
  const TaskStatusModel(
      {required super.id,
      required super.name,
      required super.color,
      required super.isDone});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['color'] = color;
    map['is_done'] = isDone;
    return map;
  }

  factory TaskStatusModel.fromJson(dynamic json) {
    return TaskStatusModel(
        id: json['id'],
        name: json['name'],
        color: json['color'],
        isDone: json['is_done']);
  }
}
