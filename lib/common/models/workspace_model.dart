import 'package:thetimeblockingapp/common/entities/workspace.dart';


abstract class WorkspaceModel extends Workspace {
  const WorkspaceModel({
    super.id,
    super.name,
    super.color,
    super.avatar,
    super.members,
  });

  WorkspaceModel fromJson(dynamic json);


  Map<String, dynamic> toJson() ;
}
