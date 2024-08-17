
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';

class TasksList extends Equatable {
  const TasksList({
    this.id,
    this.name,
    this.tasks,
  });

  final String? id;
  final String? name;
  final List<Task>? tasks;

  @override
  List<Object?> get props => [
    id,
    name,
    tasks
  ];
}