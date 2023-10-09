import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_space.dart';
/// id : "457"
/// name : "Updated Folder Name"
/// orderindex : 0
/// override_statuses : false
/// hidden : false
/// space : {"id":"789","name":"Space Name","access":true}
/// task_count : "0"
/// lists : []


/// id : "1"
/// name : "Folder"
/// hidden : false
/// access : true

class ClickupFolder extends Equatable{
  const ClickupFolder({
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
  final ClickupSpace? space;
  final String? taskCount;
  final List<String>? lists;


  @override
  List<Object?> get props => [id,
    name,
    overrideStatuses,
    access,
    hidden,
    space,
    taskCount,
    lists,];

}