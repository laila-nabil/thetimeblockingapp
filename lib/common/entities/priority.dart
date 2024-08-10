import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/extensions.dart';

class TaskPriority extends Equatable{
  final String? id;
  final String? name;
  final String? color;

  Color? get getColor =>  HexColor.fromHex(color??"");

  const TaskPriority({required this.id, required this.name, required this.color});

  @override
  List<Object?> get props => [id,name,color];
}