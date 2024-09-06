
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';

class TasksList extends Equatable {
  const TasksList({
    this.id,
    this.name,
  });

  final String? id;
  final String? name;

  @override
  List<Object?> get props => [
    id,
    name,
  ];
}