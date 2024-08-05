import '../entities/tasks_list.dart';

/// id : "1"
/// name : "List"
/// access : true

class ClickupListModel extends TasksList {
  const ClickupListModel({
    super.id,
    super.name,
    super.access,
  });

  factory ClickupListModel.fromJson(Map<String, dynamic> json) {
    return ClickupListModel(
      id: json['id'],
      name: json['name'],
      access: json['access'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['access'] = access;
    return map;
  }
}