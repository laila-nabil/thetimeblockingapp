import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/priority.dart';
import 'package:thetimeblockingapp/common/entities/status.dart';
import 'tag.dart';

class TaskEntity extends Equatable {
  final String? id;
  final String? title;
  final String? description;
  final TaskStatus? status;
  final TaskPriority? priority;
  final List<Tag> tags;

  const TaskEntity(
      {required this.id,
      required this.title,
      required this.description,
      required this.status,
      required this.priority,
      required this.tags});

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        status,
        priority,
        tags,
      ];

}
