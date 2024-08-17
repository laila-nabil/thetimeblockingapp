import 'package:thetimeblockingapp/common/models/supabase_task_model.dart';
import 'package:thetimeblockingapp/core/extensions.dart';

import '../entities/tasks_list.dart';


List<ListModel>? listsFromJson(json){
  if(json != null && json is List){
    List<ListModel> list = [];
    for (var v in json) {
      list.add(ListModel.fromJson(v));
    }
    return list;
  }
  return null;
}
extension ListsExt on List<ListModel>?{
  List<Map<String, dynamic>>? toJson() {
    if(this == null){
      return null;
    }
    return this?.map((v) => (v).toJson()).toList();
  }
}

class ListModel extends TasksList {
  const ListModel({
    super.id,
    super.name,
    super.tasks,
  });


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['tasks'] = (tasks as List<TaskModel>).toJson();
    return map;
  }


  factory ListModel.fromJson(dynamic json) {
    return ListModel(
        id: (json['id']as Object?)?.toStringOrNull(),
        name: json['name'],
        tasks: tasksFromJson(json['tasks']),
    );
  }
}