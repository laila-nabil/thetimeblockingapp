import 'package:equatable/equatable.dart';

import 'folder.dart';
import 'tag.dart';
import 'tasks_list.dart';

class Workspace extends Equatable {
  const Workspace({
    this.id,
    this.name,
    this.color,
    this.userId,
    this.folders,
    this.lists,
    this.tags,
  });

  final int? id;
  final String? name;
  final String? color;
  final String? userId;
  final List<Folder>? folders;
  final List<TasksList>? lists;
  final List<Tag>? tags;

  @override
  List<Object?> get props => [
        id,
        name,
        color,
        userId,
        folders,
        lists,
        tags
      ];
}