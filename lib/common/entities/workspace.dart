import 'package:equatable/equatable.dart';

import 'user.dart';

class Workspace extends Equatable {
  const Workspace({
    this.id,
    this.name,
    this.color,
    this.avatar,
    this.user,
  });

  final String? id;
  final String? name;
  final String? color;
  final String? avatar;
  final User? user;

  @override
  List<Object?> get props => [
        id,
        name,
        color,
        avatar,
        user,
      ];
}