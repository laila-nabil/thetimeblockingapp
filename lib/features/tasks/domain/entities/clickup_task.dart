import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import '../../../../core/extensions.dart';
import 'clickup_folder.dart';
import 'clickup_list.dart';
import 'clickup_space.dart';

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
    this.dateCreatedUtcTimestamp,
    this.dateUpdatedUtcTimestamp,
    this.dateClosedUtcTimestamp,
    this.dateDoneUtcTimestamp,
    this.creator,
    this.assignees,
    this.watchers,
    this.checklists,
    this.tags,
    this.parent,
    this.priority,
    this.dueDateUtcTimestamp,
    this.startDateUtcTimestamp,
    this.points,
    this.timeEstimateMilliseconds,
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
  final String? dateCreatedUtcTimestamp;
  final String? dateUpdatedUtcTimestamp;
  final String? dateClosedUtcTimestamp;
  final String? dateDoneUtcTimestamp;
  final ClickupCreator? creator;
  final List<ClickupAssignee>? assignees;
  final List<ClickupWatchers>? watchers;
  final List<ClickupChecklists>? checklists;
  final List<ClickupTag>? tags;
  final String? parent;
  final ClickupTaskPriority? priority;
  final String? dueDateUtcTimestamp;
  final String? startDateUtcTimestamp;
  final num? points;
  final num? timeEstimateMilliseconds;
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

  ///How are dates formatted in ClickUp?
  /// ClickUp will always display dates in Unix time in milliseconds. You can use a website like Epoch Converter to convert dates between Unix and human readable date formats.
  /// 
  /// What timezone does your API use for timestamps?
  /// Our API always returns timestamps in UTC (Coordinated Universal Time).
  /// 
  /// The start date and due date on tasks that don't have a start or due time will default to 4 am in the local time zone of the user who added the start or due date.
  /// 
  /// If that user changes their timezone later, task start dates and due dates will not be retroactively updated.
  /// [https://clickup.com/api/developer-portal/faq/]
  bool get isAllDay {
    ///FIXME A if a task due time is 4 am and no start date,it is viewed as all day event
    printDebug("for $name,dueDate: $dueDateUtc and startDate: $startDateUtc");
    return (startDateUtc == null || startDateUtc == dueDateUtc) &&
        dueDateUtc != null && dueDateUtc?.hour == 4 && dueDateUtc?.second == 0 ;
  }

  DateTime? get dateCreatedUtc =>
      DateTimeExtensions.getDateTimeFromString(date: dateCreatedUtcTimestamp);

  DateTime? get dateClosedUtc =>
      DateTimeExtensions.getDateTimeFromString(date: dateClosedUtcTimestamp);

  DateTime? get dateDoneUtc =>
      DateTimeExtensions.getDateTimeFromString(date: dateDoneUtcTimestamp);

  DateTime? get dateUpdatedUtc =>
      DateTimeExtensions.getDateTimeFromString(date: dateUpdatedUtcTimestamp);

  DateTime? get dueDateUtc =>
      DateTimeExtensions.getDateTimeFromString(date: dueDateUtcTimestamp);

  DateTime? get startDateUtc =>
      DateTimeExtensions.getDateTimeFromString(date: startDateUtcTimestamp);

  Duration? get timeEstimate => timeEstimateMilliseconds == null
      ? null
      : Duration(seconds: timeEstimateMilliseconds!.toInt());

  @override
  List<Object?> get props => [
        id,
        customId,
        name,
        textContent,
        description,
        status,
        orderIndex,
        dateCreatedUtcTimestamp,
        dateUpdatedUtcTimestamp,
        dateClosedUtcTimestamp,
        dateDoneUtcTimestamp,
        creator,
        assignees,
        watchers,
        checklists,
        tags,
        parent,
        priority,
        dueDateUtcTimestamp,
        startDateUtcTimestamp,
        points,
        timeEstimateMilliseconds,
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

class ClickupTag extends Equatable {
  const ClickupTag({
    this.name,
    this.tagFg,
    this.tagBg,
  });

  final String? name;
  final String? tagFg;
  final String? tagBg;

  Color? get  getTagFgColor => HexColor.fromHex(tagFg??"");

  Color? get  getTagBgColor => HexColor.fromHex(tagBg??"");

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
/// initials : LN

class ClickupAssignee extends Equatable {
  const ClickupAssignee({
    this.id,
    this.username,
    this.color,
    this.email,
    this.profilePicture,
    this.initials,
  });

  final num? id;
  final String? username;
  final String? color;
  final String? email;
  final String? profilePicture;
  final String? initials;
  String? get getInitialsFromUserName {
    if (username == null) {
      return null;
    }
    return username?.contains(" ") == true
        ? username?.splitMapJoin(
            " ",
            onNonMatch: (m) => m.characters.toList().tryElementAt(0) ?? "",
          )
        : (username!.length > 2)
            ? username!.substring(0, 1)
            : username;
  }

  @override
  List<Object?> get props => [
        id,
        username,
        color,
        email,
        profilePicture,
        initials,
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

///ex 1 :
///priorityNum : 1
///isNum: true
///
///ex 2 :
///isNum: false
///"color": "#ffcc00",
///"id": "2",
///"orderindex": "2",
///"priority": "high"
///
class ClickupTaskPriority extends Equatable {
  final bool isNum;
  final num? priorityNum;
  final String? color;
  final String? id;
  final String? orderIndex;
  final String? priority;

  const ClickupTaskPriority(
      {required this.isNum,
      this.priorityNum,
      this.color,
      this.id,
      this.orderIndex,
      this.priority});


  int? get getPriorityNum {
    if(isNum == true && priorityNum!=null){
      return priorityNum!.toInt();
    }else if(isNum == false && id !=null && int.tryParse(id??"") !=null){
      return int.parse(id??"");
    }
    return null;
  }

  String get getPriorityExclamation {
  if(isNum == true && priorityNum!=null){
    return  "!" * (4 - priorityNum!.toInt());
  }else if(isNum == false && id !=null && int.tryParse(id??"") !=null){
    return  "!" * (4 - int.parse(id??""));
  }
  return "";
 }

 List<ClickupTaskPriority>? get getPriorityExclamationListOrNull {
    if(isNum == false){
      return null;
    }
    return List.generate(
        4, (index) => ClickupTaskPriority(isNum: true, priorityNum: index));
  }

  Color? get getPriorityColor {
    if(isNum == false && color !=null && color?.isNotEmpty == true){
      return HexColor.fromHex(color??"");
    }
    return null;
 }

  @override
  List<Object?> get props =>
      [isNum, priorityNum, color, id, orderIndex, priority];
}
