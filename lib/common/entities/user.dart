import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    this.id,
    this.email,
    this.color,
  });

  final String? id;
  final String? email;
  final String? color;

  @override
  List<Object?> get props => [
        id,
        email,
        color,
      ];
}
