import 'package:equatable/equatable.dart';

import 'tasks_list.dart';

class Folder extends Equatable{
  const Folder({
      this.id, 
      this.name,
      this.color,
      this.lists,});

  final String? id;
  final String? name;
  final String? color;
  final List<TasksList>? lists;


  @override
  List<Object?> get props => [id,
    name];

  Folder copyWith({
    String? id,
    String? name,
    String? color,
    List<TasksList>? lists,
  }) {
    return Folder(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      lists: lists ?? this.lists,
    );
  }
}