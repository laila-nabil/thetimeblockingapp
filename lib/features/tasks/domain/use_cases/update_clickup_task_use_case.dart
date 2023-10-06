import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';

import '../../../auth/domain/entities/clickup_access_token.dart';
import '../repositories/tasks_repo.dart';

class UpdateClickUpTaskUseCase
    implements UseCase<ClickupTask, UpdateClickUpTaskParams> {
  final TasksRepo repo;

  UpdateClickUpTaskUseCase(this.repo);

  @override
  Future<Either<Failure, ClickupTask>?> call(UpdateClickUpTaskParams params) {
    return repo.updateTask(params);
  }
}

class UpdateClickUpTaskParams {
  final ClickupTask task;
  final String? title;
  final String? description;
  final List<ClickupAssignees>? addedAssignees;
  final List<ClickupAssignees>? removedAssignees;
  final List<ClickupTag>? tags;
  final ClickupStatus? taskStatus;
  final ClickupTaskPriority? taskPriority;
  final DateTime? dueDate;
  final bool? dueDateTime;
  final Duration? timeEstimate;
  final DateTime? startDate;
  final bool? startDateTime;
  final bool? archived;
  final ClickupTask? parentTask;
  final ClickUpAccessToken clickUpAccessToken;

  String get taskId => task.id ?? "";

  List<int>? get addedAssigneesId =>
      addedAssignees?.map((e) => e.id?.toInt() ?? 0).toList();

  List<int>? get removedAssigneesId =>
      removedAssignees?.map((e) => e.id?.toInt() ?? 0).toList();

  List<String>? get tagsNames => tags?.map((e) => e.name ?? "").toList();

  int? get priority => taskPriority?.getPriorityNum;

  String? get status => taskStatus?.status;

  int? get dueDateMillisecondsSinceEpoch => dueDate?.millisecondsSinceEpoch;

  int? get startDateMillisecondsSinceEpoch => startDate?.millisecondsSinceEpoch;

  int? get timeEstimateMilliseconds =>
      timeEstimate?.inMilliseconds;

  String? get parentTaskId => parentTask?.id;

  Map<String, dynamic> get assignees {
    Map<String, dynamic> result = {};
    if (addedAssigneesId?.isNotEmpty == true) {
      result["add"] = addedAssigneesId;
    }
    if (removedAssigneesId?.isNotEmpty == true) {
      result["rem"] = removedAssigneesId;
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    return {
      "name": title,
      "description": description?.isEmpty == true ? " " : description, //To clear the task description, include Description with " "
      "assignees": assignees,
      "tags": tagsNames,
      "status": status,
      "priority": priority,
      "due_date": dueDateMillisecondsSinceEpoch,
      "due_date_time": dueDateTime,
      "time_estimate": timeEstimateMilliseconds,
      "start_date": startDateMillisecondsSinceEpoch,
      "start_date_time": startDateMillisecondsSinceEpoch,
      "archived": archived,
      "parent": parentTaskId,
    };
  }

  UpdateClickUpTaskParams({
    required this.task,
    this.title,
    required this.clickUpAccessToken,
    this.description,
    this.addedAssignees,
    this.removedAssignees,
    this.tags,
    this.taskStatus,
    this.taskPriority,
    this.dueDate,
    this.dueDateTime,
    this.timeEstimate,
    this.startDate,
    this.startDateTime,
    this.archived,
    this.parentTask,
  });
}
