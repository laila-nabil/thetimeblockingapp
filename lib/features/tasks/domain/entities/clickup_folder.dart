import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_list.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_space.dart';
/*{
  "folders": [
    {
      "id": "90150179192",
      "name": "folder a",
      "orderindex": 2,
      "override_statuses": false,
      "hidden": false,
      "space": {
        "id": "90150126979",
        "name": "Space b"
      },
      "task_count": "1",
      "archived": false,
      "statuses": [],
      "lists": [
        {
          "id": "901500321850",
          "name": "List",
          "orderindex": 0,
          "status": null,
          "priority": null,
          "assignee": null,
          "task_count": 1,
          "due_date": null,
          "start_date": null,
          "space": {
            "id": "90150126979",
            "name": "Space b",
            "access": true
          },
          "archived": false,
          "override_statuses": null,
          "statuses": [
            {
              "id": "p90150126979_lIWCjnSr",
              "status": "Open",
              "orderindex": 0,
              "color": "#d3d3d3",
              "type": "open"
            },
            {
              "id": "p90150126979_QMMAZ5BR",
              "status": "in progress",
              "orderindex": 1,
              "color": "#4194f6",
              "type": "custom"
            },
            {
              "id": "p90150126979_th8SqKCT",
              "status": "review",
              "orderindex": 2,
              "color": "#A875FF",
              "type": "custom"
            },
            {
              "id": "p90150126979_oQ5gCLq8",
              "status": "Closed",
              "orderindex": 3,
              "color": "#6bc950",
              "type": "closed"
            }
          ],
          "permission_level": "create"
        }
      ],
      "permission_level": "create"
    }
  ]
}*/

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

  ClickupFolder copyWith({
    String? id,
    String? name,
    bool? overrideStatuses,
    bool? hidden,
    bool? access,
    ClickupSpace? space,
    String? taskCount,
    List<ClickupList>? lists,
  }) {
    return ClickupFolder(
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