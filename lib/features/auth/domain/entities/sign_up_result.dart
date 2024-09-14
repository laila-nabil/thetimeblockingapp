import 'package:equatable/equatable.dart';

class SignUpResult extends Equatable {
  const SignUpResult({
    this.id,
    this.aud,
    this.role,
    this.email,
    this.phone,
    this.confirmationSentAt,
  });

  final String? id;
  final String? aud;
  final String? role;
  final String? email;
  final String? phone;
  final String? confirmationSentAt;

  @override
  List<Object?> get props => [
        id,
        aud,
        role,
        email,
        phone,
        confirmationSentAt,
      ];
}
