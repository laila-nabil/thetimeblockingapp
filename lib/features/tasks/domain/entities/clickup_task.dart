import 'package:equatable/equatable.dart';

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

class ClickupTask extends Equatable {
  const ClickupTask({
    this.id,
    this.customId,
    this.name,
    this.textContent,
    this.description,
    this.status,
    this.orderIndex,
    this.dateCreated,
    this.dateUpdated,
    this.dateClosed,
    this.dateDone,
    this.creator,
    this.assignees,
    this.watchers,
    this.checklists,
    this.tags,
    this.parent,
    this.priority,
    this.dueDate,
    this.startDate,
    this.points,
    this.timeEstimate,
    this.customFields,
    this.dependencies,
    this.linkedTasks,
    this.teamId,
    this.url,
    this.permissionLevel,
    this.list,
    this.project,
    this.folder,
    this.space,
  });

  final String? id;
  final String? customId;
  final String? name;
  final String? textContent;
  final String? description;
  final ClickupStatus? status;
  final String? orderIndex;
  final String? dateCreated;
  final String? dateUpdated;
  final String? dateClosed;
  final String? dateDone;
  final ClickupCreator? creator;
  final List<ClickupAssignees>? assignees;
  final List<ClickupWatchers>? watchers;
  final List<ClickupChecklists>? checklists;
  final List<ClickupTags>? tags;
  final String? parent;
  final num? priority;
  final String? dueDate;
  final String? startDate;
  final num? points;
  final num? timeEstimate;
  final List<ClickupCustomFields>? customFields;
  final List<String>? dependencies;
  final List<String>? linkedTasks;
  final String? teamId;
  final String? url;
  final String? permissionLevel;
  final ClickupList? list;
  final ClickupProject? project;
  final ClickupFolder? folder;
  final ClickupSpace? space;

  @override
  List<Object?> get props => [
        id,
        customId,
        name,
        textContent,
        description,
        status,
        orderIndex,
        dateCreated,
        dateUpdated,
        dateClosed,
        dateDone,
        creator,
        assignees,
        watchers,
        checklists,
        tags,
        parent,
        priority,
        dueDate,
        startDate,
        points,
        timeEstimate,
        customFields,
        dependencies,
        linkedTasks,
        teamId,
        url,
        permissionLevel,
        list,
        project,
        folder,
        space,
      ];
}

/// id : "1"

class ClickupSpace extends Equatable {
  const ClickupSpace({
    this.id,
  });

  final String? id;

  @override
  List<Object?> get props => [id];
}

/// id : "1"
/// name : "Folder"
/// hidden : false
/// access : true

class ClickupFolder extends Equatable {
  const ClickupFolder({
    this.id,
    this.name,
    this.hidden,
    this.access,
  });

  final String? id;
  final String? name;
  final bool? hidden;
  final bool? access;

  @override
  List<Object?> get props => [
        id,
        name,
        hidden,
        access,
      ];
}

/// id : "1"
/// name : "Folder"
/// hidden : false
/// access : true

class ClickupProject extends Equatable {
  const ClickupProject({
    this.id,
    this.name,
    this.hidden,
    this.access,
  });

  final String? id;
  final String? name;
  final bool? hidden;
  final bool? access;

  @override
  List<Object?> get props => [
        id,
        name,
        hidden,
        access,
      ];
}

/// id : "1"
/// name : "List"
/// access : true

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

/// id : "be43f58e-989e-4233-9f25-27584f094b74"
/// name : "Location type Custom Field"
/// type : "location"
/// type_config : {}
/// date_created : "1617765143523"
/// hide_from_guests : false
/// required : false

class ClickupCustomFields extends Equatable {
  const ClickupCustomFields({
    this.id,
    this.name,
    this.type,
    this.typeConfig,
    this.dateCreated,
    this.hideFromGuests,
    this.required,
  });

  final String? id;
  final String? name;
  final String? type;
  final dynamic typeConfig;
  final String? dateCreated;
  final bool? hideFromGuests;
  final bool? required;

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        typeConfig,
        dateCreated,
        hideFromGuests,
        required,
      ];
}

