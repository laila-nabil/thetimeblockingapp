import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    this.id,
    this.email,
    this.color,
    this.isAnonymous,
  });

  final String? id;
  final String? email;
  final String? color;
  final bool? isAnonymous;
  @override
  List<Object?> get props => [
        id,
        email,
        color,
        isAnonymous
      ];
}
