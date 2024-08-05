import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';
import 'package:timezone/timezone.dart' as tz;

class User extends Equatable {
  const User({
    this.id,
    this.email,
    this.color,
  });

  final num? id;
  final String? email;
  final String? color;

  @override
  List<Object?> get props => [
        id,
        email,
        color,
      ];
}
