import '../entities/tasks_list.dart';

class ListModel extends TasksList {
  const ListModel({
    super.id,
    super.name,
  });


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }


  factory ListModel.fromJson(dynamic json) {
    return ListModel(
        id: json['id'],
        name: json['name'],
    );
  }
}