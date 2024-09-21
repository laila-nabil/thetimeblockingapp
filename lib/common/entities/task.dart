import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/folder.dart';
import 'package:thetimeblockingapp/common/entities/priority.dart';
import 'package:thetimeblockingapp/common/entities/status.dart';
import 'package:thetimeblockingapp/common/entities/tasks_list.dart';
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'tag.dart';

class Task extends Equatable {
  final String? id;
  final String? title;
  final String? description;
  final TaskStatus? status;
  final TaskPriority? priority;
  final List<Tag> tags;
  final DateTime? startDate;
  final DateTime? dueDate;
  final TasksList? list;
  final Folder? folder;
  final Workspace? workspace;

  bool get isOverdue =>
      dueDate?.isBefore(DateTime.now()) == true && isCompleted == false;

  bool get isUpcoming => dueDate?.isAfter(DateTime.now()) == true;

  bool get isUnscheduled => dueDate == null && isCompleted == false;

  bool get isCompleted => status?.isDone == true;

  bool get isAllDay =>
      dueDate != null &&
      startDate != null &&
      dueDate!.hour == 24 &&
      startDate!.hour == 0;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.tags,
    required this.startDate,
    required this.dueDate,
    required this.list,
    required this.folder,
    required this.workspace,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        status,
        priority,
        tags,
        startDate,
        dueDate,
        folder,
        workspace,
      ];

  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    List<Tag>? tags,
    DateTime? startDate,
    DateTime? dueDate,
    TasksList? list,
    Folder? folder,
    Workspace? workspace,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      list: list ?? this.list,
      folder: folder ?? this.folder,
      workspace: workspace ?? this.workspace,
    );
  }
}