/// name : "tagged"
/// tag_fg : "#000000"
/// tag_bg : "#000000"

class ClickupTags extends Equatable {
  const ClickupTags({
    this.name,
    this.tagFg,
    this.tagBg,
  });

  final String? name;
  final String? tagFg;
  final String? tagBg;

  @override
  List<Object?> get props => [
        name,
        tagFg,
        tagBg,
      ];
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

class ClickupChecklists extends Equatable {
  const ClickupChecklists({
    this.id,
    this.taskId,
    this.name,
    this.dateCreated,
    this.orderIndex,
    this.creator,
    this.resolved,
    this.unresolved,
    this.items,
  });

  final String? id;
  final String? taskId;
  final String? name;
  final String? dateCreated;
  final num? orderIndex;
  final num? creator;
  final num? resolved;
  final num? unresolved;
  final List<ClickupItems>? items;

  @override
  List<Object?> get props => [
        id,
        taskId,
        name,
        dateCreated,
        orderIndex,
        creator,
        resolved,
        unresolved,
        items,
      ];
}

/// id : "9398cb3d-55a4-4c45-ab46-2a47a371e375"
/// name : "checklist item 1"
/// orderindex : 0
/// assignee : null
/// resolved : false
/// parent : null
/// date_created : "1618455810454"
/// children : []

class ClickupItems extends Equatable {
  const ClickupItems({
    this.id,
    this.name,
    this.orderIndex,
    this.assignee,
    this.resolved,
    this.parent,
    this.dateCreated,
    this.children,
  });

  final String? id;
  final String? name;
  final num? orderIndex;
  final String? assignee;
  final bool? resolved;
  final String? parent;
  final String? dateCreated;
  final List<String>? children;

  @override
  List<Object?> get props => [
        id,
        name,
        orderIndex,
        assignee,
        resolved,
        parent,
        dateCreated,
        children,
      ];
}

/// id : 123
/// username : "John Doe"
/// color : "#000000"
/// email : "johndoe@website.com"
/// profilePicture : "https://clickup.com/avatar.jpg"

class ClickupWatchers extends Equatable {
  const ClickupWatchers({
    this.id,
    this.username,
    this.color,
    this.email,
    this.profilePicture,
  });

  final num? id;
  final String? username;
  final String? color;
  final String? email;
  final String? profilePicture;

  @override
  List<Object?> get props => [
        id,
        username,
        color,
        email,
        profilePicture,
      ];
}

/// id : 123
/// username : "John Doe"
/// color : "#000000"
/// email : "johndoe@website.com"
/// profilePicture : "https://clickup.com/avatar.jpg"

class ClickupAssignees extends Equatable {
  const ClickupAssignees({
    this.id,
    this.username,
    this.color,
    this.email,
    this.profilePicture,
  });

  final num? id;
  final String? username;
  final String? color;
  final String? email;
  final String? profilePicture;

  @override
  List<Object?> get props => [
        id,
        username,
        color,
        email,
        profilePicture,
      ];
}

/// id : 123
/// username : "John Doe"
/// color : "#000000"
/// email : "johndoe@website.com"
/// profilePicture : "https://clickup.com/avatar.jpg"

class ClickupCreator extends Equatable {
  const ClickupCreator({
    this.id,
    this.username,
    this.color,
    this.email,
    this.profilePicture,
  });

  final num? id;
  final String? username;
  final String? color;
  final String? email;
  final String? profilePicture;

  @override
  List<Object?> get props => [
        id,
        username,
        color,
        email,
        profilePicture,
      ];
}

/// status : "Open"
/// type : "open"
/// orderindex : 1
/// color : "#000000"

class ClickupStatus extends Equatable {
  const ClickupStatus({
    this.status,
    this.type,
    this.orderIndex,
    this.color,
  });

  final String? status;
  final String? type;
  final num? orderIndex;
  final String? color;

  @override
  List<Object?> get props => [
        status,
        type,
        orderIndex,
        color,
      ];
}
