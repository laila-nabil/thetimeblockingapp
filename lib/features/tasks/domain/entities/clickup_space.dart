import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_folder.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_list.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';

import '../../../../common/entities/clickup_workspace.dart';
/*
 id : "90150126979"
 name : "Space b"
 color : null
 private : true
 avatar : null
 admin_can_manage : false
 statuses : [{"id":"p90150126979_lIWCjnSr","status":"Open","type":"open","orderindex":0,"color":"#d3d3d3"},{"id":"p90150126979_QMMAZ5BR","status":"in progress","type":"custom","orderindex":1,"color":"#4194f6"},{"id":"p90150126979_th8SqKCT","status":"review","type":"custom","orderindex":2,"color":"#A875FF"},{"id":"p90150126979_oQ5gCLq8","status":"Closed","type":"closed","orderindex":3,"color":"#6bc950"}]
 multiple_assignees : true
 features : {"due_dates":{"enabled":true,"start_date":true,"remap_due_dates":false,"remap_closed_due_date":false},"sprints":{"enabled":false},"time_tracking":{"enabled":true,"harvest":false,"rollup":false},"points":{"enabled":false},"custom_items":{"enabled":false},"priorities":{"enabled":true,"priorities":[{"color":"#f50000","id":"1","orderindex":"1","priority":"urgent"},{"color":"#ffcc00","id":"2","orderindex":"2","priority":"high"},{"color":"#6fddff","id":"3","orderindex":"3","priority":"normal"},{"color":"#d8d8d8","id":"4","orderindex":"4","priority":"low"}]},"tags":{"enabled":true},"check_unresolved":{"enabled":true,"subtasks":null,"checklists":null,"comments":null},"zoom":{"enabled":false},"milestones":{"enabled":false},"custom_fields":{"enabled":true},"dependency_warning":{"enabled":true},"status_pies":{"enabled":false},"multiple_assignees":{"enabled":true}}
 archived : false
 members : [{"user":{"id":61769378,"username":"laila nabil","color":"","profilePicture":null,"initials":"LN"}}]
*/

class ClickupSpace extends Equatable {
  ClickupSpace({
    this.id,
    this.name,
    this.color,
    this.private,
    this.avatar,
    this.adminCanManage,
    this.statuses,
    this.multipleAssignees,
    this.features,
    this.archived,
    this.members,
    this.folders = const[],
    this.lists = const[],
    this.tags = const<ClickupTag>[],
  });

  final String? id;
  final String? name;
  final dynamic color;
  final bool? private;
  final dynamic avatar;
  final bool? adminCanManage;
  final List<ClickupStatus>? statuses;
  final bool? multipleAssignees;
  final ClickupSpaceFeatures? features;
  final bool? archived;
  final List<ClickupWorkspaceMembers>? members;
  List<ClickupFolder> folders;
  List<ClickupList> lists;
  List<ClickupTag> tags;

  @override
  List<Object?> get props => [id,
    name,
    color,
    private,
    avatar,
    adminCanManage,
    statuses,
    multipleAssignees,
    features,
    archived,
    members,
    folders,
    lists,
    tags,
  ];


}

/* due_dates : {"enabled":true,"start_date":true,"remap_due_dates":false,"remap_closed_due_date":false}
 sprints : {"enabled":false}
 time_tracking : {"enabled":true,"harvest":false,"rollup":false}
 points : {"enabled":false}
 custom_items : {"enabled":false}
 priorities : {"enabled":true,"priorities":[{"color":"#f50000","id":"1","orderindex":"1","priority":"urgent"},{"color":"#ffcc00","id":"2","orderindex":"2","priority":"high"},{"color":"#6fddff","id":"3","orderindex":"3","priority":"normal"},{"color":"#d8d8d8","id":"4","orderindex":"4","priority":"low"}]}
 tags : {"enabled":true}
 check_unresolved : {"enabled":true,"subtasks":null,"checklists":null,"comments":null}
 zoom : {"enabled":false}
 milestones : {"enabled":false}
 custom_fields : {"enabled":true}
 dependency_warning : {"enabled":true}
 status_pies : {"enabled":false}
 multiple_assignees : {"enabled":true}*/

class ClickupSpaceFeatures extends Equatable {
  const ClickupSpaceFeatures({
    this.dueDates,
    this.sprints,
    this.timeTracking,
    this.points,
    this.customItems,
    this.priorities,
    this.tags,
    this.checkUnresolved,
    this.zoom,
    this.milestones,
    this.customFields,
    this.dependencyWarning,
    this.statusPies,
    this.multipleAssignees,
  });

  final ClickupSpaceDueDates? dueDates;
  final ClickupSpaceSprints? sprints;
  final ClickupSpaceTimeTracking? timeTracking;
  final ClickupSpacePoints? points;
  final ClickupSpaceCustomItems? customItems;
  final ClickupSpacePriorities? priorities;
  final ClickupSpaceTags? tags;
  final ClickupSpaceCheckUnresolved? checkUnresolved;
  final ClickupSpaceZoom? zoom;
  final ClickupSpaceMilestones? milestones;
  final ClickupSpaceCustomFields? customFields;
  final ClickupSpaceDependencyWarning? dependencyWarning;
  final ClickupSpaceStatusPies? statusPies;
  final ClickupSpaceMultipleAssignees? multipleAssignees;

