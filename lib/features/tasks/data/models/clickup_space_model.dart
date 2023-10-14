import 'package:thetimeblockingapp/common/models/clickup_workspace_model.dart';
import 'package:thetimeblockingapp/features/tasks/data/models/clickup_task_model.dart';
import '../../domain/entities/clickup_space.dart';
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

class ClickupSpaceModel extends ClickupSpace {
  ClickupSpaceModel({
    super.id,
    super.name,
    super.color,
    super.private,
    super.avatar,
    super.adminCanManage,
    super.statuses,
    super.multipleAssignees,
    super.features,
    super.archived,
    super.members,
  });

  factory ClickupSpaceModel.fromJson(dynamic json) {
    String? id = json['id'];
    String? name = json['name'];
    dynamic color = json['color'];
    bool? private = json['private'];
    dynamic avatar = json['avatar'];
    bool? adminCanManage = json['admin_can_manage'];
    List<ClickupSpaceStatusesModel>? statuses;
    if (json['statuses'] != null) {
      statuses = [];
      json['statuses'].forEach((v) {
        statuses?.add(ClickupSpaceStatusesModel.fromJson(v));
      });
    }
    bool? multipleAssignees = json['multiple_assignees'];
    ClickupSpaceFeaturesModel? features = json['features'] != null
        ? ClickupSpaceFeaturesModel.fromJson(json['features'])
        : null;
    bool? archived = json['archived'];
    List<ClickupWorkspaceMembersModel>? members;
    if (json['members'] != null) {
      members = [];
      json['members'].forEach((v) {
        members?.add(ClickupWorkspaceMembersModel.fromJson(v));
      });
    }
    return ClickupSpaceModel(
        id: id,
        color: color,
        name: name,
        members: members,
        avatar: avatar,
        adminCanManage: adminCanManage,
        archived: archived,
        features: features,
        multipleAssignees: multipleAssignees,
        private: private,
        statuses: statuses);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['color'] = color;
    map['private'] = private;
    map['avatar'] = avatar;
    map['admin_can_manage'] = adminCanManage;
    if (statuses != null) {
      map['statuses'] = statuses
          ?.map((v) => (v as ClickupSpaceStatusesModel).toJson())
          .toList();
    }
    map['multiple_assignees'] = multipleAssignees;
    if (features != null) {
      map['features'] = (features as ClickupSpaceFeaturesModel).toJson();
    }
    map['archived'] = archived;
    if (members != null) {
      map['members'] = members
          ?.map((v) => (v as ClickupWorkspaceMembersModel).toJson())
          .toList();
    }
    return map;
  }
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

class ClickupSpaceFeaturesModel extends ClickupSpaceFeatures {
  const ClickupSpaceFeaturesModel({
    super.dueDates,
    super.sprints,
    super.timeTracking,
    super.points,
    super.customItems,
    super.priorities,
    super.tags,
    super.checkUnresolved,
    super.zoom,
    super.milestones,
    super.customFields,
    super.dependencyWarning,
    super.statusPies,
    super.multipleAssignees,
  });

