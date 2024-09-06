import 'package:equatable/equatable.dart';

import 'space.dart';
import 'tag.dart';

class Workspace extends Equatable {
  const Workspace({
    this.id,
    this.name,
    this.color,
    this.userId,
    this.spaces,
    this.tags,
  });

  final int? id;
  final String? name;
  final String? color;
  final String? userId;
  final List<Space>? spaces;
  final List<Tag>? tags;

  @override
  List<Object?> get props => [
        id,
        name,
        color,
        userId,
        spaces,
        tags
      ];
}