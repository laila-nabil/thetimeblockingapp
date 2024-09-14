
import 'package:equatable/equatable.dart';

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