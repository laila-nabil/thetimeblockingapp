
import 'package:equatable/equatable.dart';

class TasksList extends Equatable {
  const TasksList({
    this.id,
    this.name,
    this.access,
  });

  final String? id;
  final String? name;
  final bool? access;

  @override
  List<Object?> get props => [
    id,
    name,
    access,
  ];
}