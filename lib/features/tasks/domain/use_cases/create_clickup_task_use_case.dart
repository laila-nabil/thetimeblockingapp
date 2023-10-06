import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';

import '../../../auth/domain/entities/clickup_access_token.dart';
import '../repositories/tasks_repo.dart';

class CreateClickUpTaskUseCase
    implements UseCase<ClickupTask, CreateClickUpTaskParams> {
  final TasksRepo repo;

  CreateClickUpTaskUseCase(this.repo);

  @override
  Future<Either<Failure, ClickupTask>?> call(CreateClickUpTaskParams params) {
    return repo.createTaskInList(params);
  }
}

class CreateClickUpTaskParams {
  final ClickupList clickUpList;
  final String title;
  final String? description;
  final List<ClickupAssignees>? assignees;
  final List<ClickupTag>? tags;
  final ClickupStatus? taskStatus;
  final ClickupTaskPriority? taskPriority;
  final DateTime? dueDate;
  final bool? dueDateTime;
  final Duration? timeEstimate;
  final DateTime? startDate;
  final bool? startDateTime;
  final bool? notifyAll;
  final ClickupTask? parentTask;
  final ClickupTask? linkedTask;
  final bool? requiredCustomFields;
  final ClickUpAccessToken clickUpAccessToken;

  String get listId => clickUpList.id ?? "";

  List<int>? get assigneesId =>
      assignees?.map((e) => e.id?.toInt() ?? 0).toList();

  List<String>? get tagsNames => tags?.map((e) => e.name ?? "").toList();

  int? get priority => taskPriority?.getPriorityNum;

  String? get status => taskStatus?.status;

  int? get dueDateMillisecondsSinceEpoch => dueDate?.millisecondsSinceEpoch;

  int? get startDateMillisecondsSinceEpoch => startDate?.millisecondsSinceEpoch;

  int? get timeEstimateMilliseconds =>
      timeEstimate?.inMilliseconds;

  String? get parentTaskId => parentTask?.id;

  String? get linkedTaskId => linkedTask?.id;

  Map<String, dynamic> toJson() {
    return {
      "name": title,
      "description": description,
      "assignees": assigneesId,
      "tags": tagsNames,
      "status": status,
      "priority": priority,
      "due_date": dueDateMillisecondsSinceEpoch,
      "due_date_time": dueDateTime,
      "time_estimate": timeEstimateMilliseconds,
      "start_date": startDateMillisecondsSinceEpoch,
      "start_date_time": startDateMillisecondsSinceEpoch,
      "notify_all": notifyAll,
      "parent": parentTaskId,
      "links_to": linkedTaskId,
      // "custom_fields": [
      //   {"id": "0a52c486-5f05-403b-b4fd-c512ff05131c", "value": 23},
      //   {
      //     "id": "03efda77-c7a0-42d3-8afd-fd546353c2f5",
      //     "value": "Text field input"
      //   }
      // ]
    };
  }

  CreateClickUpTaskParams(
      {required this.clickUpList,
      required this.title,
      required this.clickUpAccessToken,
      this.description,
      this.assignees,
      this.tags,
      this.taskStatus,
      this.taskPriority,
      this.dueDate,
      this.dueDateTime,
      this.timeEstimate,
      this.startDate,
      this.startDateTime,
      this.notifyAll,
      this.parentTask,
      this.linkedTask,
      this.requiredCustomFields});
}
