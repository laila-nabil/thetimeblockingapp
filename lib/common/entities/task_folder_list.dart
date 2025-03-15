import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/tasks_list.dart';

import 'folder.dart';

class TaskFolderList extends Equatable{
  final Folder? folder;
  final TasksList list;

  TaskFolderList({required this.folder, required this.list});

  String? get name{
    if(folder == null){
      return list.name;
    }
    return "${folder?.name}/${list.name}";
  }

  String? get id{
    return _idFromFolderList(folderId: folder?.id,listId: list.id ?? "");
  }

  bool isSameId({String? folderId,required String listId,}){
    return id == _idFromFolderList(folderId: folderId,listId: listId);
  }

  String? _idFromFolderList({String? folderId,required String listId,}){
    if(folderId == null){
      return list.id;
    }
    return "${folderId}${listId}";
  }

  @override
  List<Object?> get props => [folder,list];
}