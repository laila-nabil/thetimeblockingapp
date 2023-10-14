
import 'package:equatable/equatable.dart';

/*{
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
        }*/

class ClickupList extends Equatable {
  const ClickupList({
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