import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/list.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/space.dart';

class Folder extends Equatable{
  const Folder({
      this.id, 
      this.name, 
      this.overrideStatuses,
      this.hidden, 
      this.access,
      this.space,
      this.taskCount, 
      this.lists,});

  final String? id;
  final String? name;
  final bool? overrideStatuses;
  final bool? hidden;
  final bool? access;
  final Space? space;
  final String? taskCount;
  final List<ClickupList>? lists;


  @override
  List<Object?> get props => [id,
    name,
    overrideStatuses,
    access,
    hidden,
    space,
    taskCount,
    lists,];

  Folder copyWith({
    String? id,
    String? name,
    bool? overrideStatuses,
    bool? hidden,
    bool? access,
    Space? space,
    String? taskCount,
    List<ClickupList>? lists,
  }) {
    return Folder(
      id: id ?? this.id,
      name: name ?? this.name,
      overrideStatuses: overrideStatuses ?? this.overrideStatuses,
      hidden: hidden ?? this.hidden,
      access: access ?? this.access,
      space: space ?? this.space,
      taskCount: taskCount ?? this.taskCount,
      lists: lists ?? this.lists,
    );
  }
}