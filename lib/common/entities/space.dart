import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/common/entities/folder.dart';

import 'tag.dart';
import 'tasks_list.dart';
import 'user.dart';
import 'workspace.dart';

class Space extends Equatable {
  const Space({
    this.id,
    this.name,
    this.color,
    this.workspaceId,
    this.folders = const[],
    this.lists = const[],
    this.tags = const<Tag>[],
  });

  final String? id;
  final String? name;
  final String? color;
  final String? workspaceId;
  final List<Folder>? folders;
  final List<TasksList>? lists;
  final List<Tag>? tags;

  @override
  List<Object?> get props => [id,
    name,
    color,
    workspaceId,
    folders,
    lists,
    tags,
  ];

  Space copyWith({
    String? id,
    String? name,
    String? color,
    String? workspaceId,
    List<Folder>? folders,
    List<TasksList>? lists,
    List<Tag>? tags,
  }) {
    return Space(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      workspaceId: workspaceId ?? this.workspaceId,
      folders: folders ?? this.folders,
      lists: lists ?? this.lists,
      tags: tags ?? this.tags,
    );
  }
}


extension SpaceListExtensions on List<Space>{

  static List<Space>? updateItemInList(
      {required List<Space>? list,
      required Space ? updatedSpace}) {
    printDebug("updateItemInList $list");
    List<Space>? result;
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