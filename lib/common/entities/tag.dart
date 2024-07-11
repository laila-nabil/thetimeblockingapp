import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/models/supabase_tag_model.dart';
import 'package:thetimeblockingapp/core/extensions.dart';

class Tag extends Equatable{
  final String? id;
  final String? name;
  final String? workspaceId;
  final String? color;

  const Tag({required this.id, required this.name, required this.workspaceId, required this.color});

  TagModel get getModel => this as TagModel;

  Color? get getColor => HexColor.fromHex(color??"");

  @override
  List<Object?> get props => [id,name,workspaceId,color];

  Tag copyWith({
    String? id,
    String? name,
    String? workspaceId,
    String? color,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      workspaceId: workspaceId ?? this.workspaceId,
      color: color ?? this.color,
    );
  }
}