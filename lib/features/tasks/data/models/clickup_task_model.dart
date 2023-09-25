import '../../domain/entities/clickup_task.dart';

/// id : "av1"
/// custom_id : null
/// name : "My First Task"
/// text_content : "Task description"
/// description : "Task description"
/// status : {"status":"Open","type":"open","orderindex":1,"color":"#000000"}
/// orderindex : "1.0000"
/// date_created : "1508369194377"
/// date_updated : "1508369194377"
/// date_closed : "1508369194377"
/// date_done : "1508369194377"
/// creator : {"id":123,"username":"John Doe","color":"#000000","email":"johndoe@website.com","profilePicture":"https://clickup.com/avatar.jpg"}
/// assignees : [{"id":123,"username":"John Doe","color":"#000000","email":"johndoe@website.com","profilePicture":"https://clickup.com/avatar.jpg"}]
/// watchers : [{"id":123,"username":"John Doe","color":"#000000","email":"johndoe@website.com","profilePicture":"https://clickup.com/avatar.jpg"}]
/// checklists : [{"id":"d41340bc-2f17-43cc-ae71-86628f45825f","task_id":"3cxv9f","name":"Checklist","date_created":"1618455803730","orderindex":1,"creator":2770032,"resolved":0,"unresolved":1,"items":[{"id":"9398cb3d-55a4-4c45-ab46-2a47a371e375","name":"checklist item 1","orderindex":0,"assignee":null,"resolved":false,"parent":null,"date_created":"1618455810454","children":[]}]}]
/// tags : [{"name":"tagged","tag_fg":"#000000","tag_bg":"#000000"}]
/// parent : "av2"
/// priority : 1
/// due_date : "1508369194377"
/// start_date : "1508369194377"
/// points : 1.3
/// time_estimate : 1.2
/// custom_fields : [{"id":"be43f58e-989e-4233-9f25-27584f094b74","name":"Location type Custom Field","type":"location","type_config":{},"date_created":"1617765143523","hide_from_guests":false,"required":false}]
/// dependencies : []
/// linked_tasks : []
/// team_id : "1234"
/// url : "https://app.clickup.com/t/av1"
/// permission_level : "create"
/// list : {"id":"1","name":"List","access":true}
/// project : {"id":"1","name":"Folder","hidden":false,"access":true}
/// folder : {"id":"1","name":"Folder","hidden":false,"access":true}
/// space : {"id":"1"}

class ClickupTaskModel extends ClickupTask {
  const ClickupTaskModel({
    super.id,
    super.customId,
    super.name,
    super.textContent,
    super.description,
    super.status,
    super.orderIndex,
    super.dateCreated,
    super.dateUpdated,
    super.dateClosed,
    super.dateDone,
    super.creator,
    super.assignees,
    super.watchers,
    super.checklists,
    super.tags,
    super.parent,
    super.priority,
    super.dueDate,
    super.startDate,
    super.points,
    super.timeEstimate,
    super.customFields,
    super.dependencies,
    super.linkedTasks,
    super.teamId,
    super.url,
    super.permissionLevel,
    super.list,
    super.project,
    super.folder,
    super.space,
  });