  factory ClickupSpaceFeaturesModel.fromJson(dynamic json) {
    ClickupSpaceDueDatesModel? dueDates = json['due_dates'] != null
        ? ClickupSpaceDueDatesModel.fromJson(json['due_dates'])
        : null;
    ClickupSpaceSprintsModel? sprints = json['sprints'] != null
        ? ClickupSpaceSprintsModel.fromJson(json['sprints'])
        : null;
    ClickupSpaceTimeTrackingModel? timeTracking = json['time_tracking'] != null
        ? ClickupSpaceTimeTrackingModel.fromJson(json['time_tracking'])
        : null;
    ClickupSpacePointsModel? points = json['points'] != null
        ? ClickupSpacePointsModel.fromJson(json['points'])
        : null;
    ClickupSpaceCustomItemsModel? customItems = json['custom_items'] != null
        ? ClickupSpaceCustomItemsModel.fromJson(json['custom_items'])
        : null;
    ClickupSpacePrioritiesModel? priorities = json['priorities'] != null
        ? ClickupSpacePrioritiesModel.fromJson(json['priorities'])
        : null;
    ClickupSpaceTagsModel? tags = json['tags'] != null
        ? ClickupSpaceTagsModel.fromJson(json['tags'])
        : null;
    ClickupSpaceCheckUnresolvedModel? checkUnresolved =
        json['check_unresolved'] != null
            ? ClickupSpaceCheckUnresolvedModel.fromJson(
                json['check_unresolved'])
            : null;
    ClickupSpaceZoomModel? zoom = json['zoom'] != null
        ? ClickupSpaceZoomModel.fromJson(json['zoom'])
        : null;
    ClickupSpaceMilestonesModel? milestones = json['milestones'] != null
        ? ClickupSpaceMilestonesModel.fromJson(json['milestones'])
        : null;
    ClickupSpaceCustomFieldsModel? customFields = json['custom_fields'] != null
        ? ClickupSpaceCustomFieldsModel.fromJson(json['custom_fields'])
        : null;
    ClickupSpaceDependencyWarningModel? dependencyWarning =
        json['dependency_warning'] != null
            ? ClickupSpaceDependencyWarningModel.fromJson(
                json['dependency_warning'])
            : null;
    ClickupSpaceStatusPiesModel? statusPies = json['status_pies'] != null
        ? ClickupSpaceStatusPiesModel.fromJson(json['status_pies'])
        : null;
    ClickupSpaceMultipleAssigneesModel? multipleAssignees =
        json['multiple_assignees'] != null
            ? ClickupSpaceMultipleAssigneesModel.fromJson(
                json['multiple_assignees'])
            : null;
    return ClickupSpaceFeaturesModel(
      dueDates: dueDates,
      sprints: sprints,
      timeTracking: timeTracking,
      points: points,
      customItems: customItems,
      priorities: priorities,
      tags: tags,
      checkUnresolved: checkUnresolved,
      zoom: zoom,
      milestones: milestones,
      customFields: customFields,
      dependencyWarning: dependencyWarning,
      statusPies: statusPies,
      multipleAssignees: multipleAssignees,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (dueDates != null) {
      map['due_dates'] = (dueDates as ClickupSpaceDueDatesModel).toJson();
    }
    if (sprints != null) {
      map['sprints'] = (sprints as ClickupSpaceSprintsModel).toJson();
    }
    if (timeTracking != null) {
      map['time_tracking'] =
          (timeTracking as ClickupSpaceTimeTrackingModel).toJson();
    }
    if (points != null) {
      map['points'] = (points as ClickupSpacePointsModel).toJson();
    }
    if (customItems != null) {
      map['custom_items'] =
          (customItems as ClickupSpaceCustomItemsModel).toJson();
    }
    if (priorities != null) {
      map['priorities'] = (priorities as ClickupSpacePrioritiesModel).toJson();
    }
    if (tags != null) {
      map['tags'] = (tags as ClickupSpaceTagsModel).toJson();
    }
    if (checkUnresolved != null) {
      map['check_unresolved'] =
          (checkUnresolved as ClickupSpaceCheckUnresolvedModel).toJson();
    }
    if (zoom != null) {
      map['zoom'] = (zoom as ClickupSpaceZoomModel).toJson();
    }
    if (milestones != null) {
      map['milestones'] = (milestones as ClickupSpaceMilestonesModel).toJson();
    }
    if (customFields != null) {
      map['custom_fields'] =
          (customFields as ClickupSpaceCustomFieldsModel).toJson();
    }
    if (dependencyWarning != null) {
      map['dependency_warning'] =
          (dependencyWarning as ClickupSpaceDependencyWarningModel).toJson();
    }
    if (statusPies != null) {
      map['status_pies'] = (statusPies as ClickupSpaceStatusPiesModel).toJson();
    }
    if (multipleAssignees != null) {
      map['multiple_assignees'] =
          (multipleAssignees as ClickupSpaceMultipleAssigneesModel).toJson();
    }
    return map;
  }
}

/*enabled : true*/

class ClickupSpaceMultipleAssigneesModel extends ClickupSpaceMultipleAssignees {
  const ClickupSpaceMultipleAssigneesModel({
    super.enabled,
  });

