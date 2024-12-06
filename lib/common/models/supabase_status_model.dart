import 'package:thetimeblockingapp/core/extensions.dart';

import '../entities/status.dart';

List<TaskStatusModel>? taskStatusModelFromJson(json){
  if(json != null && json is List){
    List<TaskStatusModel> list = [];
    for (var v in json) {
      list.add(TaskStatusModel.fromJson(v));
    }
    return list;
  }
  return null;
}

class TaskStatusModel extends TaskStatus {
  const TaskStatusModel(
      {required super.id,
      required super.nameKey,
      required super.nameAr,
      required super.nameEn,
      required super.color,
      required super.isDone});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = nameKey;
    map['name_ar'] = nameAr;
    map['name_en'] = nameEn;
    map['color'] = color;
    map['is_done'] = isDone;
    return map;
  }

  factory TaskStatusModel.fromJson(dynamic json) {
    return TaskStatusModel(
        id: (json['id']as Object?)?.toStringOrNull(),
        nameKey: json['name'],
        nameAr: json['name_ar'],
        nameEn: json['name_en'],
        color: json['color'],
        isDone: json['is_done']);
  }
}