  factory ClickupTaskModel.fromJson(dynamic json) {
    String? id = json['id'];
    String? customId = json['custom_id'];
    String? name = json['name'];
    String? textContent = json['text_content'];
    String? description = json['description'];
    ClickupStatusModel? status = json['status'] != null
        ? ClickupStatusModel.fromJson(json['status'])
        : null;
    String? orderIndex = json['orderindex'];
    String? dateCreated = json['date_created'];
    String? dateUpdated = json['date_updated'];
    String? dateClosed = json['date_closed'];
    String? dateDone = json['date_done'];
    ClickupCreatorModel? creator = json['creator'] != null
        ? ClickupCreatorModel.fromJson(json['creator'])
        : null;
    List<ClickupAssigneesModel>? assignees;
    if (json['assignees'] != null) {
      assignees = [];
      json['assignees'].forEach((v) {
        assignees?.add(ClickupAssigneesModel.fromJson(v));
      });
    }
    List<ClickupWatchersModel>? watchers;
    if (json['watchers'] != null) {
      watchers = [];
      json['watchers'].forEach((v) {
        watchers?.add(ClickupWatchersModel.fromJson(v));
      });
    }
    List<ClickupChecklistsModel>? checklists;
    if (json['checklists'] != null) {
      checklists = [];
      json['checklists'].forEach((v) {
        checklists?.add(ClickupChecklistsModel.fromJson(v));
      });
    }
    List<ClickupTagsModel>? tags;
    if (json['tags'] != null) {
      tags = [];
      json['tags'].forEach((v) {
        tags?.add(ClickupTagsModel.fromJson(v));
      });
    }
    String? parent = json['parent'];
    num? priority = json['priority'];
    String? dueDate = json['due_date'];
    String? startDate = json['start_date'];
    num? points = json['points'];
    num? timeEstimate = json['time_estimate'];
    List<ClickupCustomFieldsModel>? customFields;
    if (json['custom_fields'] != null) {
      customFields = [];
      json['custom_fields'].forEach((v) {
        customFields?.add(ClickupCustomFieldsModel.fromJson(v));
      });
    }
    List<String>? dependencies;
    if (json['dependencies'] != null) {
      dependencies = [];
      json['dependencies'].forEach((v) {
        dependencies?.add(v);
      });
    }
    List<String>? linkedTasks;
    if (json['linked_tasks'] != null) {
      linkedTasks = [];
      json['linked_tasks'].forEach((v) {
        linkedTasks?.add(v);
      });
    }
    String? teamId = json['team_id'];
    String? url = json['url'];
    String? permissionLevel = json['permission_level'];
    ClickupList? list =
        json['list'] != null ? ClickupListModel.fromJson(json['list']) : null;
    ClickupProjectModel? project = json['project'] != null
        ? ClickupProjectModel.fromJson(json['project'])
        : null;
    ClickupFolderModel? folder = json['folder'] != null
        ? ClickupFolderModel.fromJson(json['folder'])
        : null;
    ClickupSpaceModel? space = json['space'] != null
        ? ClickupSpaceModel.fromJson(json['space'])
        : null;

    return ClickupTaskModel(
        name: name,
        id: id,
        description: description,
        assignees: assignees,
        checklists: checklists,
        creator: creator,
        customFields: customFields,
        customId: customId,
        dateClosed: dateClosed,
        dateCreated: dateCreated,
        dateDone: dateDone,
        dateUpdated: dateUpdated,
        dependencies: dependencies,
        dueDate: dueDate,
        folder: folder,
        linkedTasks: linkedTasks,
        list: list,
        orderIndex: orderIndex,
        parent: parent,
        permissionLevel: permissionLevel,
        points: points,
        priority: priority,
        project: project,
        space: space,
        startDate: startDate,
        status: status,
        tags: tags,
        teamId: teamId,
        textContent: textContent,
        timeEstimate: timeEstimate,
        url: url,
        watchers: watchers);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['custom_id'] = customId;
    map['name'] = name;
    map['text_content'] = textContent;
    map['description'] = description;
    if (status != null) {
      map['status'] = (status as ClickupStatusModel).toJson();
    }
    map['orderindex'] = orderIndex;
    map['date_created'] = dateCreated;
    map['date_updated'] = dateUpdated;
    map['date_closed'] = dateClosed;
    map['date_done'] = dateDone;
    if (creator != null) {
      map['creator'] = (creator as ClickupCreatorModel).toJson();
    }
    if (assignees != null) {
      map['assignees'] =
          assignees?.map((v) => (v as ClickupAssigneesModel).toJson()).toList();
    }
    if (watchers != null) {
      map['watchers'] =
          watchers?.map((v) => (v as ClickupWatchersModel).toJson()).toList();
    }
    if (checklists != null) {
      map['checklists'] = checklists
          ?.map((v) => (v as ClickupChecklistsModel).toJson())
          .toList();
    }
    if (tags != null) {
      map['tags'] = tags?.map((v) => (v as ClickupTagsModel).toJson()).toList();
    }
    map['parent'] = parent;
    map['priority'] = priority;
    map['due_date'] = dueDate;
    map['start_date'] = startDate;
    map['points'] = points;
    map['time_estimate'] = timeEstimate;
    if (customFields != null) {
      map['custom_fields'] = customFields
          ?.map((v) => (v as ClickupCustomFieldsModel).toJson())
          .toList();
    }
    if (dependencies != null) {
      map['dependencies'] = dependencies;
    }
    if (linkedTasks != null) {
      map['linked_tasks'] = linkedTasks;
    }
    map['team_id'] = teamId;
    map['url'] = url;
    map['permission_level'] = permissionLevel;
    map['list'] = list;
    if (project != null) {
      map['project'] = (project as ClickupProjectModel).toJson();
    }
    if (folder != null) {
      map['folder'] = (folder as ClickupFolderModel).toJson();
    }
    if (space != null) {
      map['space'] = (space as ClickupSpaceModel).toJson();
    }
    return map;
  }
}

