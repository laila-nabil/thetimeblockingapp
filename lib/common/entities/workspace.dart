import 'package:equatable/equatable.dart';

import 'space.dart';
import 'user.dart';

class Workspace extends Equatable {
  const Workspace({
    this.id,
    this.name,
    this.color,
    this.userId,
    this.spaces,
  });

  final int? id;
  final String? name;
  final String? color;
  final String? userId;
  final List<Space>? spaces;

  @override
  List<Object?> get props => [
        id,
        name,
        color,
        userId,
        spaces
      ];
}