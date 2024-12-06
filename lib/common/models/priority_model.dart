import 'package:thetimeblockingapp/common/entities/priority.dart';
import 'package:thetimeblockingapp/core/extensions.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';

List<TaskPriorityModel>? taskPriorityModelFromJson(json) {
  if (json != null && json is List) {
    List<TaskPriorityModel> list = [];
    for (var v in json) {
      list.add(TaskPriorityModel.fromJson(v));
    }
    return list;
  }
  return null;
}

class TaskPriorityModel extends TaskPriority {
  TaskPriorityModel({super.id, super.color, super.nameKey, super.nameEn, super.nameAr});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = nameKey;
    map['name_ar'] = nameAr;
    map['name_en'] = nameEn;
    map['color'] = color;
    return map;
  }

  factory TaskPriorityModel.fromJson(dynamic json) {
    printDebug("TaskPriorityModel json is $json");
    printDebug("TaskPriorityModel json is ${TaskPriorityModel(
        id: (json['id'] as Object?)?.toStringOrNull(),
        nameKey: json['name'],
        nameAr: json['name_ar'],
        nameEn: json['name_en'],
        color: json['color'])}");
    return TaskPriorityModel(
        id: (json['id'] as Object?)?.toStringOrNull(),
        nameKey: json['name'],
        nameAr: json['name_ar'],
        nameEn: json['name_en'],
        color: json['color']);
  }
}