/// id : "1"

class ClickupSpaceModel extends ClickupSpace {
  const ClickupSpaceModel({
    super.id,
  });

  factory ClickupSpaceModel.fromJson(dynamic json) {
    return ClickupSpaceModel(id: json['id']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    return map;
  }
}

/// id : "1"
/// name : "Folder"
/// hidden : false
/// access : true

class ClickupFolderModel extends ClickupFolder {
  const ClickupFolderModel({
    super.id,
    super.name,
    super.hidden,
    super.access,
  });

  factory ClickupFolderModel.fromJson(dynamic json) {
    return ClickupFolderModel(
      id: json['id'],
      name: json['name'],
      hidden: json['hidden'],
      access: json['access'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['hidden'] = hidden;
    map['access'] = access;
    return map;
  }
}

/// id : "1"
/// name : "Folder"
/// hidden : false
/// access : true

class ClickupProjectModel extends ClickupProject {
  const ClickupProjectModel({
    super.id,
    super.name,
    super.hidden,
    super.access,
  });

  factory ClickupProjectModel.fromJson(dynamic json) {
    return ClickupProjectModel(
      id: json['id'],
      name: json['name'],
      hidden: json['hidden'],
      access: json['access'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['hidden'] = hidden;
    map['access'] = access;
    return map;
  }
}

/// id : "1"
/// name : "List"
/// access : true

class ClickupListModel extends ClickupList {
  const ClickupListModel({
    super.id,
    super.name,
    super.access,
  });

  factory ClickupListModel.fromJson(dynamic json) {
    return ClickupListModel(
      id: json['id'],
      name: json['name'],
      access: json['access'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['access'] = access;
    return map;
  }
}

/// id : "be43f58e-989e-4233-9f25-27584f094b74"
/// name : "Location type Custom Field"
/// type : "location"
/// type_config : {}
/// date_created : "1617765143523"
/// hide_from_guests : false
/// required : false

class ClickupCustomFieldsModel extends ClickupCustomFields {
  const ClickupCustomFieldsModel({
    super.id,
    super.name,
    super.type,
    super.typeConfig,
    super.dateCreated,
    super.hideFromGuests,
    super.required,
  });

  factory ClickupCustomFieldsModel.fromJson(dynamic json) {
    return ClickupCustomFieldsModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      typeConfig: json['type_config'],
      dateCreated: json['date_created'],
      hideFromGuests: json['hide_from_guests'],
      required: json['required'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['type'] = type;
    map['type_config'] = typeConfig;
    map['date_created'] = dateCreated;
    map['hide_from_guests'] = hideFromGuests;
    map['required'] = required;
    return map;
  }
}

/// name : "tagged"
/// tag_fg : "#000000"
/// tag_bg : "#000000"

class ClickupTagsModel extends ClickupTags {
  const ClickupTagsModel({
    super.name,
    super.tagFg,
    super.tagBg,
  });

  factory ClickupTagsModel.fromJson(dynamic json) {
    return ClickupTagsModel(
      name: json['name'],
      tagFg: json['tag_fg'],
      tagBg: json['tag_bg'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['tag_fg'] = tagFg;
    map['tag_bg'] = tagBg;
    return map;
  }
}

/// id : "d41340bc-2f17-43cc-ae71-86628f45825f"
/// task_id : "3cxv9f"
/// name : "Checklist"
/// date_created : "1618455803730"
/// orderindex : 1
/// creator : 2770032
/// resolved : 0
/// unresolved : 1
/// items : [{"id":"9398cb3d-55a4-4c45-ab46-2a47a371e375","name":"checklist item 1","orderindex":0,"assignee":null,"resolved":false,"parent":null,"date_created":"1618455810454","children":[]}]

class ClickupChecklistsModel extends ClickupChecklists {
  const ClickupChecklistsModel({
    super.id,
    super.taskId,
    super.name,
    super.dateCreated,
    super.orderIndex,
    super.creator,
    super.resolved,
    super.unresolved,
    super.items,
  });

  factory ClickupChecklistsModel.fromJson(dynamic json) {
    List<ClickupItems>? items;

    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(ClickupItemsModel.fromJson(v));
      });
    }
    return ClickupChecklistsModel(
        id: json['id'],
        taskId: json['task_id'],
        name: json['name'],
        dateCreated: json['date_created'],
        orderIndex: json['orderindex'],
        creator: json['creator'],
        resolved: json['resolved'],
        unresolved: json['unresolved'],
        items: items);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['task_id'] = taskId;
    map['name'] = name;
    map['date_created'] = dateCreated;
    map['orderindex'] = orderIndex;
    map['creator'] = creator;
    map['resolved'] = resolved;
    map['unresolved'] = unresolved;
    if (items != null) {
      map['items'] = items;
    }
    return map;
  }
}

/// id : "9398cb3d-55a4-4c45-ab46-2a47a371e375"
/// name : "checklist item 1"
/// orderindex : 0
/// assignee : null
/// resolved : false
/// parent : null
/// date_created : "1618455810454"
/// children : []

class ClickupItemsModel extends ClickupItems {
  const ClickupItemsModel({
    super.id,
    super.name,
    super.orderIndex,
    super.assignee,
    super.resolved,
    super.parent,
    super.dateCreated,
    super.children,
  });

  factory ClickupItemsModel.fromJson(dynamic json) {
    List<String>? children;
    if (json['children'] != null) {
      children = [];
      json['children'].forEach((v) {
        children?.add(v);
      });
    }
    return ClickupItemsModel(
        id: json['id'],
        name: json['name'],
        orderIndex: json['orderindex'],
        assignee: json['assignee'],
        resolved: json['resolved'],
        parent: json['parent'],
        dateCreated: json['date_created'],
        children: children);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['orderindex'] = orderIndex;
    map['assignee'] = assignee;
    map['resolved'] = resolved;
    map['parent'] = parent;
    map['date_created'] = dateCreated;
    if (children != null) {
      map['children'] = children;
    }
    return map;
  }
}

/// id : 123
/// username : "John Doe"
/// color : "#000000"
/// email : "johndoe@website.com"
/// profilePicture : "https://clickup.com/avatar.jpg"

class ClickupWatchersModel extends ClickupWatchers {
  const ClickupWatchersModel({
    super.id,
    super.username,
    super.color,
    super.email,
    super.profilePicture,
  });

  factory ClickupWatchersModel.fromJson(dynamic json) {
    return ClickupWatchersModel(
      id: json['id'],
      username: json['username'],
      color: json['color'],
      email: json['email'],
      profilePicture: json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['username'] = username;
    map['color'] = color;
    map['email'] = email;
    map['profilePicture'] = profilePicture;
    return map;
  }
}

/// id : 123
/// username : "John Doe"
/// color : "#000000"
/// email : "johndoe@website.com"
/// profilePicture : "https://clickup.com/avatar.jpg"

class ClickupAssigneesModel extends ClickupAssignees {
  const ClickupAssigneesModel({
    super.id,
    super.username,
    super.color,
    super.email,
    super.profilePicture,
  });

  factory ClickupAssigneesModel.fromJson(dynamic json) {
    return ClickupAssigneesModel(
      id: json['id'],
      username: json['username'],
      color: json['color'],
      email: json['email'],
      profilePicture: json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['username'] = username;
    map['color'] = color;
    map['email'] = email;
    map['profilePicture'] = profilePicture;
    return map;
  }
}

/// id : 123
/// username : "John Doe"
/// color : "#000000"
/// email : "johndoe@website.com"
/// profilePicture : "https://clickup.com/avatar.jpg"

class ClickupCreatorModel extends ClickupCreator {
  const ClickupCreatorModel({
    super.id,
    super.username,
    super.color,
    super.email,
    super.profilePicture,
  });

  factory ClickupCreatorModel.fromJson(dynamic json) {
    return ClickupCreatorModel(
      id: json['id'],
      username: json['username'],
      color: json['color'],
      email: json['email'],
      profilePicture: json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['username'] = username;
    map['color'] = color;
    map['email'] = email;
    map['profilePicture'] = profilePicture;
    return map;
  }
}

/// status : "Open"
/// type : "open"
/// orderindex : 1
/// color : "#000000"

class ClickupStatusModel extends ClickupStatus {
  const ClickupStatusModel({
    super.status,
    super.type,
    super.orderIndex,
    super.color,
  });

  factory ClickupStatusModel.fromJson(dynamic json) {
    return ClickupStatusModel(
      status: json['status'],
      type: json['type'],
      orderIndex: json['orderindex'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['type'] = type;
    map['orderindex'] = orderIndex;
    map['color'] = color;
    return map;
  }
}