  @override
  List<Object?> get props => [
        dueDates,
        sprints,
        timeTracking,
        points,
        customItems,
        priorities,
        tags,
        checkUnresolved,
        zoom,
        milestones,
        customFields,
        dependencyWarning,
        statusPies,
        multipleAssignees,
      ];
}

/*enabled : true*/

class ClickupSpaceMultipleAssignees extends Equatable {
  const ClickupSpaceMultipleAssignees({
    this.enabled,
  });

  final bool? enabled;

  @override
  List<Object?> get props => [enabled];
}

/* enabled : false*/

class ClickupSpaceStatusPies extends Equatable {
  const ClickupSpaceStatusPies({
    this.enabled,
  });

  final bool? enabled;

  @override
  List<Object?> get props => [enabled];
}

/* enabled : true*/

class ClickupSpaceDependencyWarning extends Equatable {
  const ClickupSpaceDependencyWarning({
    this.enabled,
  });

  final bool? enabled;

  @override
  List<Object?> get props => [enabled];
}

/* enabled : true*/

class ClickupSpaceCustomFields extends Equatable {
  const ClickupSpaceCustomFields({
    this.enabled,
  });

  final bool? enabled;

  @override
  List<Object?> get props => [enabled];
}

/* enabled : false*/

class ClickupSpaceMilestones extends Equatable {
  const ClickupSpaceMilestones({
    this.enabled,
  });

  final bool? enabled;

  @override
  List<Object?> get props => [enabled];
}

/* enabled : false*/

class ClickupSpaceZoom extends Equatable {
  const ClickupSpaceZoom({
    this.enabled,
  });

  final bool? enabled;

  @override
  List<Object?> get props => [enabled];
}

/*enabled : true
 subtasks : null
 checklists : null
 comments : null*/

class ClickupSpaceCheckUnresolved extends Equatable {
  const ClickupSpaceCheckUnresolved({
    this.enabled,
    this.subtasks,
    this.checklists,
    this.comments,
  });

  final bool? enabled;
  final dynamic subtasks;
  final dynamic checklists;
  final dynamic comments;

  @override
  List<Object?> get props => [
        enabled,
        subtasks,
        checklists,
        comments,
      ];
}

/*enabled : true*/

class ClickupSpaceTags extends Equatable {
  const ClickupSpaceTags({
    this.enabled,
  });

  final bool? enabled;

  @override
  List<Object?> get props => [enabled];
}

/*
 enabled : true
 priorities : [{"color":"#f50000","id":"1","orderindex":"1","priority":"urgent"},{"color":"#ffcc00","id":"2","orderindex":"2","priority":"high"},{"color":"#6fddff","id":"3","orderindex":"3","priority":"normal"},{"color":"#d8d8d8","id":"4","orderindex":"4","priority":"low"}]
*/

class ClickupSpacePriorities extends Equatable {
  const ClickupSpacePriorities({
    this.enabled,
    this.priorities,
  });

  final bool? enabled;
  final List<ClickupTaskPriority>? priorities;

  @override
  List<Object?> get props => [enabled, priorities];
}

/*
 enabled : false
*/

class ClickupSpaceCustomItems extends Equatable {
  const ClickupSpaceCustomItems({
    this.enabled,
  });

  final bool? enabled;

  @override
  List<Object?> get props => [enabled];
}

/*enabled : false*/

class ClickupSpacePoints extends Equatable {
  const ClickupSpacePoints({
    this.enabled,
  });

  final bool? enabled;

  @override
  List<Object?> get props => [enabled];
}

/*enabled : true
 harvest : false
 rollup : false*/

class ClickupSpaceTimeTracking extends Equatable {
  const ClickupSpaceTimeTracking({
    this.enabled,
    this.harvest,
    this.rollup,
  });

  final bool? enabled;
  final bool? harvest;
  final bool? rollup;

  @override
  List<Object?> get props => [enabled, harvest, rollup];
}

/*enabled : false*/

class ClickupSpaceSprints extends Equatable {
  const ClickupSpaceSprints({
    this.enabled,
  });

  final bool? enabled;

  @override
  List<Object?> get props => [enabled];
}

/* enabled : true
 start_date : true
 remap_due_dates : false
 remap_closed_due_date : false*/

class ClickupSpaceDueDates extends Equatable {
  const ClickupSpaceDueDates({
    this.enabled,
    this.startDate,
    this.remapDueDates,
    this.remapClosedDueDate,
  });

  final bool? enabled;
  final bool? startDate;
  final bool? remapDueDates;
  final bool? remapClosedDueDate;

  @override
  List<Object?> get props => [
        enabled,
        startDate,
        remapDueDates,
        remapClosedDueDate,
      ];
}

extension ClickupSpaceListExtensions on List<ClickupSpace>{

  static List<ClickupSpace>? updateItemInList(
      {required List<ClickupSpace>? list,
      required ClickupSpace ? updatedSpace}) {
    printDebug("updateItemInList $list");
    List<ClickupSpace>? result;
    if (list!=null && updatedSpace!=null) {
      result = List.from(list,growable: true);
      final index = list.indexWhere((element) => element.id == updatedSpace.id);
      if(index != -1){
        result.setRange(
            index,
            index,
            Iterable.generate(
              1,
              (index) => updatedSpace,
            ));
      }
    }
    printDebug("updateItemInList $result");
    return result;
  }

}