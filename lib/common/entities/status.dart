import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/extensions.dart';

class TaskStatus extends Equatable {
  final String? id;
  final String? name;
  final String? color;
  final bool? isDone;

  const TaskStatus(
      {required this.id,
      required this.name,
      required this.color,
      required this.isDone});

  @override
  List<Object?> get props => [id, name, color, isDone];

  Color? get getColor => HexColor.fromHex(color??"");
}

extension ExTaskStatus on List<TaskStatus>{
  TaskStatus? get completedStatus{
    return where((s)=>s.isDone == true).firstOrNull ;
  }
}