  factory ClickupSpaceMultipleAssigneesModel.fromJson(dynamic json) {
    return ClickupSpaceMultipleAssigneesModel(enabled: json['enabled']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['enabled'] = enabled;
    return map;
  }
}

/* enabled : false*/

class ClickupSpaceStatusPiesModel extends ClickupSpaceStatusPies {
  const ClickupSpaceStatusPiesModel({
    super.enabled,
  });

  factory ClickupSpaceStatusPiesModel.fromJson(dynamic json) {
    return ClickupSpaceStatusPiesModel(enabled: json['enabled']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['enabled'] = enabled;
    return map;
  }
}

/* enabled : true*/

class ClickupSpaceDependencyWarningModel extends ClickupSpaceDependencyWarning {
  const ClickupSpaceDependencyWarningModel({
    super.enabled,
  });

  factory ClickupSpaceDependencyWarningModel.fromJson(dynamic json) {
    return ClickupSpaceDependencyWarningModel(enabled: json['enabled']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['enabled'] = enabled;
    return map;
  }
}

/* enabled : true*/

class ClickupSpaceCustomFieldsModel extends ClickupSpaceCustomFields {
  const ClickupSpaceCustomFieldsModel({
    super.enabled,
  });

  factory ClickupSpaceCustomFieldsModel.fromJson(dynamic json) {
    return ClickupSpaceCustomFieldsModel(enabled: json['enabled']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['enabled'] = enabled;
    return map;
  }
}

/* enabled : false*/

class ClickupSpaceMilestonesModel extends ClickupSpaceMilestones {
  const ClickupSpaceMilestonesModel({
    super.enabled,
  });

  factory ClickupSpaceMilestonesModel.fromJson(dynamic json) {
    return ClickupSpaceMilestonesModel(enabled: json['enabled']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['enabled'] = enabled;
    return map;
  }
}

/* enabled : false*/

class ClickupSpaceZoomModel extends ClickupSpaceZoom {
  const ClickupSpaceZoomModel({
    super.enabled,
  });

  factory ClickupSpaceZoomModel.fromJson(dynamic json) {
    return ClickupSpaceZoomModel(enabled: json['enabled']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['enabled'] = enabled;
    return map;
  }
}

/*enabled : true
 subtasks : null
 checklists : null
 comments : null*/

class ClickupSpaceCheckUnresolvedModel extends ClickupSpaceCheckUnresolved {
  const ClickupSpaceCheckUnresolvedModel({
    super.enabled,
    super.subtasks,
    super.checklists,
    super.comments,
  });

