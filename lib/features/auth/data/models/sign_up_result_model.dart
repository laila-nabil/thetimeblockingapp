import '../../domain/entities/sign_up_result.dart';

/// id : "ab00127f-6bd6-4b65-96f9-c5c78622e885"
/// aud : "authenticated"
/// role : "authenticated"
/// email : "testtimeblockingapp3@outlook.com"
/// phone : ""
/// confirmation_sent_at : "2024-09-14T22:03:08.807395673Z"

class SignUpResultModel extends SignUpResult {
  const SignUpResultModel({
    super.id,
    super.aud,
    super.role,
    super.email,
    super.phone,
    super.confirmationSentAt,
  });

  factory SignUpResultModel.fromJson(dynamic json) {
    return SignUpResultModel(
      id: json['id'],
      aud: json['aud'],
      role: json['role'],
      email: json['email'],
      phone: json['phone'],
      confirmationSentAt: json['confirmation_sent_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['aud'] = aud;
    map['role'] = role;
    map['email'] = email;
    map['phone'] = phone;
    map['confirmation_sent_at'] = confirmationSentAt;
    return map;
  }
}