  factory ClickupSpaceCheckUnresolvedModel.fromJson(dynamic json) {
    return ClickupSpaceCheckUnresolvedModel(
      enabled: json['enabled'],
      subtasks: json['subtasks'],
      checklists: json['checklists'],
      comments: json['comments'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['enabled'] = enabled;
    map['subtasks'] = subtasks;
    map['checklists'] = checklists;
    map['comments'] = comments;
    return map;
  }
}

/*enabled : true*/

class ClickupSpaceTagsModel extends ClickupSpaceTags {
  const ClickupSpaceTagsModel({
    super.enabled,
  });

  factory ClickupSpaceTagsModel.fromJson(dynamic json) {
    return ClickupSpaceTagsModel(enabled: json['enabled']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['enabled'] = enabled;
    return map;
  }
}

/*
 enabled : true
 priorities : [{"color":"#f50000","id":"1","orderindex":"1","priority":"urgent"},{"color":"#ffcc00","id":"2","orderindex":"2","priority":"high"},{"color":"#6fddff","id":"3","orderindex":"3","priority":"normal"},{"color":"#d8d8d8","id":"4","orderindex":"4","priority":"low"}]
*/

class ClickupSpacePrioritiesModel extends ClickupSpacePriorities {
  const ClickupSpacePrioritiesModel({
    super.enabled,
    super.priorities,
  });

  factory ClickupSpacePrioritiesModel.fromJson(dynamic json) {
    bool? enabled = json['enabled'];
    List<ClickupTaskPriorityModel>? priorities;
    if (json['priorities'] != null) {
      priorities = [];
      json['priorities'].forEach((v) {
        priorities?.add(ClickupTaskPriorityModel.fromJson(v)!);
      });
    }
    return ClickupSpacePrioritiesModel(
        enabled: enabled, priorities: priorities);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['enabled'] = enabled;
    if (priorities != null) {
      map['priorities'] = priorities
          ?.map((v) => (v as ClickupTaskPriorityModel).toJson())
          .toList();
    }
    return map;
  }
}

/*
 enabled : false
*/

class ClickupSpaceCustomItemsModel extends ClickupSpaceCustomItems {
  const ClickupSpaceCustomItemsModel({
    super.enabled,
  });

  factory ClickupSpaceCustomItemsModel.fromJson(dynamic json) {
    return ClickupSpaceCustomItemsModel(enabled: json['enabled']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['enabled'] = enabled;
    return map;
  }
}

/*enabled : false*/

class ClickupSpacePointsModel extends ClickupSpacePoints {
  const ClickupSpacePointsModel({
    super.enabled,
  });

  factory ClickupSpacePointsModel.fromJson(dynamic json) {
    return ClickupSpacePointsModel(enabled: json['enabled']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['enabled'] = enabled;
    return map;
  }
}

/*enabled : true
 harvest : false
 rollup : false*/

class ClickupSpaceTimeTrackingModel extends ClickupSpaceTimeTracking {
  const ClickupSpaceTimeTrackingModel({
    super.enabled,
    super.harvest,
    super.rollup,
  });

  factory ClickupSpaceTimeTrackingModel.fromJson(dynamic json) {
    return ClickupSpaceTimeTrackingModel(
        enabled: json['enabled'],
        harvest: json['harvest'],
        rollup: json['rollup']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['enabled'] = enabled;
    map['harvest'] = harvest;
    map['rollup'] = rollup;
    return map;
  }
}

/*enabled : false*/

class ClickupSpaceSprintsModel extends ClickupSpaceSprints {
  const ClickupSpaceSprintsModel({
    super.enabled,
  });

  factory ClickupSpaceSprintsModel.fromJson(dynamic json) {
    return ClickupSpaceSprintsModel(enabled: json['enabled']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['enabled'] = enabled;
    return map;
  }
}

/* enabled : true
 start_date : true
 remap_due_dates : false
 remap_closed_due_date : false*/

class ClickupSpaceDueDatesModel extends ClickupSpaceDueDates {
  const ClickupSpaceDueDatesModel({
    super.enabled,
    super.startDate,
    super.remapDueDates,
    super.remapClosedDueDate,
  });

  factory ClickupSpaceDueDatesModel.fromJson(dynamic json) {
    return ClickupSpaceDueDatesModel(
      enabled: json['enabled'],
      startDate: json['start_date'],
      remapDueDates: json['remap_due_dates'],
      remapClosedDueDate: json['remap_closed_due_date'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['enabled'] = enabled;
    map['start_date'] = startDate;
    map['remap_due_dates'] = remapDueDates;
    map['remap_closed_due_date'] = remapClosedDueDate;
    return map;
  }
}

/* id : "p90150126979_lIWCjnSr"
 status : "Open"
 type : "open"
 orderindex : 0
 color : "#d3d3d3"*/

class ClickupSpaceStatusesModel extends ClickupSpaceStatuses {
  const ClickupSpaceStatusesModel({
    super.id,
    super.status,
    super.type,
    super.color,
  });

  factory ClickupSpaceStatusesModel.fromJson(dynamic json) {
    return ClickupSpaceStatusesModel(
      id: json['id'],
      status: json['status'],
      type: json['type'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['status'] = status;
    map['type'] = type;
    map['color'] = color;
    return map;
  }
}
